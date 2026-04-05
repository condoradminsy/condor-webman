<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;


class CommonController extends Backend
{

    /**
     * 不需要登录的方法
     */
    protected $noNeedLogin = ['getPublicKey', 'getConfig'];

    /**
     * 不需要鉴权的方法
     */
    protected $noNeedRight = ['getRoutes', 'getDict'];

    /**
     * 获取路由列表
     */
    public function getRoutes()
    {
        return $this->success(trans('condoradmin.ok'), [
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
            return $this->fail(trans('condoradmin.invalid.parameters'));
        }
        if ($this->auth->isRouteExist($routeName)) {
            return $this->success(trans('condoradmin.ok'), ['isExist' => true]);
        }
        return $this->success(trans('condoradmin.ok'), ['isExist' => false]);
    }

    /**
     * 获取公钥
     */
    public function getPublicKey()
    {
        return $this->success(trans('condoradmin.ok'), [
            'publicKey' => getPublicKeyValue(config('plugin.condoradmin.condor.public_key'))
        ]);
    }

    /**
     * 获取多语言
     * @return void
     */
    public function getConfig()
    {
        return $this->success(trans('condoradmin.ok'), [
            'languages' => config('plugin.condoradmin.translation.languages')
        ]);
    }

    // 字典
    public function getDict()
    {
        $list = \plugin\condoradmin\app\model\SystemDictType::with(['DictData.translations'])
            ->where('status', 1)
            ->where('scope', '<>', 1)
            ->get(['id', 'name'])
            ->toArray();
        $multilingualFields = ['label', 'remark'];
        // 多语言字段处理
        foreach ($list as &$item) {
            foreach ($item['dict_data'] as &$dictData) {
                foreach ($multilingualFields as $field) {
                    $rows = $dictData['translations'];
                    $dictData[$field] =  [];
                    foreach ($rows as $row) {
                        $dictData[$field][$row['locale']] = $row[$field] ?? '';
                    }
                    if (empty($dictData[$field])) {
                        $dictData[$field] =  null;
                    }
                }
                unset($dictData['translations']);
                unset($dictData);
            }
        }
        unset($item);
        return $this->success(trans('condoradmin.ok'), $list);
    }
}
