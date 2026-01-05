<?php
return [
    'enable' => env('LOG_ENABLE', false),
    'exception' => [
        // 是否记录异常到日志
        'enable' => env('LOG_EXCEPTION_ENABLE', false),
        // 不会记录到日志的异常类
        'dontReport' => [
            support\exception\BusinessException::class
        ]
    ],
    'dontReport' => [
        'app' => [],
        'controller' => [],
        'action' => [],
        'path' => []
    ],
    'channel' => 'default' // 日志通道(在config/log.php里配置,默认是default)
];
