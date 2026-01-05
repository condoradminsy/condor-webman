<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;


class CommonController extends Backend
{

    /**
     * 不需要登录的方法
     */
    protected $noNeedLogin = ['getPublicKey', 'getDict'];

    /**
     * 不需要鉴权的方法
     */
    protected $noNeedRight = ['getRoutes'];

    /**
     * 获取路由列表
     */
    public function getRoutes()
    {
        return $this->success('获取成功', [
            'routes' => $this->auth->getRuleMenu($this->auth->id),
            'home' => 'home'
        ]);
    }

    /**
     * 检查路由是否存在
     */
    public function isRouteExist(Request $request)
    {
        $routeName = $request->get('routeName', '');
        if (empty($routeName)) {
            return $this->fail('路由名称不能为空');
        }
    }

    /**
     * 获取公钥
     */
    public function getPublicKey()
    {
        return $this->success('获取成功', [
            'publicKey' => getPublicKeyValue(config('plugin.condoradmin.condor.public_key'))
        ]);
    }

    // 字典
    public function getDict()
    {
        $list = \plugin\condoradmin\app\model\SystemDictType::with(['DictData'])
            ->where('status', 1)
            ->where('scope', '<>', 1)
            ->get(['id', 'name', 'title']);
        return $this->success('获取成功', $list);
    }
}
