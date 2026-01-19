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
            'key' => v::regex('/^[a-zA-Z0-9_]+$/')->setName('变量名'),
            'value' => v::optional(v::NotEmpty())->setName('变量值'),
            'title' => v::NotEmpty()->setName('变量标题'),
            'group_code' => v::NotEmpty()->setName('分组标识'),
            'group_id' => v::number()->setName('分组ID'),
            'tips' => v::optional(v::NotEmpty())->setName('变量提示'),
            'type' => v::in(['number', 'string', 'textarea', 'switch', 'array', 'editor', 'date', 'image', 'images', 'datetime', 'daterange', 'dict'])->setName('类型'),
            'is_visible' => v::in([0, 1])->setName('可见条件'),
            'weigh' => v::optional(v::number())->setName('权重'),
            'dict_code' => v::optional(v::NotEmpty())->setName('字典'),
            'dict_type' => v::optional(v::NotEmpty())->setName('字典类型'),
            'status' => v::in([0, 1])->setName('状态'),
        ];
    }

    // 添加或更新之前，校验group_id和group_code是否匹配
    protected static function booted()
    {
        parent::boot();
        
        static::saving(function ($model) {
            if ($model->group_code != \plugin\condoradmin\app\model\SystemConfigGroup::where('id', $model->group_id)->value('code')) {
                throw new \Exception('分组标识和分组ID不匹配');
            };
        });
    }
}
