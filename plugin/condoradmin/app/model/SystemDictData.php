<?php

namespace plugin\condoradmin\app\model;

use support\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Respect\Validation\Validator as v;

class SystemDictData extends Model
{
    use SoftDeletes;
    /**
     * @var string
     */
    protected $table = 'system_dict_data';

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
            'label' => v::NotEmpty()->setName('名称'),
            'value' => v::optional(v::anyOf(v::equals(0), v::equals('0'), v::notEmpty()))->setName('值'),
            'type_id' => v::NotEmpty()->number()->setName('字典类型'),
            'color' => v::optional(v::NotEmpty())->setName('颜色'),
            'weigh' => v::optional(v::number())->setName('权重'),
            'remark' => v::optional(v::NotEmpty())->setName('备注'),
            'status' => v::in([1, 2])->setName('状态'),
        ];
    }
}
