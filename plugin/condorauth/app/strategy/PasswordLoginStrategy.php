<?php

namespace plugin\condorauth\app\strategy;

use plugin\condorauth\app\model\SystemUser;
use plugin\condorauth\app\factory\LoginResult;
use Tinywan\Jwt\JwtToken;
use support\Redis;
use Webman\Event\Event;

class PasswordLoginStrategy implements LoginStrategy
{
    public function login(array $params): LoginResult
    {
        $user = SystemUser::where('username', $params['username'] ?? '')->first();
        if (!$user) {
            return new LoginResult(false, [], trans('condorauth.user.does.not.exist'));
        }
        if ($user->status != 1) {
            return new LoginResult(false, [], trans('condorauth.user.is.disabled'));
        }
        if (!verifyPassword($params['password'] ?? '', $user->password)) {
            return new LoginResult(false, [], trans('condorauth.password.is.incorrect'));
        }
        $user_id = $user->id;
        $username = $user->username;
        // 生成token
        $token = JwtToken::generateToken([
            'id' => $user_id,
            'username' => $username,
            'app' => request()->plugin
        ]);
        Redis::set('auth:token:' . $token['access_token'], $user_id, $token["expires_in"]);
        $type = 'password';
        Event::emit('user.login', compact('username', 'type', 'user_id'));
        return new LoginResult(true, [
            'id' => $user_id,
            'username' => $username,
            'nickname' => $user->nickname,
            'avatar' => $user->avatar,
            'token' => $token
        ]);
    }
}
