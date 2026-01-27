<?php

namespace plugin\condoradmin\app\model;

use support\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Respect\Validation\Validator as v;

class SystemMenuRule extends Model
{
    use SoftDeletes;
    /**
     * @var string
     */
    protected $table = 'system_menu_rule';

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
            'title' => v::NotEmpty()->setName(trans('fields.title', [], 'menu'))->setTemplate(trans('condoradmin.validation.required')),
            'name' => v::NotEmpty()->alnum('_-')->noWhitespace()->setName(trans('fields.name', [], 'menu'))->setTemplate(trans('condoradmin.validation.required')),
            'path' => v::NotEmpty()->setName(trans('fields.path', [], 'menu'))->setTemplate(trans('condoradmin.validation.required')),
            'hidden' => v::optional(v::in([0, 1]))->setName(trans('fields.hidden', [], 'menu'))->setTemplate(trans('condoradmin.validation.in')),
            'menu_type' => v::optional(v::in([0, 1, 2]))->setName(trans('fields.menu.type', [], 'menu'))->setTemplate(trans('condoradmin.validation.in')),
            'active_menu' => v::optional(v::NotEmpty())->setName(trans('fields.active.menu', [], 'menu')),
            'component' => v::optional(v::NotEmpty())->setName(trans('fields.component', [], 'menu')),
            'i18nkey' => v::optional(v::NotEmpty())->setName(trans('fields.i18nkey', [], 'menu')),
            'icon' => v::optional(v::NotEmpty())->setName(trans('fields.icon', [], 'menu')),
            'is_keep' => v::optional(v::in([0, 1]))->setName(trans('fields.is.keep', [], 'menu')),
            'pid' => v::optional(v::number())->setName(trans('fields.pid', [], 'menu')),
            'weigh' => v::optional(v::number())->setName(trans('fields.weigh', [], 'menu')),
            'redirect' => v::optional(v::NotEmpty())->setName(trans('fields.redirect', [], 'menu')),
            'status' => v::in([1, 2])->setName(trans('fields.status', [], 'menu'))->setTemplate(trans('condoradmin.validation.in')),
        ];
    }

    // 菜单改变时，新增，更新，删除都要清除缓存
    public static function boot()
    {
        parent::boot();

        static::saved(function ($model) {
            \plugin\condoradmin\app\library\Breadcrumb::clearCache();
            \plugin\condoradmin\app\library\Auth::clearCacheByRuleId($model->id);
        });

        static::deleted(function ($model) {
            \plugin\condoradmin\app\library\Breadcrumb::clearCache();
            \plugin\condoradmin\app\library\Auth::clearCacheByRuleId($model->id);
        });
    }
}
