<?php

namespace plugin\condorauth\app\service;

use plugin\condorauth\app\model\SystemUser;
use Exception;

class UserService
{

    /**
     * @param $data
     * @return mixed
     * 注册
     **/
    public static function register($data)
    {
        // 用户是否存在
        $user = SystemUser::where('username', $data['username'])->first();
        if ($user) {
            throw new Exception(trans('condorauth.user.already.exists'));
        }
        // 邀请码
        $pid = 0;
        if ($data['invite_code']) {
            $pid = SystemUser::where('invite_code', $data['invite_code'])->value('id') ?? 0;
        }
        $user = SystemUser::create([
            'username' => $data['username'],
            'password' => getEnctyptPassword($data['password']),
            'pid' => $pid,
            'invite_code' => getInviteCode(),
            'register_ip' => request()->getRealIp(),
        ]);
        return $user;
    }
}
