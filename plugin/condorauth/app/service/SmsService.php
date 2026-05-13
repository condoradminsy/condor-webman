<?php

namespace plugin\condorauth\app\service;

use Overtrue\EasySms\EasySms;
use Overtrue\EasySms\Exceptions\NoGatewayAvailableException;
use plugin\condoradmin\app\library\Captcha;
use support\Log;
use support\Redis;

class SmsService
{
    /**
     * 发送短信验证码
     */
    public static function sendCode(string $phone, string $event = 'login'): bool
    {
        $limitKey = 'condor:auth:sms_limit:' . $phone;
        if (Redis::get($limitKey)) {
            throw new \RuntimeException(trans('condorauth.send.code.too.frequent'));
        }

        $code = Captcha::numberCaptcha($event, 6);

        $config = [
            'timeout' => 5.0,
            'default' => [
                'strategy' => \Overtrue\EasySms\Strategies\OrderStrategy::class,
                'gateways' => ['log'],
            ],
            'gateways' => [
                'errorlog' => [
                    'file' => runtime_path() . '/logs/easy-sms.log',
                ],
                'log' => [
                    'file' => runtime_path() . '/logs/easy-sms.log',
                ],
            ],
        ];

        try {
            $easySms = new EasySms($config);
            $easySms->send($phone, [
                'template' => 'SMS_001',
                'data' => [
                    'code' => $code,
                ],
            ]);
        } catch (NoGatewayAvailableException $e) {
            Log::error('SMS send failed: ' . $e->getMessage());
            // 开发环境下验证码已存入 Redis，可继续调试
            if (!config('app.debug')) {
                throw new \RuntimeException(trans('condorauth.sms.send.failed'));
            }
        }

        // 60秒限流
        Redis::set($limitKey, 1, 'EX', 60);

        return true;
    }

    /**
     * 校验短信验证码
     */
    public static function checkCode(string $code, string $event = 'login'): bool
    {
        return Captcha::checkCaptcha($event, $code);
    }
}
