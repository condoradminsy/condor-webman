<?php

declare(strict_types=1);

namespace plugin\condoradmin\app\library;

use plugin\condoradmin\app\model\SystemAttachment;
use Tinywan\Storage\Exception\StorageException;
use Webman\Http\UploadFile;

/**
 * 统一文件上传服务
 *
 * 通过 tinywan/storage 各驱动 Adapter 完成实际上传，配置统一维护在
 * config/plugin/tinywan/storage/app.php，云驱动凭证从 .env 读取。
 * 上传完成后自动写入 system_attachment 表，返回统一结构。
 *
 * 调用示例：
 *   StorageService::upload($file, ['admin_id' => 1]);
 *   StorageService::upload($file, ['user_id' => 5, 'disk' => 'oss', 'path' => 'shop/goods']);
 */
class StorageService
{
    private const DEFAULTS = [
        'path'     => '',   // 自定义子目录，空则使用配置的 dirname（默认按日期）
        'admin_id' => 0,
        'user_id'  => 0,
        'type_id'  => 0,
        'extparam' => [],
        'disk'     => null, // null 则使用配置的默认驱动
    ];

    /**
     * 上传文件并写入附件表
     *
     * @param  UploadFile $file
     * @param  array      $options 见 DEFAULTS
     * @return array      {id, url, full_url, filename, filesize, storage}
     * @throws \RuntimeException
     */
    public static function upload(UploadFile $file, array $options = []): array
    {
        $options = array_merge(self::DEFAULTS, $options);

        if (!$file->isValid()) {
            throw new \RuntimeException(trans('condoradmin.invalid.file'));
        }

        $mimetype = strtolower($file->getUploadMimeType());
        $model    = new SystemAttachment();

        if (!$model->validFileMimeType($mimetype)) {
            throw new \RuntimeException(trans('condoradmin.invalid.file.type.uploaded'));
        }

        $disk       = $options['disk'] ?? config('plugin.tinywan.storage.app.storage.default', 'local');
        $diskConfig = config('plugin.tinywan.storage.app.storage.' . $disk);

        if (empty($diskConfig)) {
            throw new \RuntimeException("Storage disk [{$disk}] not configured.");
        }

        // tinywan Adapter 内部会 move/上传文件，需在此之前计算 sha1
        $sha1 = hash_file('sha1', $file->getRealPath());

        // 按需覆盖子目录（dirname 支持字符串或闭包）
        if (!empty($options['path'])) {
            $diskConfig['dirname'] = $options['path'];
        }

        // 委托 tinywan Adapter 完成实际上传（从 request()->file() 读取文件并 verify）
        $result = self::driveUpload($diskConfig);

        // tinywan 返回的 url 字段：
        // - local：domain（可空）+ uri + dirname + / + filename
        //   domain 配置为空串时，url 直接是 /uploads/date/hash.ext（相对路径）✓
        // - 云驱动：domain + / + dirname + / + filename（完整 CDN URL）
        $url     = $result['url'];
        $fullUrl = self::buildFullUrl($disk, $diskConfig, $url);

        $attachment = self::saveRecord([
            'url'      => $url,
            'storage'  => $disk,
            'filename' => $file->getUploadName(),
            'filesize' => $result['size'],
            'mimetype' => $mimetype,
            'sha1'     => $sha1,
            'admin_id' => $options['admin_id'],
            'user_id'  => $options['user_id'],
            'type_id'  => $options['type_id'],
            'extparam' => $options['extparam'],
        ]);

        return [
            'id'       => $attachment->id,
            'url'      => $url,
            'full_url' => $fullUrl,
            'filename' => $file->getUploadName(),
            'filesize' => $result['size'],
            'storage'  => $disk,
        ];
    }

    /**
     * 实例化 tinywan Adapter 完成上传，返回第一个文件的结果
     *
     * _is_file_upload=true：Adapter 从 request()->file() 读取文件并执行 verify()
     *
     * @throws \RuntimeException
     */
    private static function driveUpload(array $diskConfig): array
    {
        try {
            $adapterClass = $diskConfig['adapter'];
            /** @var \Tinywan\Storage\Adapter\AdapterAbstract $adapter */
            $adapter = new $adapterClass(array_merge($diskConfig, ['_is_file_upload' => true]));
            $results = $adapter->uploadFile([]);
        } catch (StorageException $e) {
            throw new \RuntimeException($e->getMessage());
        }

        if (empty($results)) {
            throw new \RuntimeException('Upload failed: no results returned from storage adapter.');
        }

        return $results[0];
    }

    /**
     * 构造 full_url
     *
     * - local + domain 为空：url 已是相对路径，拼上当前请求 host
     * - local + domain 有值：url 已含 domain，即为 full_url
     * - 云驱动：url 已是完整 CDN URL
     */
    private static function buildFullUrl(string $disk, array $diskConfig, string $url): string
    {
        if ($disk !== 'local') {
            return $url;
        }

        $domain = rtrim($diskConfig['domain'] ?? '', '/');
        if ($domain === '') {
            // domain 留空，url 为相对路径，拼上当前请求 host
            return '//' . request()->host() . $url;
        }

        // domain 已配置，url 本身就是 full_url
        return $url;
    }

    private static function saveRecord(array $data): SystemAttachment
    {
        $attachment           = new SystemAttachment();
        $attachment->url      = $data['url'];
        $attachment->storage  = $data['storage'];
        $attachment->filename = $data['filename'];
        $attachment->filesize = $data['filesize'];
        $attachment->mimetype = $data['mimetype'];
        $attachment->sha1     = $data['sha1'];
        $attachment->admin_id = $data['admin_id'];
        $attachment->user_id  = $data['user_id'];
        $attachment->type_id  = $data['type_id'];
        $attachment->extparam = json_encode($data['extparam']);
        $attachment->type     = $attachment->getFileType($data['mimetype']);
        $attachment->save();

        return $attachment;
    }
}
