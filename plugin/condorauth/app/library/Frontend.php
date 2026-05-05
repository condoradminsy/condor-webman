<?php

namespace plugin\condorauth\app\library;

use support\Response;
use support\Context;

class Frontend
{

    public function __construct()
    {
        $this->auth = Context::get('auth');
    }

    /**
     * 无需登录的方法
     * @var array
     */
    protected $noNeedLogin = [];

    /**
     * @var Model
     */
    protected $model = null;


    /**
     * 获取当前登录用户信息
     */
    protected $auth = null;


    /**
     * 返回格式化json数据
     *
     * @param int $code
     * @param string $msg
     * @param array $data
     * @return Response
     */
    protected function json(string | int $code, string $msg = 'ok', $data = []): Response
    {
        return json(['code' => $code, 'data' => $data, 'msg' => $msg]);
    }

    /**
     * 返回成功数据
     */
    protected function success(string $msg = 'Success', $data = []): Response
    {
        return $this->json('0000', $msg, $data);
    }

    /**
     * 返回失败数据
     */
    protected function fail(string $msg = 'Fail', $data = []): Response
    {
        return $this->json(4000, $msg, $data);
    }
}
