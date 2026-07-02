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
            'table' => v::NotEmpty()->setName(trans('fields.table', [], 'crud'))->setTemplate(trans('common.validation.required')),
            'module' => v::NotEmpty()->setName(trans('fields.module', [], 'crud'))->setTemplate(trans('common.validation.required')),
            'menu_name' => v::optional(v::notEmpty())->setName(trans('fields.menu.name', [], 'crud')),
            'menu_title' => v::optional(v::notEmpty())->setName(trans('fields.menu.title', [], 'crud')),
            'menu_path' => v::notEmpty()->setName(trans('fields.menu.path', [], 'crud'))->setTemplate(trans('common.validation.required')),
            'menu_id' => v::optional(v::notEmpty())->setName(trans('fields.menu.id', [], 'crud')),
            'route_group' => v::optional(v::notEmpty())->setName(trans('fields.route.group', [], 'crud')),
            'route_name' => v::optional(v::notEmpty())->setName(trans('fields.route.name', [], 'crud')),
            'is_soft_delete' => v::in([false, true])->setName(trans('fields.is.soft.delete', [], 'crud'))->setTemplate(trans('common.validation.in')),
            'is_menu' => v::in([false, true])->setName(trans('fields.is.menu', [], 'crud'))->setTemplate(trans('common.validation.in')),
            'is_force' => v::in([false, true])->setName(trans('fields.is.force', [], 'crud'))->setTemplate(trans('common.validation.in')),
            'is_create_time' => v::in([false, true])->setName(trans('fields.is.create.time', [], 'crud'))->setTemplate(trans('common.validation.in')),
            'is_update_time' => v::in([false, true])->setName(trans('fields.is.update.time', [], 'crud'))->setTemplate(trans('common.validation.in')),
            'is_route' => v::in([false, true])->setName(trans('fields.is.route', [], 'crud'))->setTemplate(trans('common.validation.in')),
            'frontend' => v::optional(v::notEmpty())->setName(trans('fields.frontend', [], 'crud')),
            'fields' => v::NotEmpty()->setName(trans('fields.fields', [], 'crud'))->setTemplate(trans('common.validation.required')),
            'model' => v::optional(v::notEmpty())->setName(trans('fields.model', [], 'crud')),
            'controller' => v::optional(v::notEmpty())->setName(trans('fields.controller', [], 'crud')),
        ];
    }
}
