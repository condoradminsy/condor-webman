<?php

namespace plugin\condorauth\app\model;

use support\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Respect\Validation\Validator as v;

class SystemUser extends Model
{
    use SoftDeletes;
    /**
     * @var string
     */
    protected $table = 'system_user';

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
            'username' => v::NotEmpty()->setName(trans('fields.username', [], 'user'))->setTemplate(trans('common.validation.required')),
            'nickname' => v::optional(v::notEmpty())->setName(trans('fields.nickname', [], 'user')),
            'password' => v::optional(v::length(6, 64))->setName(trans('fields.password', [], 'user'))->setTemplate(trans('common.validation.length.both')),
            'email' => v::optional(v::email())->setName(trans('fields.email', [], 'user'))->setTemplate(trans('common.validation.email')),
            'mobile' => v::optional(v::regex('/^1[3456789]\d{9}$/'))->setName(trans('fields.mobile', [], 'user'))->setTemplate(trans('common.validation.mobile')),
            'avatar' => v::optional(v::notEmpty())->setName(trans('fields.avatar', [], 'user')),
            'gender' => v::in([0, 1, 2])->setName(trans('fields.gender', [], 'user'))->setTemplate(trans('common.validation.in')),
            'status' => v::in([1, 2])->setName(trans('fields.status', [], 'adusermin'))->setTemplate(trans('common.validation.in')),
        ];
    }
}
