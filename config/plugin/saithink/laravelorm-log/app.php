<?php

return [
    // 是否启用日志记录
    'enable' => env('MYSQL_LOG', false),
    // 是否输出到控制台
    'console'   => env('MYSQL_LOG_CONSOLE', false),
    // 是否记录到日志文件
    'file'  => env('MYSQL_LOG_FILE', false),
];
