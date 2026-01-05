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
            'name' => v::NotEmpty()->setName('名称'),
            'rules' => v::optional(v::NotEmpty())->setName('权限规则'),
            'pid' => v::optional(v::number())->setName('父级ID'),
            // 字母、数字、下划线
            'code' => v::optional(v::alnum('_')->noWhitespace())->setName('角色标识'),
            'status' => v::in([1,2])->setName('状态'),
        ];
    }
}
