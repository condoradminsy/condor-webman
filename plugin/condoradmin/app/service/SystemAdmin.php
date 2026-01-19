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
        $message = '登录成功';
        if (empty($adminInfo)) {
            $message = '账号或密码错误，请重新输入!';
            throw new ApiException($message);
        }
        if ($adminInfo->status === 2) {
            $status = 2;
            $message = '您已被禁止登录!';
        }
        if (!verifyPassword($password, $adminInfo->password)) {
            $status = 2;
            $message = '密码错误，请重新输入!';
        }
        if ($status === 2) {
            // 登录事件
            Event::emit('admin.login', compact('username', 'status', 'message'));
            $adminInfo->loginfailure = $adminInfo->loginfailure + 1;
            $adminInfo->save();
            throw new ApiException($message);
        }
        $adminInfo->logintime = time();
        $adminInfo->loginip = request()->getRealIp();
        $adminInfo->save();

        $token = JwtToken::generateToken([
            'id' => $adminInfo->id,
            'username' => $adminInfo->username,
            'app' => request()->plugin
        ]);
        // 登录事件
        $admin_id = $adminInfo->id;
        Redis::set('admin:token:' . $token['access_token'], $admin_id, $token["expires_in"]);
        Event::emit('admin.login', compact('username', 'status', 'message', 'admin_id'));
        return $token;
    }
}
