<?php

namespace plugin\condorauth\app\strategy;

use plugin\condorauth\app\model\SystemUser;
use plugin\condorauth\app\factory\LoginResult;
use plugin\condoradmin\app\library\Captcha;
use Tinywan\Jwt\JwtToken;
use support\Redis;
use Webman\Event\Event;

class EmailLoginStrategy implements LoginStrategy
{
    public function login(array $params): LoginResult
    {
        $email = $params['email'] ?? '';
        $code = $params['email_code'] ?? '';

        if (empty($email) || empty($code)) {
            return new LoginResult(false, [], trans('condorauth.parameter.can.not.be.empty'));
        }

        if (!Captcha::checkCaptcha('email_login', $code)) {
            return new LoginResult(false, [], trans('condorauth.email.code.error'));
        }

        $user = SystemUser::where('email', $email)->first();
        if (!$user) {
            return new LoginResult(false, [], trans('condorauth.user.does.not.exist'));
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

        $type = 'email';
        Event::emit('user.login', compact('username', 'type', 'user_id'));

        return new LoginResult(true, [
            'id' => $user_id,
            'username' => $username,
            'nickname' => $user->nickname,
            'avatar' => $user->avatar,
            'email' => $user->email,
            'token' => $token
        ]);
    }
}
