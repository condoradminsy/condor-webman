<?php

namespace plugin\condoradmin\app\model;

use support\Model;
use Respect\Validation\Validator as v;
use Illuminate\Database\Eloquent\SoftDeletes;

class SystemTest extends Model
{
    use SoftDeletes;
    /**
     * @var string
     */
    protected $table = 'system_test';

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
            'price' => v::optional(v::notEmpty())->setName(trans('fields.price', [], 'test')),
            'views' => v::optional(v::notEmpty())->setName(trans('fields.views', [], 'test')),
            'activitytime' => v::optional(v::notEmpty())->setName(trans('fields.activitytime', [], 'test')),
            'refreshtime' => v::optional(v::notEmpty())->setName(trans('fields.refreshtime', [], 'test')),
        ];
    }

    public function getPriceAttribute($value)
    {
        return floatval($value);
    }

    /**
     * 关联翻译
     */
    public function translations()
    {
        return $this->hasMany(SystemTestTranslations::class, 'main_id', 'id');
    }
}
