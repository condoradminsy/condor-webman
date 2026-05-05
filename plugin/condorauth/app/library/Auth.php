<?php

namespace plugin\condorauth\app\library;

use plugin\condorauth\app\model\SystemUser;
use plugin\condoradmin\exception\ApiException;

class Auth
{
    protected $userinfo = [];


    public function __get($name)
    {
        return $this->userinfo[$name] ?? null;
    }

    /**
     * 初始化用户
     * @throws ApiException
     */
    public function initUser()
    {
        $tokenInfo = getCurrentInfo();
        if ($tokenInfo === false) {
            throw new ApiException(trans('condorauth.invalid.token'), 401);
        }
        $userinfo = SystemUser::select(
            'id',
            'username',
            'nickname',
            'avatar',
            'email',
            'status',
            'createtime',
            'logintime'
        )->find($tokenInfo['id']);
        if (empty($userinfo)) {
            throw new ApiException(trans('condorauth.user.does.not.exist'));
        }
        if ($userinfo->status !== 1) {
            throw new ApiException(trans('condorauth.user.is.disabled'));
        }
        $this->userinfo = $userinfo->toArray();
    }


    /**
     * 获得用户资料
     * @param int $uid 用户id
     * @return mixed
     */
    public function getUserInfo()
    {
        if (!empty($this->userinfo)) return $this->userinfo;
        $this->initUser();
        return $this->userinfo;
    }
}
