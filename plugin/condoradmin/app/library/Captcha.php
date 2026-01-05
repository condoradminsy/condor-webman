<?php

namespace plugin\condoradmin\app\library;

use Webman\Captcha\CaptchaBuilder;
use Webman\Captcha\PhraseBuilder;
use support\Redis;

/**
 * 验证码工具类
 */
class Captcha
{
    /**
     * 图形验证码
     * @return string
     */
    public static function imageCaptcha(string $event = 'login'): string
    {
        // 定义要排除的字符
        $ignoreChars = '0xo1ilz7gIjJLtTfpParsVvyYqb'; // 验证码字符中排
        $builder = new PhraseBuilder(4, 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ34589', $ignoreChars);

        $captcha = new CaptchaBuilder(null, $builder);
        $captcha->setBackgroundColor(235, 239, 249);
        $captcha->build(120, 40);

        $code = strtolower($captcha->getPhrase());
        $key = $code . '_' . $event;

        Redis::set($key, $code, 'EX', 60 * 10);
        $img_content = $captcha->get();

        return 'data:image/png;base64,' . base64_encode($img_content);
    }

    /**
     * 数字验证码
     * @param string $key
     * @param int $length
     * @return int
     */
    public static function numberCaptcha(string $event = 'login', int $length = 4): int
    {
        $code   = str_pad(rand(0, 999999), $length, '0', STR_PAD_LEFT);
        $key = $code . '_' . $event;
        // 10 分钟内有效
        Redis::set($key, $code, 'EX', 60 * 10);
        return $code;
    }

    /**
     * 验证码验证
     * @param string $uuid
     * @param string|int $captcha
     * @return bool
     */
    public static function checkCaptcha(string $event, string|int $captcha): bool
    {
        $key = strtolower($captcha) . '_' . $event;
        $code = Redis::get($key);
        Redis::del($key);
        if (empty($code)) {
            return false;
        }
        return true;
    }
}
