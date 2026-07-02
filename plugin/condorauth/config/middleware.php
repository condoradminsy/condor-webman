<?php

use plugin\condorauth\app\middleware\AuthToken;
use plugin\condoradmin\app\middleware\AuthToken as AdminAuthToken;
use plugin\condoradmin\app\middleware\AuthPermission;
use plugin\condoradmin\app\middleware\OperateLog;

return [
    'api' => [
        AuthToken::class
    ],
    'admin' => [
        AdminAuthToken::class,
        AuthPermission::class,
        OperateLog::class
    ]
];
