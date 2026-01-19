<?php

namespace plugin\condoradmin\app\middleware;

use ReflectionClass;
use Webman\Http\Request;
use Webman\Http\Response;
use Webman\MiddlewareInterface;
use Webman\Event\Event;

class OperateLog implements MiddlewareInterface
{

    /**
     * @param Request $request
     * @param callable $handler
     * @return Response
     */
    public function process(Request $request, callable $handler): Response
    {
        // 通过反射获取控制器哪些方法不需要登录
        $controller = new ReflectionClass($request->controller);
        $noNeedLogin = $controller->getDefaultProperties()['noNeedLogin'] ?? [];
        // 访问的方法需要登录
        if (!in_array($request->action, $noNeedLogin)) {
            // 记录日志
            Event::emit('admin.operate', true);
        }
        return $handler($request);
    }
}
