<?php

namespace plugin\condoradmin\app\model;

use support\Model;

class SystemRoleGroup extends Model
{
    /**
     * @var string
     */
    protected $table = 'system_role_group';

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
}
