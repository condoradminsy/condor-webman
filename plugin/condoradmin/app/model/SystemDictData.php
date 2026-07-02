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
            'value' => v::optional(v::anyOf(v::equals(0), v::equals('0'), v::notEmpty()))->setName(trans('fields.value', [], 'dict')),
            'type_id' => v::NotEmpty()->number()->setName(trans('fields.type_id', [], 'dict'))->setTemplate(trans('common.validation.required')),
            'color' => v::optional(v::NotEmpty())->setName(trans('fields.color', [], 'dict')),
            'weigh' => v::optional(v::number())->setName(trans('fields.weigh', [], 'dict')),
            'status' => v::in([1, 2])->setName(trans('fields.status', [], 'dict'))->setTemplate(trans('common.validation.in')),
        ];
    }

    /**
     * 关联翻译
     */
    public function translations()
    {
        return $this->hasMany(SystemDictDataTranslations::class, 'main_id', 'id');
    }
}
