<?php

return [
    'enable' => true,
    'storage' => [
        'default'      => env('STORAGE_DRIVER', 'local'),
        'single_limit' => 1024 * 1024 * 200,
        'total_limit'  => 1024 * 1024 * 200,
        'nums'         => 10,
        'include'      => [],
        'exclude'      => [],

        // 本地存储：文件写入 public/uploads，可直接通过 HTTP 访问
        'local' => [
            'adapter' => \Tinywan\Storage\Adapter\LocalAdapter::class,
            'root'    => public_path() . '/uploads/',
            'dirname' => function () {
                return date('Ymd');
            },
            'domain'  => env('APP_DOMAIN', ''),  // 空字符串时 url 字段即为相对路径
            'uri'     => '/uploads/',
            'algo'    => 'sha1',
        ],

        // 阿里云 OSS
        'oss' => [
            'adapter'         => \Tinywan\Storage\Adapter\OssAdapter::class,
            'accessKeyId'     => env('OSS_ACCESS_KEY_ID', ''),
            'accessKeySecret' => env('OSS_ACCESS_KEY_SECRET', ''),
            'bucket'          => env('OSS_BUCKET', ''),
            'dirname'         => function () {
                return 'uploads/' . date('Ymd');
            },
            'domain'          => env('OSS_DOMAIN', ''),
            'endpoint'        => env('OSS_ENDPOINT', ''),
            'algo'            => 'sha1',
        ],

        // 腾讯云 COS
        'cos' => [
            'adapter'   => \Tinywan\Storage\Adapter\CosAdapter::class,
            'secretId'  => env('COS_SECRET_ID', ''),
            'secretKey' => env('COS_SECRET_KEY', ''),
            'bucket'    => env('COS_BUCKET', ''),
            'dirname'   => function () {
                return 'uploads/' . date('Ymd');
            },
            'domain'    => env('COS_DOMAIN', ''),
            'region'    => env('COS_REGION', 'ap-guangzhou'),
        ],

        // 七牛云
        'qiniu' => [
            'adapter'   => \Tinywan\Storage\Adapter\QiniuAdapter::class,
            'accessKey' => env('QINIU_ACCESS_KEY', ''),
            'secretKey' => env('QINIU_SECRET_KEY', ''),
            'bucket'    => env('QINIU_BUCKET', ''),
            'dirname'   => function () {
                return 'uploads/' . date('Ymd');
            },
            'domain'    => env('QINIU_DOMAIN', ''),
        ],

        // AWS S3 / 兼容协议（MinIO 等）
        's3' => [
            'adapter'                 => \Tinywan\Storage\Adapter\S3Adapter::class,
            'key'                     => env('S3_ACCESS_KEY', ''),
            'secret'                  => env('S3_SECRET_KEY', ''),
            'bucket'                  => env('S3_BUCKET', ''),
            'dirname'                 => function () {
                return 'uploads/' . date('Ymd');
            },
            'domain'                  => env('S3_DOMAIN', ''),
            'region'                  => env('S3_REGION', ''),
            'version'                 => 'latest',
            'use_path_style_endpoint' => (bool) env('S3_PATH_STYLE', false),
            'endpoint'                => env('S3_ENDPOINT', ''),
            'acl'                     => env('S3_ACL', 'public-read'),
        ],
    ],
];
