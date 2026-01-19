<?php

use plugin\condoradmin\app\middleware\AuthToken;
use plugin\condoradmin\app\middleware\AuthPermission;
// use plugin\condoradmin\app\middleware\CrossDomain;
use plugin\condoradmin\app\middleware\OperateLog;

return [
    '' => [
        // CrossDomain::class,
        AuthToken::class,
        AuthPermission::class,
        OperateLog::class
    ]
];
