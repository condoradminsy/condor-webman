<?php

namespace plugin\condoradmin\app\model;

use support\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Respect\Validation\Validator as v;

class SystemRole extends Model
{
    use SoftDeletes;
    /**
     * @var string
     */
    protected $table = 'system_role';

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
            'name' => v::NotEmpty()->setName(trans('fields.name', [], 'role'))->setTemplate(trans('condoradmin.validation.required')),
            'rules' => v::optional(v::NotEmpty())->setName(trans('fields.rules', [], 'role')),
            'pid' => v::optional(v::number())->setName(trans('fields.pid', [], 'role')),
            // 字母、数字、下划线
            'code' => v::optional(v::alnum('_')->noWhitespace())->setName(trans('fields.code', [], 'role')),
            'status' => v::in([1, 2])->setName(trans('fields.status', [], 'role'))->setTemplate(trans('condoradmin.validation.in')),
        ];
    }


    // 添加，更新和删除，更新缓存
    public static function boot()
    {
        parent::boot();

        static::saved(function ($model) {
            // 清除缓存
            \plugin\condoradmin\app\library\Auth::clearCacheByRoleId($model->id);
        });

        static::deleted(function ($model) {
            // 清除缓存
            \plugin\condoradmin\app\library\Auth::clearCacheByRoleId($model->id);
        });
    }
}
