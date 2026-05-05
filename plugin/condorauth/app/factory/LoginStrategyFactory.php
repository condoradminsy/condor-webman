<?php

namespace plugin\condorauth\app\factory;

use plugin\condorauth\app\strategy\LoginStrategy;
use plugin\condorauth\app\strategy\PasswordLoginStrategy;
use plugin\condorauth\app\strategy\MiniMpLoginStrategy;

class LoginStrategyFactory
{
    public static function make(string $type): LoginStrategy
    {
        return match ($type) {
            'password' => new PasswordLoginStrategy(),
            'mini-mp' => new MiniMpLoginStrategy(),
            default => throw new \Exception('不支持的登录方式'),
        };
    }
}
