<?php

namespace plugin\condoradmin\app\service;

use plugin\condoradmin\app\model\SystemConfig as ConfigModel;
use plugin\condoradmin\exception\ApiException;
use support\Redis;
use support\Db;
use support\Log;

class SystemConfig extends BaseService
{
    /**
     * 构造函数
     */
    public function __construct()
    {
        $this->model = new ConfigModel();
    }

    public function saveConfig($data, $group_code)
    {
        $keys = array_keys((array)$data);
        if (empty($keys)) {
            return true;
        }
        $list = $this->model->whereIn('key', $keys)->where('group_code', $group_code)->get();
        try {
            Db::beginTransaction();
            foreach ($list as $item) {
                $raw = $data[$item->key] ?? null;
                $value = is_array($raw) ? json_encode($raw) : $raw;
                $item->value = $value;
                $item->save();
                // 缓存（排除富文本与图片类型）
                if (!in_array($item->type, ['editor', 'images'])) {
                    $redisKey = 'config:' . $group_code . ':' . $item->key;
                    Redis::set($redisKey, $value);
                }
            }
            Db::commit();
        } catch (\Throwable $e) {
            Db::rollback();
            Log::error('保存系统配置失败：', [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            throw new ApiException(trans('condoradmin.configuration.saving.failed'));
        }
    }

    // 获取配置
    public function getConfig(string $key, string $group_code = 'base')
    {
        // 使用单独变量保存 Redis 键，避免与 DB 中的 key 字段混淆
        $redisKey = 'config:' . $group_code . ':' . $key;
        $value = Redis::get($redisKey);
        // Redis::get 可能返回 false|null，避免使用 empty() 误判 '0' 等合法值
        if ($value === null || $value === false) {
            $row = $this->model->where('group_code', $group_code)->where('key', $key)->first();
            if ($row) {
                $value = $row->value;
                Redis::set($redisKey, $value);
            } else {
                $value = '';
            }
        }
        return $value;
    }

    // 获取配置列表
    public static function config(string $key, string $group_code = 'base')
    {
        return (new self())->getConfig($key, $group_code);
    }
}
