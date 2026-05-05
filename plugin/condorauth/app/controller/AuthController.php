<?php

namespace plugin\condorauth\app\controller;

use plugin\condorauth\app\library\Frontend;
use plugin\condoradmin\app\library\Captcha;
use support\Request;
use support\Response;
use support\Redis;
use support\Log;
use plugin\condorauth\app\service\LoginService;
use Respect\Validation\Exceptions\ValidationException;
use Respect\Validation\Validator as v;

class AuthController extends Frontend
{
    /**
     * 不需要登录的方法
     */
    protected $noNeedLogin = ['captcha', 'register', 'login'];

    /**
     * 获取验证码
     * @param Request $request
     * @return Response
     * @throws \Throwable
     */
    public function captcha(Request $request): Response
    {
        $ip = $request->getRealIp();
        $event = $request->post('event', 'login');
        // 验证码限制,30秒内最多请求5次
        $limitKey = 'condor:auth:captcha:' . $ip;
        try {
            $count = (int)Redis::incr($limitKey);
            if ($count === 1) {
                // 首次计数，设置过期时间为 30 秒
                Redis::expire($limitKey, 30);
            }
            if ($count > 5) {
                return $this->fail(trans('condorauth.too.many.requests.please.try.again.later'));
            }
        } catch (\Throwable $e) {
            // Redis 出错时降级处理：允许请求，但记录日志以便排查
            Log::error('Redis error: =>', [
                'message' => $e->getMessage(),
                'stack' => $e->getTraceAsString()
            ]);
        }
        return $this->success(trans('condorauth.ok'), [
            'captcha' => Captcha::imageCaptcha($event)
        ]);
    }

    /**
     * 注册
     * @param Request $request
     * @return Response
     * @throws \Throwable
     */
    public function register(Request $request): Response
    {
        try {
            $params = $request->post();
            $data = v::input($params, [
                'username' => v::alnum()->length(4, 20)->setName(trans('condorauth.username'))->setTemplate(trans('condorauth.validation.required')),
                'password' => v::alnum()->length(6, 20)->setName(trans('condorauth.password'))->setTemplate(trans('condorauth.validation.required')),
                'captcha' => v::alnum()->length(4, 4)->setName(trans('condorauth.captcha'))->setTemplate(trans('condorauth.validation.required')),
                'invite_code' => v::optional(v::alnum()->length(4, 4))->setName(trans('condorauth.invite_code')),
            ]);
            // 验证码
            if(Captcha::checkCaptcha('register', $data['captcha']) === false) {
                return $this->fail(trans('condorauth.captcha.error'));
            }
            \plugin\condorauth\app\service\UserService::register($data);
        } catch (ValidationException $e) {
            return $this->fail($e->getMessage());
        } catch (\Exception $e) {
            return $this->fail($e->getMessage());
        }
        return $this->success(trans('condorauth.ok'), []);
    }

    /**
     * 登录
     * @param Request $request
     * @return Response
     * @throws \Throwable
     */
    public function login(Request $request): Response
    {
        $type = $request->post('type', 'password');
        $params = $request->post();

        try {
            $result = (new LoginService())->login($type, $params);
            if ($result->success) {
                return $this->success(trans('condorauth.ok'), $result->user);
            }
            return $this->fail($result->message);
        } catch (\Throwable $e) {
            return json([
                'success' => false,
                'msg' => $e->getMessage()
            ]);
        }
    }
}
