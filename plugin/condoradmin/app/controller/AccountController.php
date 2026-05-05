<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\library\Captcha;
use plugin\condoradmin\app\service\SystemAdmin;
use support\Redis;
use support\Log;

class AccountController extends Backend
{

    /**
     * 不需要登录的方法
     */
    protected $noNeedLogin = ['captcha', 'login'];

    protected $noNeedRight = ['getUserInfo', 'updateProfile'];


    /**
     * 获取验证码
     */
    public function captcha(Request $request)
    {
        $ip = $request->getRealIp();
        // 验证码限制,30秒内最多请求5次
        $limitKey = 'condor:captcha:' . $ip;
        try {
            $count = (int)Redis::incr($limitKey);
            if ($count === 1) {
                // 首次计数，设置过期时间为 30 秒
                Redis::expire($limitKey, 30);
            }
            if ($count > 5) {
                return $this->fail(trans('condoradmin.too.many.requests.please.try.again.later'));
            }
        } catch (\Throwable $e) {
            // Redis 出错时降级处理：允许请求，但记录日志以便排查
            Log::error('Redis error: ' . $e->getMessage());
        }
        return $this->success(trans('condoradmin.ok'), [
            'captcha' => Captcha::imageCaptcha('admin:login')
        ]);
    }


    /**
     * 登录
     */
    public function login(Request $request)
    {
        $username = $request->post('username');
        $password = $request->post('password');
        $captcha = $request->post('captcha');
        if (empty($username) || empty($password) || empty($captcha)) {
            return $this->fail(trans('condoradmin.invalid.parameters'));
        }
        if (Captcha::checkCaptcha('admin:login', $captcha) === false) {
            return $this->fail(trans('condoradmin.incorrect.verification.code'));
        }
        $privateKey = getPrivateKeyValue(config('plugin.condoradmin.condor.private_key'));
        $password = openssl_private_decrypt(base64_decode($password), $decryptedData, $privateKey) ? $decryptedData : '';
        if (empty($password)) {
            return $this->fail(trans('condoradmin.incorrect.password.please.try.again'));
        }
        $admin = new SystemAdmin();
        return $this->success(trans('condoradmin.ok'), $admin->login(trim($username), trim($password)));
    }

    /**
     * 获取用户信息
     */
    public function getUserInfo()
    {
        $adminInfo = $this->auth->getUserInfo();
        // 转换前端需要的字段
        $adminInfo['userId'] = $adminInfo['id'];
        unset($adminInfo['id']);
        $adminInfo['is_super'] = $this->auth->isSuperAdmin();
        $adminInfo['roles'] =  $this->auth->getRuleList($this->auth->id);
        $adminInfo['buttons'] =  $this->auth->getRuleList($this->auth->id, 2);
        return $this->success(trans('condoradmin.ok'), $adminInfo);
    }

    /**
     * 更新个人信息
     * @param Request $request
     * @return \support\Response
     */
    public function updateProfile(Request $request)
    {
        $avatar = $request->post('avatar');
        $email = $request->post('email');
        $password = $request->post('password');
        $privateKey = getPrivateKeyValue(config('plugin.condoradmin.condor.private_key'));
        $password = openssl_private_decrypt(base64_decode($password), $decryptedData, $privateKey) ? $decryptedData : '';
        if (empty($password)) {
            return $this->fail(trans('condoradmin.incorrect.password.please.try.again'));
        }
        $admin = new SystemAdmin();
        return $this->success(trans('condoradmin.ok'), $admin->updateProfile($this->auth->id, $avatar, $email, $password));
    }
}
