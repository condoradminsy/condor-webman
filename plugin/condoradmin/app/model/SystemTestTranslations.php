<?php

namespace plugin\condoradmin\app\model;

use support\Model;
use Respect\Validation\Validator as v;

class SystemTestTranslations extends Model
{
    /**
     * @var string
     */
    protected $table = 'system_test_translations';

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
            'name' => v::optional(v::notEmpty())->setName(trans('fields.name', [], 'test')),
            'target' => v::optional(v::notEmpty())->setName(trans('fields.target', [], 'test')),
            'title' => v::optional(v::notEmpty())->setName(trans('fields.title', [], 'test')),
            'content' => v::optional(v::notEmpty())->setName(trans('fields.content', [], 'test')),
            'image' => v::optional(v::notEmpty())->setName(trans('fields.image', [], 'test')),
            'images' => v::optional(v::notEmpty())->setName(trans('fields.images', [], 'test')),
            'attachfile' => v::optional(v::notEmpty())->setName(trans('fields.attachfile', [], 'test')),
            'keywords' => v::optional(v::notEmpty())->setName(trans('fields.keywords', [], 'test')),
            'description' => v::optional(v::notEmpty())->setName(trans('fields.description', [], 'test')),
        ];
    }
}
