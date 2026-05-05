<?php

namespace plugin\condorauth\app\middleware;

use ReflectionException;
use support\exception\BusinessException;
use Webman\Http\Request;
use Webman\Http\Response;
use Webman\MiddlewareInterface;
use support\Redis;
use support\Context;

class AuthToken implements MiddlewareInterface
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
        $tokenInfo = getCurrentInfo();
        if ($tokenInfo === false) {
            $code = 401;
            $msg = trans('condorauth.please.log.in.first');
            if ($request->expectsJson()) {
                $response = json(['code' => $code, 'msg' => $msg, 'data' => []]);
            } else {
                $response = response($msg, $code);
            }
            return $response;
        } else {
            if (!isset($tokenInfo['app']) || $request->plugin !== $tokenInfo['app']) {
                return json(['code' => 403, 'msg' => trans('condorauth.access.denied'), 'data' => []]);
            }
            $token = $request->header('authorization');
            $token = str_replace('Bearer ', '', $token);
            // 验证token是否有效，可操作token 失效
            $user_id = Redis::get('auth:token:' . $token);
            if (!$user_id) {
                return json(['code' => 401, 'msg' => trans('condorauth.invalid.token'), 'data' => []]);
            }
            // 获取当前请求的auth        
            $auth = new \plugin\condorauth\app\library\Auth();
            // 初始化
            $auth->initUser();
            // 设置当前请求的auth
            Context::set('auth', $auth);
            return $handler($request);
        }
    }
}
