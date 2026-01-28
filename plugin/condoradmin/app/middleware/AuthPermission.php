<?php

namespace plugin\condoradmin\app\middleware;

use ReflectionException;
use support\exception\BusinessException;
use Webman\Http\Request;
use Webman\Http\Response;
use Webman\MiddlewareInterface;
use support\Context;

class AuthPermission implements MiddlewareInterface
{
    /**
     * @param Request $request
     * @param callable $handler
     * @return Response
     * @throws ReflectionException|BusinessException
     */
    public function process(Request $request, callable $handler): Response
    {
        $controller = $request->controller;
        $action = $request->action;
        // 无控制器信息说明是函数调用，函数不属于任何控制器，鉴权操作应该在函数内部完成。
        if (!$controller) {
            return $handler($request);
        }
        // 获取控制器鉴权信息
        $class = new \ReflectionClass($controller);
        $properties = $class->getDefaultProperties();
        $noNeedLogin = $properties['noNeedLogin'] ?? [];
        // 不需要登录
        if (in_array($action, $noNeedLogin)) {
            return $handler($request);
        }
        // 不需要权限
        $noNeedRight = $properties['noNeedRight'] ?? [];
        // 获取当前请求的auth        
        $auth = new \plugin\condoradmin\app\library\Auth();
        // 查询一下用户信息，确保为被删除，和禁用
        $auth->initUser();
        // 不需要权限
        if (in_array($action, $noNeedRight)) {
            // 设置当前请求的auth
            Context::set('auth', $auth);
            return $handler($request);
        }
        // 检测权限
        if ($auth->check($request->path(), $auth->id) !== true) {
            return json(['code' => 403, 'msg' => trans('condoradmin.access.denied'), 'data' => null]);
        };
        // 设置当前请求的auth
        Context::set('auth', $auth);
        return $handler($request);
    }
}
