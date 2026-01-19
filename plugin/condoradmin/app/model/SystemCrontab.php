<?php

namespace plugin\condoradmin\app\model;

use support\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Respect\Validation\Validator as v;

class SystemCrontab extends Model
{
    use SoftDeletes;
    /**
     * @var string
     */
    protected $table = 'system_crontab';

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

    // 定义时间戳字段名
    const CREATED_AT = 'createtime';
    const UPDATED_AT = 'updatetime';

    // 让所有属性都可以批量分配
    protected $guarded = [];

    protected function serializeDate(\DateTimeInterface $date)
    {
        return $date->format('Y-m-d H:i:s');
    }

    public function rules()
    {
        return [
            'name' => v::NotEmpty()->setName('名称'),
            'target' => v::optional(v::notEmpty())->setName('调用任务'),
            'params' => v::optional(v::notEmpty())->setName('参数'),
            'cron_value' => v::notEmpty()->setName('表达式值'),
            'type' => v::NotEmpty()->number()->setName('类型'),
            'remark' => v::optional(v::NotEmpty())->setName('备注'),
            'status' => v::in([1, 2])->setName('状态'),
        ];
    }

    // 添加或更新，生成 cron
    protected static function booted()
    {
        parent::boot();
        
        static::saving(function ($model) {
            // 规则处理
            $cron_value = json_decode($model->cron_value, true);
            $type = $cron_value['type'];
            $minute = $cron_value['minute'];
            $hour = $cron_value['hour'];
            $week = $cron_value['week'];
            $day = $cron_value['day'];
            $month = $cron_value['month'];
            $second = $cron_value['second'];
            $rule = match ($type) {
                1 => "0 {$minute} {$hour} * * *",
                2 => "0 {$minute} * * * *",
                3 => "0 {$minute} */{$hour} * * *",
                4 => "0 */{$minute} * * * *",
                5 => "*/{$second} * * * * *",
                6 => "0 {$minute} {$hour} * * {$week}",
                7 => "0 {$minute} {$hour} {$day} * *",
                8 => "0 {$minute} {$hour} {$day} {$month} *",
                default => throw new \plugin\condoradmin\exception\ApiException("任务定时规则异常"),
            };
            $model->cron = $rule;
        });

        // 新增后，更新后，删除后，更新 crontab
        static::created(fn($model) => \plugin\condoradmin\app\service\SystemCrontab::reloadCrontab('add', $model->id));
        static::updated(fn($model) => \plugin\condoradmin\app\service\SystemCrontab::reloadCrontab('edit', $model->id));
        static::deleted(fn($model) => \plugin\condoradmin\app\service\SystemCrontab::reloadCrontab('del', $model->id));
    }
}
