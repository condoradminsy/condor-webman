<?php

namespace plugin\condoradmin\app\model;

use support\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Respect\Validation\Validator as v;

class SystemDictType extends Model
{
    use SoftDeletes;
    /**
     * @var string
     */
    protected $table = 'system_dict_type';

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
            'scope' => v::in([0, 1, 2])->setName(trans('fields.type.scope', [], 'dict'))->setTemplate(trans('common.validation.in')),
            'name' => v::optional(v::alnum('_')->noWhitespace())->setName(trans('fields.type.name', [], 'dict')),
            'status' => v::in([1, 2])->setName(trans('fields.type.status', [], 'dict'))->setTemplate(trans('common.validation.in')),
        ];
    }

    // 关联字典数据
    public function DictData()
    {
        return $this->hasMany(SystemDictData::class, 'type_id', 'id')
            ->select(['id', 'type_id', 'value', 'color'])
            ->where('status', 1)
            ->orderBy('weigh', 'asc');
    }

    /**
     * 关联翻译
     */
    public function translations()
    {
        return $this->hasMany(SystemDictTypeTranslations::class, 'main_id', 'id');
    }
}
