<?php

namespace plugin\condoradmin\app\service;

use plugin\condoradmin\app\model\SystemRoleGroup;
use plugin\condoradmin\app\model\SystemRole as RoleModel;

class SystemRole extends BaseService
{
    /**
     * 构造函数
     */
    public function __construct()
    {
        $this->model = new RoleModel();
    }

    public function addRole($uid, $role_ids)
    {
        //旧的移除
        SystemRoleGroup::where('uid', $uid)->delete();
        //新的添加
        foreach ($role_ids as $role_id) {
            SystemRoleGroup::create([
                'uid' => $uid,
                'role_id' => $role_id
            ]);
        }
        // 清除缓存
        \plugin\condoradmin\app\library\Auth::clearRoleCacheByUid($uid);
    }
}
