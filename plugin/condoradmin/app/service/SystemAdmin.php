<?php

namespace plugin\condoradmin\app\service;

use plugin\condoradmin\app\model\SystemAdmin as AdminModel;
use Tinywan\Jwt\JwtToken;
use plugin\condoradmin\exception\ApiException;
use support\Redis;
use Webman\Event\Event;

class SystemAdmin extends BaseService
{
    /**
     * 构造函数
     */
    public function __construct()
    {
        $this->model = new AdminModel();
    }
    /**
     * 用户登录
     * @param string $username
     * @param string $password
     * @param string $type
     * @return array
     */
    public function login(string $username, string $password): array
    {
        $adminInfo = $this->model->where('username', $username)->first();
        $status = 1;
        $msg = '';
        if (empty($adminInfo)) {
            $msg = 'condoradmin.incorrect.username.or.password.please.try.again';
            $status = 2;
        }
        if ($status === 1 && $adminInfo->status === 2) {
            $status = 2;
            $msg = 'condoradmin.access.denied.you.are.not.permitted.to.log.in';
        }
        if ($status === 1 && !verifyPassword($password, $adminInfo->password)) {
            $status = 2;
            $msg = 'condoradmin.incorrect.password.please.try.again';
        }
        if ($status === 2) {
            $message = trans($msg, [], null, 'zh_cn');
            // 登录事件
            Event::emit('admin.login', compact('username', 'status', 'message'));
            if ($adminInfo) {
                $adminInfo->loginfailure = $adminInfo->loginfailure + 1;
                $adminInfo->save();
            }
            throw new ApiException(trans($msg));
        }
        $adminInfo->logintime = time();
        $adminInfo->loginip = request()->getRealIp();
        $adminInfo->save();
        // 生成token
        $token = JwtToken::generateToken([
            'id' => $adminInfo->id,
            'username' => $adminInfo->username,
            'app' => request()->plugin
        ]);
        // 登录事件
        $admin_id = $adminInfo->id;
        Redis::set('admin:token:' . $token['access_token'], $admin_id, $token["expires_in"]);
        $message = '登录成功';
        Event::emit('admin.login', compact('username', 'status', 'message', 'admin_id'));
        return $token;
    }
}
