<?php

namespace plugin\condoradmin\app\model;

use support\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Respect\Validation\Validator as v;

class SystemCrudLog extends Model
{
    use SoftDeletes;
    /**
     * @var string
     */
    protected $table = 'system_crud_log';

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
    const UPDATED_AT = null;

    // 让所有属性都可以批量分配
    protected $guarded = [];

    protected function serializeDate(\DateTimeInterface $date)
    {
        return $date->format('Y-m-d H:i:s');
    }

    public function rules()
    {
        return [
            'table' => v::NotEmpty()->setName('数据表'),
            'module' => v::NotEmpty()->setName('模块目录'),
            'menu_name' => v::optional(v::notEmpty())->setName('菜单名称'),
            'menu_title' => v::optional(v::notEmpty())->setName('菜单标题'),
            'menu_path' => v::notEmpty()->setName('菜单路径'),
            'menu_id' => v::optional(v::notEmpty())->setName('菜单ID'),
            'route_group' => v::optional(v::notEmpty())->setName('路由分组'),
            'route_name' => v::optional(v::notEmpty())->setName('路由名称'),
            'is_soft_delete' => v::in([false, true])->setName('是否软删除'),
            'is_menu' => v::in([false, true])->setName('生成菜单'),
            'is_force' => v::in([false, true])->setName('强制更新'),
            'is_create_time' => v::in([false, true])->setName('创建时间'),
            'is_update_time' => v::in([false, true])->setName('更新时间'),
            'is_route' => v::in([false, true])->setName('生成路由'),
            'frontend' => v::optional(v::notEmpty())->setName('前端目录'),
            'fields' => v::NotEmpty()->setName('字段信息'),
            'model' => v::optional(v::notEmpty())->setName('模型名称'),
            'controller' => v::optional(v::notEmpty())->setName('控制器名称'),
        ];
    }
}
