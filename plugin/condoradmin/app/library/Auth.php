<?php

namespace plugin\condoradmin\app\library;

use support\Db;
use plugin\condoradmin\app\model\SystemAdmin;
use plugin\condoradmin\exception\ApiException;

class Auth
{
    protected $adminInfo = [];

    public function __get($name)
    {
        return $this->adminInfo[$name] ?? null;
    }

    /**
     * 初始化用户
     * @throws ApiException
     */
    public function initUser()
    {
        $tokenInfo = getCurrentInfo();
        if ($tokenInfo === false) {
            throw new ApiException('token无效', 401);
        }
        $adminInfo = SystemAdmin::select(
            'id',
            'username',
            'nickname',
            'avatar',
            'email',
            'status',
            'createtime',
            'logintime'
        )->find($tokenInfo['id']);
        if (empty($adminInfo)) {
            throw new ApiException('用户不存在');
        }
        if ($adminInfo->status !== 1) {
            throw new ApiException('用户已被禁用');
        }
        $this->adminInfo = $adminInfo->toArray();
    }

    /**
     * 检查权限
     */
    public function check($name, $uid, $relation = 'or', $menu_type = 0)
    {
        $uid = $uid ? $uid : $this->id;
        $rulelist = $this->getRuleList($uid, $menu_type);
        if (in_array('*', $rulelist)) {
            return true;
        }
        if (is_string($name)) {
            if (strpos($name, ',') !== false) {
                $name = explode(',', $name);
            } else {
                $name = [$name];
            }
        }
        $list = [];
        foreach ($rulelist as $rule) {
            if (in_array($rule, $name)) {
                $list[] = $rule;
            }
        }
        if ('or' == $relation && !empty($list)) {
            return true;
        }
        $diff = array_diff($name, $list);
        if ('and' == $relation && empty($diff)) {
            return true;
        }
        return false;
    }

    /**
     * 根据用户id获取用户组,返回值为数组
     * @param int $admin_id  用户id
     */
    public function getGroups($uid, $isTree = false)
    {
        // 放内存当中
        static $groups = [];
        if (!isset($groups[$uid . 'expire']) || $groups[$uid . 'expire'] < time() || !isset($groups[$uid]) || empty($groups[$uid])) {
            // 执行查询
            $user_groups = Db::table('system_role_group as srg')
                ->select('srg.uid', 'srg.role_id', 'sr.id', 'sr.pid', 'sr.name', 'sr.rules', 'sr.code')
                ->leftJoin('system_role as sr', 'srg.role_id', '=', 'sr.id')
                ->where('srg.uid', '=', $uid)
                ->where('sr.status', '=', 1)
                ->get()->map(function ($value) {
                    return (array)$value;
                })->toArray();
            $groups[$uid] = $user_groups ?: [];
            // 角色权限会改变，所以需要定时更新，不然需要重启服务
            $groups[$uid . 'expire'] = time() + 300;
        }
        if ($isTree) {
            $tree = new Tree();
            return $tree->makeTree($groups[$uid]);
        }
        return $groups[$uid];
    }

    /**
     * 获得权限规则列表
     * @param int $uid 用户id
     * @return array
     */
    public function getRuleList($uid, $menu_type = 0)
    {
        // 读取用户规则节点 ===> 得到的是菜单id
        $ids = $this->getRuleIds($uid);
        if (empty($ids)) {
            return [];
        }
        if (in_array('*', $ids)) {
            return ['*'];
        }
        // 0 接口，1 菜单，2 按钮
        $rules = Db::table('system_menu_rule')
            ->where('status', 1)
            ->where(function ($query) use ($menu_type) {
                if (is_array($menu_type) && !empty($menu_type)) {
                    $query->whereIn('menu_type', $menu_type);
                } else {
                    $query->where('menu_type', $menu_type);
                }
            })
            ->whereIn('id', $ids)
            ->pluck('path')->toArray();
        return array_unique($rules);
    }

    /**
     * 获得菜单
     * @param int $uid 用户id
     * @return array
     */
    public function getRuleMenu($uid, $menu_type = 1, $is_tree = false, $status = 1)
    {
        // 读取用户规则节点
        $ids = $this->getRuleIds($uid);
        if (empty($ids)) {
            return [];
        }
        //读取用户组所有权限规则
        $rules = Db::table('system_menu_rule')
            ->where(function ($query) use ($menu_type, $ids, $status) {
                if ($status) {
                    $query->where('status', $status);
                }
                if (!in_array('*', $ids)) {
                    $query->whereIn('id', $ids);
                }
                if (is_array($menu_type) && !empty($menu_type)) {
                    $query->whereIn('menu_type', $menu_type);
                } else if (is_numeric($menu_type)) {
                    $query->where('menu_type', $menu_type);
                }
            })
            ->select(
                'id',
                'name',
                'menu_type',
                'title',
                'pid',
                'icon',
                'href',
                'path',
                'i18nKey',
                'component',
                'hidden',
                'redirect',
                'is_keep',
                'active_menu',
                'multi_tab',
                'fixed_tab_index',
                'weigh',
                'status'
            )
            ->orderBy('weigh', 'ASC')
            ->get()
            ->map(function ($value) {
                return (array)$value;
            })->toArray();
        $tree = new Tree();
        return !$is_tree ? $tree->makeArcoMenus($rules) : $tree->makeTree($rules);
    }

    /**
     * 获得权限规则id
     *  
     * * @param int $uid 用户id
     * @return array
     */
    public function getRuleIds($uid = null)
    {
        //读取用户所属用户组
        $groups = $this->getGroups($uid ?: $this->id);
        $ids = []; //保存用户所属用户组设置的所有权限规则id
        foreach ($groups as $item) {
            // 超级管理员拥有所有权限
            if ($item['code'] === 'superadmin') {
                return ['*'];
            }
            $ids = array_merge($ids, explode(',', trim($item['rules'], ',')));
        }
        $ids = array_unique($ids);
        return $ids;
    }

    /**
     * 过滤规则
     * * @param array $rules 规则数组
     * @return array
     */
    public function filterRule($rules)
    {
        if (!empty($rules)) {
            if (!is_array($rules)) {
                $rules = explode(',', $rules);
            }
            $rules = array_unique($rules);
            $ids = $this->getRuleIds();
            if (empty($ids)) {
                $rules = [];
            } else if (!in_array('*', $ids)) {
                $rules = array_intersect($rules, $ids);
            }
        }
        return $rules;
    }

    /**
     * 获得用户资料
     * @param int $uid 用户id
     * @return mixed
     */
    public function getUserInfo()
    {
        if (!empty($this->adminInfo)) return $this->adminInfo;
        $this->initUser();
        return $this->adminInfo;
    }

    /**
     * 检测当前控制器和方法是否匹配传递的数组
     *
     * @param array $arr
     * @return void
     */
    public function match($arr = [])
    {
        $arr = is_array($arr) ? $arr : explode(',', $arr);
        if (empty($arr)) {
            return false;
        }
        // 是否存在
        if (in_array(request()->action, $arr) || in_array('*', $arr)) {
            return true;
        }
        // 没找到匹配
        return false;
    }

    /**
     * 是否是超级管理员
     */
    public function isSuperAdmin()
    {
        return in_array('*', $this->getRuleIds($this->id));
    }

    /**
     * 获取管理员所属于的分组ID
     * @param int $uid
     * @return array
     */
    public function getGroupIds($uid = null)
    {
        $groups = $this->getGroups($uid);
        $groupIds = [];
        foreach ($groups as $v) {
            $groupIds[] = (int)$v['role_id'];
        }
        return $groupIds;
    }

    /**
     * 取出当前管理员所拥有权限的分组
     * @param boolean $withself 是否包含当前所在的分组
     * @return array
     */
    public function getChildrenGroupIds($withself = false)
    {
        //取出当前管理员所有的分组
        $groups = $this->getGroups($this->id);
        $groupIds = array_column($groups, 'id');
        $originGroupIds = $groupIds;
        foreach ($groups as $k => $v) {
            if (in_array($v['pid'], $originGroupIds)) {
                $groupIds = array_diff($groupIds, [$v['id']]);
                unset($groups[$k]);
            }
        }
        $isSuperAdmin = $this->isSuperAdmin();
        // 取出所有分组
        $groupList = \plugin\condoradmin\app\model\SystemRole::select('id', 'pid', 'name', 'rules')
            ->where(function ($query) use ($isSuperAdmin) {
                if (!$isSuperAdmin) {
                    $query->where('status', 1);
                }
            })->get()->toArray();
        $objList = [];
        foreach ($groups as $k => $v) {
            if ($v['rules'] === '*') {
                $objList = $groupList;
                break;
            }
            // 取出包含自己的所有子节点
            $tree = new Tree();
            $childrenList = $tree->init($groupList, 'pid')->getChildren($v['id'], true);
            $obj = $tree->init($childrenList, 'pid')->getTreeArray($v['pid']);
            $objList = array_merge($objList, $tree->getTreeList($obj));
        }
        $childrenGroupIds = [];
        foreach ($objList as $k => $v) {
            $childrenGroupIds[] = $v['id'];
        }
        if (!$withself) {
            $childrenGroupIds = array_diff($childrenGroupIds, $groupIds);
        }
        return $childrenGroupIds;
    }

    /**
     * 取出当前管理员所拥有权限的管理员
     * @param boolean $withself 是否包含自身
     * @return array
     */
    public function getChildrenAdminIds($withself = false)
    {
        $childrenAdminIds = [];
        if (!$this->isSuperAdmin()) {
            $groupIds = $this->getChildrenGroupIds(false);
            if (!empty($groupIds)) {
                $childrenAdminIds = \plugin\condoradmin\app\model\SystemRoleGroup::whereIn('role_id', $groupIds)->pluck('uid')->toArray();
            }
        } else {
            //超级管理员拥有所有人的权限
            $childrenAdminIds = \plugin\condoradmin\app\model\SystemAdmin::pluck('id')->toArray();
        }
        if ($withself) {
            if (!in_array($this->id, $childrenAdminIds)) {
                $childrenAdminIds[] = $this->id;
            }
        } else {
            $childrenAdminIds = array_diff($childrenAdminIds, [$this->id]);
        }
        return $childrenAdminIds;
    }
}
