<?php

return [
    'admin.login' => [
        [plugin\condoradmin\app\event\SystemLog::class, 'login']
    ],
    'admin.operate' => [
        [plugin\condoradmin\app\event\SystemLog::class, 'operate']
    ],
];
