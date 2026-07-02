<?php

namespace plugin\condorauth\app\api\controller;

use plugin\condorauth\app\library\Frontend;
use plugin\condoradmin\app\library\Captcha;
use plugin\condoradmin\app\library\Email;
use plugin\condorauth\app\service\SmsService;
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
    protected $noNeedLogin = ['captcha', 'register', 'login', 'sendSmsCode', 'sendEmailCode'];

    /**
     * 获取图形验证码
     * @param Request $request
     * @return Response
     * @throws \Throwable
     */
    public function captcha(Request $request): Response
    {
        $ip = $request->getRealIp();
        $event = $request->post('event', 'login');
        $limitKey = 'condor:auth:captcha:' . $ip;
        try {
            $count = (int)Redis::incr($limitKey);
            if ($count === 1) {
                Redis::expire($limitKey, 30);
            }
            if ($count > 5) {
                return $this->fail(trans('condorauth.too.many.requests.please.try.again.later'));
            }
        } catch (\Throwable $e) {
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
     * 发送短信验证码
     * @param Request $request
     * @return Response
     */
    public function sendSmsCode(Request $request): Response
    {
        try {
            $params = $request->post();
            $data = v::input($params, [
                'mobile' => v::regex('/^1[3-9]\d{9}$/')->setName(trans('condorauth.mobile'))->setTemplate(trans('condorauth.validation.required')),
            ]);
            $event = 'sms_login';
            SmsService::sendCode($data['mobile'], $event);
        } catch (ValidationException $e) {
            return $this->fail($e->getMessage());
        } catch (\RuntimeException $e) {
            return $this->fail($e->getMessage());
        }
        return $this->success(trans('condorauth.sms.code.sent'));
    }

    /**
     * 发送邮箱验证码
     * @param Request $request
     * @return Response
     */
    public function sendEmailCode(Request $request): Response
    {
        try {
            $params = $request->post();
            $data = v::input($params, [
                'email' => v::email()->setName(trans('condorauth.email'))->setTemplate(trans('condorauth.validation.required')),
            ]);
            $email = $data['email'];
            $limitKey = 'condor:auth:email_limit:' . $email;
            if (Redis::get($limitKey)) {
                return $this->fail(trans('condorauth.send.code.too.frequent'));
            }
            $event = 'email_login';
            $code = Captcha::numberCaptcha($event, 6);
            $subject = trans('condorauth.email.code.subject');
            $body = trans('condorauth.email.code.body', ['code' => $code]);
            Email::send($email, $subject, $body);
            Redis::set($limitKey, 1, 'EX', 60);
        } catch (ValidationException $e) {
            return $this->fail($e->getMessage());
        } catch (\RuntimeException $e) {
            return $this->fail($e->getMessage());
        }
        return $this->success(trans('condorauth.email.code.sent'));
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
