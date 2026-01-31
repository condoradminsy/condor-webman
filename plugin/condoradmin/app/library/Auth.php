<?php

namespace plugin\condoradmin\app\library;

use support\Db;
use plugin\condoradmin\app\model\SystemAdmin;
use plugin\condoradmin\exception\ApiException;
use support\Redis;

class Auth
{
    protected $adminInfo = [];

    // 角色组缓存
    const ROLE_GROUP_CACHE = 'role:group:uid:';
    // 权限规则
    const RULE_LIST_CACHE_KEY = 'rulelist:key:uid:';
    const RULE_LIST_CACHE = 'rulelist:uid:';

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
            throw new ApiException(trans('condoradmin.invalid.token'), 401);
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
            throw new ApiException(trans('condoradmin.user.does.not.exist'));
        }
        if ($adminInfo->status !== 1) {
            throw new ApiException(trans('condoradmin.user.is.disabled'));
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
     * 根据用户id获取用户角色组,返回值为数组
     * @param int $admin_id  用户id
     */
    public function getRoleGroups($uid, $isTree = false)
    {
        $key = self::ROLE_GROUP_CACHE . $uid;
        $roleGroup = Redis::get($key);
        // 缓存 -> 角色组改变的时候，需要清除缓存，角色状态改变，删除的时候，需要清除缓存
        if (empty($roleGroup)) {
            $roleGroup = Db::table('system_role_group as srg')
                ->select('srg.uid', 'srg.role_id', 'sr.id', 'sr.pid', 'sr.name', 'sr.rules', 'sr.code')
                ->join('system_role as sr', 'srg.role_id', '=', 'sr.id')
                ->where('srg.uid', '=', $uid)
                ->where('sr.status', '=', 1)
                ->get()
                ->map(fn($v) => (array)$v)
                ->toArray();
            Redis::set($key, json_encode($roleGroup));
        } else {
            $roleGroup = json_decode($roleGroup, true);
        }
        if ($isTree) {
            $tree = new Tree();
            return $tree->makeTree($roleGroup);
        }
        return $roleGroup;
    }

    /**
     * 获得权限规则列表
     * @param int $uid 用户id
     * @return array
     */
    public function getRuleList(int $uid, int $menu_type = 0)
    {
        // 读取用户规则节点 ===> 得到的是菜单id
        $ids = $this->getRuleIds($uid);
        if (empty($ids)) {
            return [];
        }
        if (in_array('*', $ids)) {
            return ['*'];
        }
        // 有权限的菜单IDs,清缓存要用到 =》 规则状态变了，删除了，需要清除缓存
        $value = md5(implode('_', $ids));
        Redis::set(self::RULE_LIST_CACHE_KEY . $uid, $value);
        // 菜单变了重新获取
        $key = self::RULE_LIST_CACHE . $uid . ':' . $value . ':' . $menu_type;
        $rulelist = Redis::get($key);
        if (empty($rulelist)) {
            // 0 接口，1 菜单，2 按钮
            $rulelist = Db::table('system_menu_rule')
                ->select('path')
                ->where('status', 1)
                ->where('menu_type', $menu_type)
                ->whereIn('id', $ids)
                ->pluck('path')->toArray();
            $rulelist = array_unique($rulelist);
            Redis::set($key, json_encode($rulelist));
        } else {
            $rulelist = json_decode($rulelist, true);
        }
        return $rulelist;
    }

    /**
     * 检查路由是否存在
     * @param string $routeName 路由名称
     * @return bool
     */
    public function isRouteExist($routeName)
    {
        $count = Db::table('system_menu_rule')
            ->where('status', 1)
            ->where('path', $routeName)
            ->count();
        return $count > 0;
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
        $groups = $this->getRoleGroups($uid ?: $this->id);
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
        $groups = $this->getRoleGroups($uid);
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
        $groups = $this->getRoleGroups($this->id);
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
                $childrenAdminIds = \plugin\condoradmin\app\model\SystemRoleGroup::select('system_role_group.uid')
                    ->where('system_admin.status', 1)
                    ->whereIn('role_id', $groupIds)
                    ->join('system_admin', 'system_role_group.uid', '=', 'system_admin.id')
                    ->pluck('uid')
                    ->toArray();
            }
        } else {
            //超级管理员拥有所有人的权限
            $childrenAdminIds = \plugin\condoradmin\app\model\SystemAdmin::select('id')->where('status', 1)->pluck('id')->toArray();
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

    /**
     * 清除角色缓存
     * @param [type] $uid
     * @return void
     */
    public static function clearRoleCacheByUid($uid)
    {
        Redis::del(self::ROLE_GROUP_CACHE . $uid);
        self::clearRuleListCacheByUid($uid);
    }

    /**
     * 清除角色缓存
     * @param [type] $role_id
     * @return void
     */
    public static function clearCacheByRoleId($role_id)
    {
        $uids = Db::table('system_role_group')->where('role_id', $role_id)->pluck('uid')->toArray();
        foreach ($uids as $uid) {
            self::clearRoleCacheByUid($uid);
        }
    }

    // 清除规则缓存
    public static function clearRuleListCacheByUid($uid)
    {
        $value = Redis::get(self::RULE_LIST_CACHE_KEY . $uid);
        if ($value) {
            $menuTypes = [0, 1, 2];
            foreach ($menuTypes as $menuType) {
                Redis::del(self::RULE_LIST_CACHE . $uid . ':' . $value . ':' . $menuType);
            }
            Redis::del(self::RULE_LIST_CACHE_KEY . $uid);
        }
    }

    // 清除规则缓存
    public static function clearCacheByRuleId($rule_id)
    {
        $admin_ids = Db::table('system_role')->select('admin_id')->whereRaw('FIND_IN_SET(?,rules)', [$rule_id])->pluck('admin_id')->toArray();
        $admin_ids = array_unique($admin_ids);
        foreach ($admin_ids as $admin_id) {
            self::clearRuleListCacheByUid($admin_id);
        }
    }
}
