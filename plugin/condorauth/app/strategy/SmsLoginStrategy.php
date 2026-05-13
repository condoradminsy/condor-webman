<?php

namespace plugin\condorauth\app\strategy;

use plugin\condorauth\app\model\SystemUser;
use plugin\condorauth\app\factory\LoginResult;
use plugin\condorauth\app\service\SmsService;
use Tinywan\Jwt\JwtToken;
use support\Redis;
use Webman\Event\Event;

class SmsLoginStrategy implements LoginStrategy
{
    public function login(array $params): LoginResult
    {
        $mobile = $params['mobile'] ?? '';
        $code = $params['sms_code'] ?? '';

        if (empty($mobile) || empty($code)) {
            return new LoginResult(false, [], trans('condorauth.parameter.can.not.be.empty'));
        }

        if (!SmsService::checkCode($code, 'sms_login')) {
            return new LoginResult(false, [], trans('condorauth.sms.code.error'));
        }

        $user = SystemUser::where('mobile', $mobile)->first();
        if (!$user) {
            $user = SystemUser::create([
                'username' => $mobile,
                'mobile' => $mobile,
                'nickname' => $mobile,
                'password' => getEnctyptPassword(uniqid()),
                'register_ip' => request()->getRealIp(),
                'invite_code' => getInviteCode(),
            ]);
        }

        if ($user->status != 1) {
            return new LoginResult(false, [], trans('condorauth.user.is.disabled'));
        }

        $user_id = $user->id;
        $username = $user->username;

        $token = JwtToken::generateToken([
            'id' => $user_id,
            'username' => $username,
            'app' => request()->plugin
        ]);
        Redis::set('auth:token:' . $token['access_token'], $user_id, $token["expires_in"]);

        $type = 'sms';
        Event::emit('user.login', compact('username', 'type', 'user_id'));

        return new LoginResult(true, [
            'id' => $user_id,
            'username' => $username,
            'nickname' => $user->nickname,
            'avatar' => $user->avatar,
            'mobile' => $user->mobile,
            'token' => $token
        ]);
    }
}
