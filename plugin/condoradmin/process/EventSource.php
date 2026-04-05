<?php

namespace plugin\condoradmin\process;

use Workerman\Connection\TcpConnection;
use Workerman\Protocols\Http\Request;
use Workerman\Protocols\Http\Response;
use Workerman\Protocols\Http\ServerSentEvents;
use Webman\Channel\Client;
use Tinywan\Jwt\JwtToken;
use Workerman\Timer;
use support\Log;

class EventSource
{

    // 所有链接 ['uid' => ['conn_id' => TcpConnection]]
    protected static $uidConnections = [];
    // 每个用户允许的最大并发连接数（可通过配置覆盖）
    protected static $maxConnectionsPerUser = 10;

    public function __construct()
    {
        Client::connect();
        // 订阅事件并注册回调
        Client::on('condor_sse_broadcast', function ($data) {
            self::dispatchMessage($data);
        });
    }

    public function onWorkerStart()
    {
        // 全局心跳
        Timer::add(30, function () {
            foreach (self::$uidConnections as $key => $connections) {
                foreach ($connections as $conn_id => $connection) {
                    if ($connection->getStatus() !== TcpConnection::STATUS_ESTABLISHED) {
                        // 连接已断开
                        unset(self::$uidConnections[$key][$conn_id]);
                    } else {
                        // 连接正常
                        self::sendEvent($connection, 'heartbeat', ['message' => 'ping']);
                    }
                }
            }
        });
    }

    /**
     * @ 发送事件
     * @param TcpConnection $connection
     * @param Request $request
     * @return void
     */
    public function onMessage(TcpConnection $connection, Request $request)
    {
        try {
            // 处理预检请求
            if ($this->handlePreflight($connection, $request)) {
                return;
            }
            // 检查是否为 SSE 请求
            if (!$this->isEventStreamRequest($request)) {
                $this->sendError($connection, 500, 'Requires text/event-stream accept header');
                return;
            }
            // 设置跨域头
            $corsHeaders = $this->getCorsHeaders($request);
            // 发送 SSE 响应头
            $responseHeaders = array_merge([
                'Content-Type' => 'text/event-stream',
                'Cache-Control' => 'no-cache, no-store, must-revalidate',
                'Connection' => 'keep-alive',
                'X-Accel-Buffering' => 'no'
            ], $corsHeaders);

            $connection->send(new Response(200, $responseHeaders));
            // 身份验证
            $userinfo = $this->authenticate($request);
            // 身份验证失败
            if (!$userinfo) {
                $this->sendError($connection, 401, 'Unauthorized');
                return;
            }
            // 绑定用户
            if ($this->bindUser($connection, $userinfo) === false) {
                return;
            };
            // 发送连接确认
            self::sendEvent($connection, 'connected', ['status' => 'connected']);
        } catch (\Exception $e) {
            Log::error('sse error: ' . $e->getMessage());
            $this->sendError($connection, 500, 'Server Error');
        }
    }

    /**
     * 响应错误
     * @return void
     */
    protected function sendError(TcpConnection $connection, $code, $message)
    {
        $connection->send(new Response($code, [
            'Content-Type' => 'application/json',
        ], json_encode([
            'code' => $code,
            'message' => $message
        ])));
        $connection->close();
    }

    /**
     * @ 身份验证
     * @param Request $request
     * @return void
     */
    protected function authenticate(Request $request)
    {
        try {
            $token = str_replace('Bearer ', '', $request->header('Authorization'));
            $userinfo = JwtToken::verify(1, $token);
            return $userinfo['extend'] ?? false;
        } catch (\Exception $e) {
            return false;
        }
    }

    /**
     * @ 处理预检请求
     * @param TcpConnection $connection
     * @param Request $request
     * @return boolean
     */
    protected function handlePreflight(TcpConnection $connection, Request $request): bool
    {
        if ($request->method() === 'OPTIONS') {
            $origin = $request->header('origin') ?: '*';
            // 规范化 origin，去掉重复或逗号分隔的重复值
            if (strpos($origin, ',') !== false) {
                $parts = array_filter(array_map('trim', explode(',', $origin)));
                $parts = array_values(array_unique($parts));
                $origin = $parts[0] ?? '*';
            }
            $connection->send(new Response(204, [
                'Access-Control-Allow-Origin' => $origin,
                'Access-Control-Allow-Credentials' => 'true',
                'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS',
                'Access-Control-Allow-Headers' => 'Content-Type, Authorization, Accept, X-Requested-With, Last-Event-Id',
                'Access-Control-Max-Age' => '86400',
                'Content-Length' => '0'
            ]));
            return true;
        }
        return false;
    }

    /**
     * @ 获取跨域头
     * @param Request $request
     * @return array
     */
    protected function getCorsHeaders(Request $request): array
    {
        $origin = $request->header('origin') ?: '*';
        if (strpos($origin, ',') !== false) {
            $parts = array_filter(array_map('trim', explode(',', $origin)));
            $parts = array_values(array_unique($parts));
            $origin = $parts[0] ?? '*';
        }
        return [
            'Access-Control-Allow-Origin' => $origin,
            'Access-Control-Allow-Credentials' => 'true',
            'Access-Control-Expose-Headers' => '*'
        ];
    }

    /**
     * @ 判断是否为 SSE 请求
     * @param Request $request
     * @return boolean
     */
    protected function isEventStreamRequest(Request $request): bool
    {
        $accept = strtolower($request->header('accept', ''));
        if (strpos($accept, 'text/event-stream') !== false) return true;
        return $request->method() === 'GET' && stripos($request->header('upgrade', ''), 'sse') !== false;
    }

    /**
     * @ 绑定用户
     * @param TcpConnection $connection
     * @param array $userinfo
     * @return void
     */
    protected function bindUser(TcpConnection $connection, array $userinfo): bool
    {
        $uid = $userinfo['id'] ?? 0;
        $app = $userinfo['app'] ?? 'default';
        $key = "{$app}_{$uid}";
        if (!isset(self::$uidConnections[$key])) {
            self::$uidConnections[$key] = [];
        }
        $connection->app_key = $key;
        $conn_id = $connection->id;
        $max = self::$maxConnectionsPerUser;
        try {
            if (function_exists('config')) {
                $cfg = config('plugin.condoradmin.sse.max_connections_per_user');
                if ($cfg && is_numeric($cfg)) {
                    $max = (int)$cfg;
                }
            }
        } catch (\Throwable $_) {
        }
        $currentCount = count(self::$uidConnections[$key]);
        if ($currentCount >= $max) {
            // 达到上限，拒绝本次新连接
            $this->sendError($connection, 429, 'Too Many Connections');
            return false;
        }
        self::$uidConnections[$key][$conn_id] = $connection;
        return true;
    }

    /**
     * @ 解绑用户
     * @param TcpConnection $connection
     * @return void
     */
    protected function unbindUser(TcpConnection $connection)
    {
        if (!isset($connection->app_key)) {
            return;
        }
        $key = $connection->app_key;
        $conn_id = $connection->id;
        if (isset(self::$uidConnections[$key][$conn_id])) {
            unset(self::$uidConnections[$key][$conn_id]);
        }
        // 全部没了
        if (empty(self::$uidConnections[$key])) {
            unset(self::$uidConnections[$key]);
        }
    }

    /**
     * @ 分发消息
     * @param [type] $data
     * @return void
     */
    protected static function dispatchMessage($data)
    {
        try {
            $data = is_array($data) ? $data : json_decode($data, true);
            $uid = $data['user_id'] ?? 0;
            if ($uid === -1) {
                // 广播
                foreach (self::$uidConnections as $connections) {
                    foreach ($connections as $connection) {
                        self::sendEvent($connection, 'message', $data);
                    }
                }
                return;
            }
            $app = $data['app'] ?? 'default';
            $key = "{$app}_{$uid}";
            if (!isset(self::$uidConnections[$key])) {
                return;
            }
            foreach (self::$uidConnections[$key] as $connection) {
                if ($connection->getStatus() === TcpConnection::STATUS_ESTABLISHED) {
                    self::sendEvent($connection, 'message', $data);
                } else {
                    unset(self::$uidConnections[$key][$connection->id]);
                }
            }
        } catch (\Exception $e) {
            Log::error("EventSource dispatch error: {$e->getMessage()}");
        }
    }

    /**
     * @ 发送事件
     * @param TcpConnection $connection
     * @param string $event
     * @param array $data
     * @return bool
     */
    protected static function sendEvent(TcpConnection $connection, string $event, array $data): bool
    {
        if ($connection->getStatus() !== TcpConnection::STATUS_ESTABLISHED) {
            return false;
        }
        try {
            $sse = new ServerSentEvents([
                'event' => $event,
                'data' => json_encode($data),
                'id' => uniqid()
            ]);
            $connection->send($sse);
            return true;
        } catch (\Exception $e) {
            Log::error("EventSource send error: {$e->getMessage()}");
            return false;
        }
    }

    public function onClose(TcpConnection $connection)
    {
        $this->unbindUser($connection);
    }

    public function onError(TcpConnection $connection, int $code, string $msg)
    {
        Log::error("EventSource error: {$code} - {$msg}");
        $connection->close();
    }

    public function __destruct()
    {
        // 关闭所有连接
        foreach (self::$uidConnections as $connections) {
            foreach ($connections as $connection) {
                $connection->close();
            }
        }
    }
}
