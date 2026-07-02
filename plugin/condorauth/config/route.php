<?php

use Webman\Route;

Route::disableDefaultRoute('condorauth');

// 后台管理路由
Route::group('/core/condorauth', function () {
    // 用户管理
    createRoutes('/user', \plugin\condorauth\app\admin\controller\UserController::class);
});

// 前端 API 路由
Route::group('/api', function () {
    Route::group('/auth', function () {
        Route::post('/captcha', [\plugin\condorauth\app\api\controller\AuthController::class, 'captcha']);
        Route::post('/register', [\plugin\condorauth\app\api\controller\AuthController::class, 'register']);
        Route::post('/login', [\plugin\condorauth\app\api\controller\AuthController::class, 'login']);
        Route::post('/send-sms-code', [\plugin\condorauth\app\api\controller\AuthController::class, 'sendSmsCode']);
        Route::post('/send-email-code', [\plugin\condorauth\app\api\controller\AuthController::class, 'sendEmailCode']);
    });
});
