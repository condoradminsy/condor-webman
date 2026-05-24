<?php

namespace plugin\condorauth\app\service;

use plugin\condoradmin\app\service\SystemConfig;
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

        $configService = new SystemConfig();
        $aliyun = $configService->getConfig('gateways', 'sms_config');

        $config = [
            // HTTP 请求的超时时间（秒）
            'timeout' => 5.0,
            'default' => [
                // 网关调用策略，默认：顺序调用
                'strategy' => \Overtrue\EasySms\Strategies\OrderStrategy::class,
                // 默认可用的发送网关
                'gateways' => [$aliyun],
            ],
            'gateways' => [
                'errorlog' => [
                    'file' => runtime_path() . '/logs/easy-sms.log',
                ],
                $aliyun => [
                    'access_key_id' => $configService->getConfig('access_key_id', 'sms_config'),
                    'access_key_secret' => $configService->getConfig('access_key_secret', 'sms_config'),
                    'sign_name' => $configService->getConfig('sign_name', 'sms_config'),
                ],
            ],
        ];

        try {
            $easySms = new EasySms($config);
            $is_template = $configService->getConfig('is_template', 'sms_config');
            $data = [
                'data' => [
                    'code' => $code,
                ],
            ];
            if ($is_template == 1) {
                $data['template'] = $configService->getConfig('template_code', 'sms_config');
            } else {
                $data['content'] = $configService->getConfig('sms_content', 'sms_config');
            }
            $easySms->send($phone, $data);
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
