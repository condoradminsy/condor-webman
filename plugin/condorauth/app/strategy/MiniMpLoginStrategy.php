<?php

namespace plugin\condorauth\app\strategy;

use plugin\condorauth\app\model\SystemUser;
use plugin\condorauth\app\model\SystemThirdUser;
use plugin\condorauth\app\factory\LoginResult;
use Tinywan\Jwt\JwtToken;
use support\Redis;
use support\Log;
use support\Db;
use Webman\Event\Event;
use yzh52521\EasyHttp\Http;

class MiniMpLoginStrategy implements LoginStrategy
{
    public function login(array $params): LoginResult
    {
        $code = $params['code'] ?? '';

        if (empty($code)) {
            return new LoginResult(false, [], trans('condorauth.parameter.can.not.be.empty'));
        }

        $session = $this->code2Session($code);
        if (empty($session['openid'])) {
            return new LoginResult(false, [], $session['errmsg'] ?? trans('condorauth.mini.mp.login.failed'));
        }

        $openid = $session['openid'];
        $unionId = $session['unionid'] ?? null;
        $sessionKey = $session['session_key'] ?? '';

        // 通过 system_third_user 查找已绑定的用户
        $thirdUser = SystemThirdUser::where('platform', 'wechat_mp')
            ->where('open_id', $openid)
            ->first();

        if ($thirdUser) {
            $user = SystemUser::find($thirdUser->user_id);
            if (!$user) {
                return new LoginResult(false, [], trans('condorauth.user.does.not.exist'));
            }
            // 更新 token 信息
            $this->updateThirdUserToken($thirdUser, $sessionKey, $session);
        } else {
            // 创建新用户 + 绑定第三方
            Db::beginTransaction();
            try {
                $user = SystemUser::create([
                    'username' => 'mp_' . substr($openid, -8),
                    'nickname' => $params['nickname'] ?? ('wx_user_' . substr($openid, -8)),
                    'avatar' => $params['avatar'] ?? '',
                    'password' => getEnctyptPassword(uniqid()),
                    'register_ip' => request()->getRealIp(),
                    'invite_code' => getInviteCode(),
                ]);

                SystemThirdUser::create([
                    'user_id' => $user->id,
                    'platform' => 'wechat_mp',
                    'open_id' => $openid,
                    'union_id' => $unionId,
                    'access_token' => $sessionKey,
                    'raw_info' => json_encode($session, JSON_UNESCAPED_UNICODE),
                ]);

                Db::commit();
            } catch (\Throwable $e) {
                Db::rollBack();
                Log::error('MiniMp create user failed: ' . $e->getMessage());
                return new LoginResult(false, [], trans('condorauth.mini.mp.login.failed'));
            }
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

        $type = 'mini-mp';
        Event::emit('user.login', compact('username', 'type', 'user_id'));

        return new LoginResult(true, [
            'id' => $user_id,
            'username' => $username,
            'nickname' => $user->nickname,
            'avatar' => $user->avatar,
            'openid' => $openid,
            'token' => $token
        ]);
    }

    /**
     * 更新第三方用户的 token 信息
     */
    private function updateThirdUserToken(SystemThirdUser $thirdUser, string $sessionKey, array $session): void
    {
        $thirdUser->access_token = $sessionKey;
        $thirdUser->raw_info = json_encode($session, JSON_UNESCAPED_UNICODE);
        if (!empty($session['unionid'])) {
            $thirdUser->union_id = $session['unionid'];
        }
        $thirdUser->save();
    }

    /**
     * 调用微信 code2Session 接口
     */
    private function code2Session(string $code): array
    {
        $appId = env('WECHAT_APPID', '');
        $secret = env('WECHAT_SECRET', '');

        if (empty($appId) || empty($secret)) {
            Log::error('WECHAT_APPID or WECHAT_SECRET not configured');
            return ['errmsg' => 'WeChat config not set'];
        }

        try {
            $response = Http::withOptions([
                'timeout' => 10,
                'verify' => false,
            ])->get('https://api.weixin.qq.com/sns/jscode2session', [
                'appid' => $appId,
                'secret' => $secret,
                'js_code' => $code,
                'grant_type' => 'authorization_code',
            ]);

            $data = $response->array();
            Log::info('WeChat code2Session', ['response' => $data]);

            return $data;
        } catch (\Throwable $e) {
            Log::error('WeChat code2Session request failed: ' . $e->getMessage());
            return ['errmsg' => 'Request failed'];
        }
    }
}
