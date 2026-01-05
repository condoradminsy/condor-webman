<?php
return  [
    'default' => 'mysql',
    'connections' => [
        'mysql' => [
            'driver'      => 'mysql',
            'host'        => env('MYSQL_HOST','127.0.0.1'),
            'port'        => env('MYSQL_PORT',3306),
            'database'    => env('MYSQL_DATABASE','webman'),
            'username'    => env('MYSQL_USER',null),
            'password'    => env('MYSQL_PASS',null),
            'prefix'      => env('MYSQL_PREFIX',''),
            'charset'     => 'utf8mb4',
            'collation'   => 'utf8mb4_unicode_ci',
            'strict'      => false,
            'engine'      => null,
            'options'     => [
                PDO::ATTR_EMULATE_PREPARES => false, // Must be false for Swoole and Swow drivers.
            ],
            'pool' => [
                'max_connections' => 5,
                'min_connections' => 1,
                'wait_timeout' => 3,
                'idle_timeout' => 60,
                'heartbeat_interval' => 50,
            ],
        ],
    ],
];