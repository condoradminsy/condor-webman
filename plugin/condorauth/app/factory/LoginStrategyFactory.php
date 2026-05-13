<?php

namespace plugin\condorauth\app\factory;

use plugin\condorauth\app\strategy\LoginStrategy;
use plugin\condorauth\app\strategy\PasswordLoginStrategy;
use plugin\condorauth\app\strategy\MiniMpLoginStrategy;
use plugin\condorauth\app\strategy\SmsLoginStrategy;
use plugin\condorauth\app\strategy\EmailLoginStrategy;

class LoginStrategyFactory
{
    public static function make(string $type): LoginStrategy
    {
        return match ($type) {
            'password' => new PasswordLoginStrategy(),
            'mini-mp'  => new MiniMpLoginStrategy(),
            'sms'      => new SmsLoginStrategy(),
            'email'    => new EmailLoginStrategy(),
            default    => throw new \Exception('不支持的登录方式'),
        };
    }
}
