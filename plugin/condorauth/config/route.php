<?php

use Webman\Route;

Route::disableDefaultRoute('condorauth');
Route::group('/api', function () {

    Route::group('/auth', function () {

        Route::post('/captcha', [\plugin\condorauth\app\controller\AuthController::class, 'captcha']);
        Route::post('/register', [\plugin\condorauth\app\controller\AuthController::class, 'register']);
        Route::post('/login', [\plugin\condorauth\app\controller\AuthController::class, 'login']);
        
    });

});
