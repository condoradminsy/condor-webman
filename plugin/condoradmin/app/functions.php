<?php

use Tinywan\Jwt\JwtToken;
use Webman\Route;
use Webman\Channel\Client;

if (!function_exists('getEnctyptPassword')) {
    /**
     *  获取密码加密后的字符串
     *
     * @param string $password 密码
     * @param string $salt
     *
     * @return string
     */
    function getEnctyptPassword($password): string
    {
        return password_hash($password, PASSWORD_DEFAULT);
    }
}

if (!function_exists('verifyPassword')) {
    /**
     *  验证密码是否正确
     *
     * @param string $salt
     *
     * @return string
     */
    function verifyPassword(string $password, string $hash): bool
    {
        return password_verify($password, $hash);
    }
}

if (!function_exists('getCurrentInfo')) {
    /**
     * 获取当前登录用户
     */
    function getCurrentInfo(): bool|array
    {
        if (!request()) {
            return false;
        }
        try {
            $token = JwtToken::getExtend();
        } catch (\Throwable $e) {
            return false;
        }
        return $token;
    }
}

if (!function_exists('getInviteCode')) {
    /**
     * 获取邀请码
     */
    function getInviteCode($seed = '', $length = 6): string
    {
        $seed = $seed ?: uniqid(mt_rand(), true);
        $hash = strtoupper(substr(md5($seed), 0, $length));
        return preg_replace('/[0O1I]/', rand(2, 9), $hash);
    }
}

if (!function_exists('getIpLocation')) {
    /**
     * 获取IP地理位置
     */
    function getIpLocation($ip): string
    {
        $ip2region = new \Ip2Region();
        try {
            $region = $ip2region->memorySearch($ip);
            $parts = array_map('trim', explode('|', $region['region']));
            $parts = array_pad($parts, 5, '');
            list($country, $number, $province, $city, $network) = $parts;
            if ($network === '内网IP') {
                return $network;
            }
            if ($country == '中国') {
                return $province . '-' . $city . ':' . $network;
            } else if ($country == '0') {
                return '未知';
            } else {
                return $country;
            }
        } catch (\Exception $e) {
            \support\Log::error('获取IP地理位置失败', ['error' => $e, 'region' => $region, 'ip' => $ip]);
            return '未知';
        }
    }
}

if (!function_exists('createRoutes')) {

    /**
     * 创建路由
     * @throws \Exception
     */
    function createRoutes(string $name, string $controller): void
    {
        $name = trim($name, '/');
        if (method_exists($controller, 'index')) Route::post("/$name/index", [$controller, 'index']);
        if (method_exists($controller, 'add')) Route::post("/$name/add", [$controller, 'add']);
        if (method_exists($controller, 'edit')) Route::post("/$name/edit", [$controller, 'edit']);
        if (method_exists($controller, 'del')) Route::post("/$name/del", [$controller, 'del']);
        if (method_exists($controller, 'multi')) Route::post("/$name/multi", [$controller, 'multi']);
        if (method_exists($controller, 'selectpage')) Route::post("/$name/selectpage", [$controller, 'selectpage']);
    }
}

if (!function_exists('getPrivateKeyValue')) {
    /**
     * 获取私钥内容
     */
    function getPrivateKeyValue(string $privateKey): string
    {
        if (empty($privateKey)) {
            return '';
        }
        $privateKey = "-----BEGIN PRIVATE KEY-----\n" .
            wordwrap($privateKey, 64, "\n", true) .
            "\n-----END PRIVATE KEY-----";
        return $privateKey;
    }
}

if (!function_exists('getPublicKeyValue')) {
    /**
     * 获取公钥内容
     */
    function getPublicKeyValue(string $publicKey): string
    {
        if (empty($publicKey)) {
            return '';
        }
        $publicKey = "-----BEGIN PUBLIC KEY-----\n" .
            wordwrap($publicKey, 64, "\n", true) .
            "\n-----END PUBLIC KEY-----";
        return $publicKey;
    }
}


if (!function_exists('sendSseMessage')) {
    function sendSseMessage($data, $event = 'condor_sse_broadcast')
    {
        Client::connect('127.0.0.1', 2206);
        Client::publish($event, $data);
    }
}
