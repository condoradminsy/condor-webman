<?php

namespace plugin\condoradmin\app\event;

use plugin\condoradmin\app\model\SystemLoginLog;
use plugin\condoradmin\app\model\SystemAdminLog;

class SystemLog
{

    /**
     * 登录
     * @param [type] $data
     * @return void
     */
    public function login($data)
    {

        $ip = request()->getRealIp();
        $userAgent = request()->header('user-agent');
        $loginLog = new SystemLoginLog();
        $loginLog->ip = $ip;
        $loginLog->ip_location = getIpLocation($ip);
        $loginLog->os = $this->getOs($userAgent);
        $loginLog->browser = $this->getBrowser($userAgent);
        $loginLog->useragent = $userAgent;
        $loginLog->status = $data['status'];
        $loginLog->login_time = time();
        $loginLog->message = $data['message'];
        $loginLog->created_by = $data['admin_id'] ?? 0;
        $loginLog->username = $data['username'];
        $loginLog->save();
    }


    /**
     * 操作日志
     */
    public function operate()
    {
        $crumb = \plugin\condoradmin\app\library\Breadcrumb::getByPath(request()->path());
        $ip = request()->getRealIp();
        $userAgent = request()->header('user-agent');
        $info = getCurrentInfo();
        $adminLog = new SystemAdminLog();
        $adminLog->ip = $ip;
        $adminLog->ip_location = getIpLocation($ip);
        $adminLog->os = $this->getOs($userAgent);
        $adminLog->browser = $this->getBrowser($userAgent);
        $adminLog->admin_id = $info['id'];
        $adminLog->username = $info['username'];
        $adminLog->url = request()->path();
        $adminLog->title = !empty($crumb) ? implode(' / ', $crumb) : '未知';
        $params = request()->all();
        // 去掉密码
        $blackKey = ['password'];
        foreach ($blackKey as $key) {
            if (isset($params[$key])) {
                unset($params[$key]);
            }
        }
        $adminLog->content = json_encode($params, JSON_UNESCAPED_UNICODE);
        $adminLog->useragent = $userAgent;
        $adminLog->save();
    }


    /**
     * 获取操作系统
     * @param [type] $userAgent
     * @return string
     */
    private function getOs($userAgent): string
    {
        $os = 'Unknown';
        if (preg_match('/win/i', $userAgent)) {
            $os = 'Windows';
        } elseif (preg_match('/mac/i', $userAgent)) {
            $os = 'Mac';
        } elseif (preg_match('/linux/i', $userAgent)) {
            $os = 'Linux';
        } elseif (preg_match('/unix/i', $userAgent)) {
            $os = 'Unix';
        } elseif (preg_match('/sun/i', $userAgent)) {
            $os = 'Solaris';
        } elseif (preg_match('/iphone/i', $userAgent)) {
            $os = 'iPhone';
        } elseif (preg_match('/ipad/i', $userAgent)) {
            $os = 'iPad';
        } elseif (preg_match('/android/i', $userAgent)) {
            $os = 'Android';
        } elseif (preg_match('/ipod/i', $userAgent)) {
            $os = 'iPod';
        } elseif (preg_match('/blackberry/i', $userAgent)) {
            $os = 'BlackBerry';
        } elseif (preg_match('/symbian/i', $userAgent)) {
            $os = 'Symbian';
        } elseif (preg_match('/bot/i', $userAgent)) {
            $os = 'Bot';
        } elseif (preg_match('/spider/i', $userAgent)) {
            $os = 'Spider';
        } elseif (preg_match('/curl/i', $userAgent)) {
            $os = 'Curl';
        } elseif (preg_match('/wget/i', $userAgent)) {
            $os = 'Wget';
        }
        return $os;
    }

    /**
     * 获取浏览器
     * @param [type] $userAgent
     * @return string
     */
    private function getBrowser($userAgent): string
    {
        $browser = 'Unknown';
        if (preg_match('/MSIE|Trident/i', $userAgent) && !preg_match('/Opera/i', $userAgent)) {
            $browser = 'IE';
        } elseif (preg_match('/Firefox/i', $userAgent)) {
            $browser = 'Firefox';
        } elseif (preg_match('/Chrome/i', $userAgent)) {
            $browser = 'Chrome';
        } elseif (preg_match('/Safari/i', $userAgent)) {
            $browser = 'Safari';
        } elseif (preg_match('/Opera/i', $userAgent)) {
            $browser = 'Opera';
        } elseif (preg_match('/Netscape/i', $userAgent)) {
            $browser = 'Netscape';
        } elseif (preg_match('/Edge/i', $userAgent)) {
            $browser = 'Edge';
        } elseif (preg_match('/bot/i', $userAgent)) {
            $browser = 'Bot';
        }
        return $browser;
    }
}
