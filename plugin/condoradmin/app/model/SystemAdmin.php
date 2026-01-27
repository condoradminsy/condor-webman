<?php

namespace plugin\condoradmin\app\model;

use support\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Respect\Validation\Validator as v;

class SystemAdmin extends Model
{
    use SoftDeletes;
    /**
     * @var string
     */
    protected $table = 'system_admin';

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

    public function RoleGroup()
    {
        return $this->hasMany(SystemRoleGroup::class, 'uid', 'id');
    }

    public function rules()
    {
        return [
            'nickname' => v::NotEmpty()->setName(trans('fields.nickname', [], 'admin'))->setTemplate(trans('condoradmin.validation.required')),
            'username' => v::NotEmpty()->setName(trans('fields.username', [], 'admin'))->setTemplate(trans('condoradmin.validation.required')),
            'password' => v::optional(v::length(6, 64))->setName(trans('fields.password', [], 'admin'))->setTemplate(trans('condoradmin.validation.length.both')),
            'email' => v::optional(v::email())->setName(trans('fields.email', [], 'admin'))->setTemplate(trans('condoradmin.validation.email')),
            'mobile' => v::optional(v::regex('/^1[3456789]\d{9}$/'))->setName(trans('fields.mobile', [], 'admin'))->setTemplate(trans('condoradmin.validation.mobile')),
            'status' => v::in([1, 2])->setName(trans('fields.status', [], 'admin'))->setTemplate(trans('condoradmin.validation.in')),
        ];
    }
}
