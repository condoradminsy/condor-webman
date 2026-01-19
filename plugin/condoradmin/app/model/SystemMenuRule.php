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
            'title' => v::NotEmpty()->setName('标题'),
            'name' => v::NotEmpty()->alnum('_-')->noWhitespace()->setName('名称'),
            'path' => v::NotEmpty()->setName('路径'),
            'hidden' => v::optional(v::in([0, 1]))->setName('是否隐藏'),
            'menu_type' => v::optional(v::in([0, 1, 2]))->setName('菜单类型'),
            'active_menu' => v::optional(v::NotEmpty())->setName('激活菜单'),
            'component' => v::optional(v::NotEmpty())->setName('组件'),
            'i18nkey' => v::optional(v::NotEmpty())->setName('国际化key'),
            'icon' => v::optional(v::NotEmpty())->setName('图标'),
            'is_keep' => v::optional(v::in([0, 1]))->setName('是否缓存'),
            'pid' => v::optional(v::number())->setName('父级ID'),
            'weigh' => v::optional(v::number())->setName('权重'),
            'redirect' => v::optional(v::NotEmpty())->setName('重定向'),
            'status' => v::in([1, 2])->setName('状态'),
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
