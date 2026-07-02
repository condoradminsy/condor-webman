<?php

namespace plugin\condoradmin\app\library;

/**
 * 空对象模式 - 用于未登录场景
 * 避免空指针异常
 */
class NullAuthUser
{
    /**
     * 未登录用户 ID 为 0
     * @var int
     */
    public $id = 0;

    /**
     * 未登录用户始终不是超级管理员
     * @return bool
     */
    public function isSuperAdmin(): bool
    {
        return false;
    }

    /**
     * 未登录用户没有下级管理员
     * @param bool $includeSelf
     * @return array
     */
    public function getChildrenAdminIds(bool $includeSelf = false): array
    {
        return [];
    }

    /**
     * 魔术方法：访问任何属性都返回 null
     * @param string $name
     * @return null
     */
    public function __get($name)
    {
        return null;
    }

    /**
     * 魔术方法：调用任何方法都返回 null
     * @param string $method
     * @param array $args
     * @return null
     */
    public function __call($method, $args)
    {
        return null;
    }

    /**
     * 检查是否为访客（未登录用户）
     * @return bool
     */
    public function isGuest(): bool
    {
        return true;
    }
}
