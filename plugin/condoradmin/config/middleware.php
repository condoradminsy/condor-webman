<?php

use plugin\condoradmin\app\middleware\AuthToken;
use plugin\condoradmin\app\middleware\AuthPermission;
// use plugin\condoradmin\app\middleware\CrossDomain;

return [
    '' => [
        // CrossDomain::class,
        AuthToken::class,
        AuthPermission::class,
    ]
];
