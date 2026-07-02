<?php

declare(strict_types=1);

namespace plugin\condoradmin\app\model;

use plugin\condoradmin\app\library\StorageService;
use Respect\Validation\Validator as v;
use support\Model;
use support\Log;

class SystemAttachment extends Model
{
    /**
     * @var string
     */
    protected $table = 'system_attachment';

    /**
     * @var string
     */
    protected $primaryKey = 'id';

    /**
     * 指示是否自动维护时间戳
     *
     * @var bool
     */
    public $timestamps = true;

    protected $dateFormat = 'U';

    protected $appends = ['type_name'];

    // 定义时间戳字段名
    const CREATED_AT = 'createtime';
    const UPDATED_AT = 'updatetime';

    // 让所有属性都可以批量分配
    protected $guarded = [];


    protected function serializeDate(\DateTimeInterface $date)
    {
        return $date->format('Y-m-d H:i:s');
    }

    /**
     * 获取允许上传的文件类型
     * @return void
     */
    public function getAllowedMimeType()
    {
        return [
            'image/jpeg' => 'jpg',
            'image/jpg' => 'jpg',
            'image/png' => 'png',
            'image/gif' => 'gif',
            'image/ico' => 'ico',
            'image/webp' => 'webp',
            'image/tiff' => 'tiff',
            'application/pdf' => 'pdf',
            'application/msword' => 'doc',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => 'docx',
            'application/vnd.ms-excel' => 'xls',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => 'xlsx',
            'application/vnd.ms-powerpoint' => 'ppt',
            'application/vnd.openxmlformats-officedocument.presentationml.presentation' => 'pptx',
            'application/zip' => 'zip',
            'application/rar' => 'rar',
            'text/plain' => 'txt',
            'video/mp4' => 'mp4',
            'video/ogg' => 'ogg',
            'video/webm' => 'webm',
            'audio/mpeg' => 'mp3',
            'audio/ogg' => 'ogg',
            'audio/wav' => 'wav'
        ];
    }

    /**
     * 验证文件类型
     * @param [type] $mimetype
     * @return void
     */
    public function validFileMimeType($mimetype)
    {
        $mimetypeList = array_keys($this->getAllowedMimeType());
        return in_array(strtolower($mimetype), $mimetypeList);
    }

    /**
     * 获取文件类型
     * @param [type] $mimetype
     * @return void
     */
    public function getFileType($mimetype)
    {
        if (v::in(['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/ico', 'image/webp', 'image/tiff'])->validate($mimetype)) {
            return 'image';
        } elseif (v::in(['video/mp4', 'video/ogg', 'video/webm'])->validate($mimetype)) {
            return 'video';
        } elseif (v::in(['audio/mpeg', 'audio/ogg', 'audio/wav'])->validate($mimetype)) {
            return 'audio';
        } elseif (v::in(['application/pdf'])->validate($mimetype)) {
            return 'pdf';
        } elseif (v::in(['application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'])->validate($mimetype)) {
            return 'word';
        } elseif (v::in(['application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'])->validate($mimetype)) {
            return 'excel';
        } elseif (v::in(['application/vnd.ms-powerpoint', 'application/vnd.openxmlformats-officedocument.presentationml.presentation'])->validate($mimetype)) {
            return 'ppt';
        } elseif (v::in(['application/zip', 'application/rar'])->validate($mimetype)) {
            return 'zip';
        } elseif (v::in(['text/plain'])->validate($mimetype)) {
            return 'txt';
        } else {
            return 'other';
        }
    }

    /**
     * 上传文件（委托给 StorageService，保留供历史调用兼容）
     * @param \Webman\Http\UploadFile $file
     * @param array $params
     * @return array
     */
    public function upload($file, $params = [])
    {
        return StorageService::upload($file, $params);
    }

    public function AttachmentType()
    {
        return $this->belongsTo(SystemAttachmentType::class, 'type_id');
    }

    /**
     * 获取名称属性，根据当前语言
     */
    public function getTypeNameAttribute()
    {
        $rows = $this->AttachmentType?->translations;
        if (empty($rows)) {
            return [
                'zh-cn' => '默认',
                'en-us' => 'Default'
            ];
        }
        $data = [];
        foreach ($rows as $row) {
            $data[$row->locale] = $row->name;
        }
        return !empty($data) ? $data : null;
    }
}
