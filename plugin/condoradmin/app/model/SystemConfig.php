<?php

namespace plugin\condoradmin\app\model;

use support\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Respect\Validation\Validator as v;

class SystemConfig extends Model
{
    use SoftDeletes;
    /**
     * @var string
     */
    protected $table = 'system_config';

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
            'key' => v::regex('/^[a-zA-Z0-9_]+$/')->setName(trans('fields.key', [], 'config'))->setTemplate(trans('fields.code.regex', [], 'config')),
            'value' => v::optional(v::NotEmpty())->setName(trans('fields.value', [], 'config')),
            'group_code' => v::NotEmpty()->setName(trans('fields.group.code', [], 'config'))->setTemplate(trans('common.validation.required')),
            'group_id' => v::number()->setName(trans('fields.group.id', [], 'config')),
            'type' => v::in(['number', 'string', 'textarea', 'switch', 'array', 'editor', 'date', 'image', 'images', 'datetime', 'daterange', 'dict'])->setName(trans('fields.type', [], 'config')),
            'is_visible' => v::in([0, 1])->setName(trans('fields.is.visible', [], 'config'))->setTemplate(trans('common.validation.in')),
            'weigh' => v::optional(v::number())->setName(trans('fields.weigh', [], 'config')),
            'dict_code' => v::optional(v::NotEmpty())->setName(trans('fields.dict.code', [], 'config')),
            'dict_type' => v::optional(v::NotEmpty())->setName(trans('fields.dict.type', [], 'config')),
            'status' => v::in([0, 1])->setName(trans('fields.status', [], 'config'))->setTemplate(trans('common.validation.in')),
        ];
    }

    // 添加或更新之前，校验group_id和group_code是否匹配
    protected static function booted()
    {
        parent::boot();

        static::saving(function ($model) {
            if ($model->group_code != \plugin\condoradmin\app\model\SystemConfigGroup::where('id', $model->group_id)->value('code')) {
                throw new \Exception(trans('mismatch.between.the.group.identifier.and.the.group.id', [], 'config'));
            };
        });
    }

    /**
     * 关联翻译
     */
    public function translations()
    {
        return $this->hasMany(SystemConfigTranslations::class, 'main_id', 'id');
    }
}
