<?php

namespace plugin\condoradmin\app\library;

use support\Redis;
use support\Db;

class Breadcrumb
{
    const CACHE_KEY = 'menu_breadcrumb:map';

    /**
     * 获取面包屑映射表
     */
    public static function getBreadcrumbMap()
    {
        // 缓存整个映射表
        $map = Redis::get(self::CACHE_KEY);
        if (empty($map)) {
            $map = self::buildBreadcrumbMap();
            // 缓存，菜单变更时清除
            Redis::set(self::CACHE_KEY, json_encode($map));
        } else {
            $map = json_decode($map, true);
        }
        return $map;
    }

    /**
     * 构建 path => 面包屑 的映射 , API才用
     */
    private static function buildBreadcrumbMap()
    {
        $menus = Db::table('system_menu_rule')
            ->select('id', 'pid', 'menu_type', 'title', 'path')
            ->orderBy('weigh', 'ASC')
            ->get()
            ->map(fn($v) => (array)$v)
            ->toArray();
        // 构建树形结构和映射
        $tree = new Tree();
        $tree->init($menus, 'pid');

        $map = [
            '/core/common/getRoutes' => ['获取菜单路由'],
            '/core/common/getUserInfo' => ['获取用户信息'],
        ];
        foreach ($menus as $menu) {
            // 接口才生成，写入日志取值
            if (!empty($menu['path']) && $menu['menu_type'] !== 1) {
                $parents = $tree->getParents($menu['id'], true);
                $breadcrumb = array_column($parents, 'title');
                $map[$menu['path']] = $breadcrumb;
            }
        }
        return $map;
    }

    /**
     * 根据 path 获取面包屑
     */
    public static function getByPath($path)
    {
        $map = self::getBreadcrumbMap();
        return $map[$path] ?? [];
    }

    /**
     * 清除面包屑缓存
     */
    public static function clearCache()
    {
        Redis::del(self::CACHE_KEY);
    }
}
