<?php

use Webman\Route;

Route::disableDefaultRoute('condoradmin');

Route::group('/core', function () {

    // 路由配置
    Route::group('/common', function () {
        Route::get('/captcha', [\plugin\condoradmin\app\controller\AccountController::class, 'captcha']);
        Route::post('/login', [\plugin\condoradmin\app\controller\AccountController::class, 'login']);
        Route::get('/getUserInfo', [\plugin\condoradmin\app\controller\AccountController::class, 'getUserInfo']);
        // 
        Route::get('/getRoutes', [\plugin\condoradmin\app\controller\CommonController::class, 'getRoutes']);
        Route::get('/isRouteExist', [\plugin\condoradmin\app\controller\CommonController::class, 'isRouteExist']);
        Route::get('/getPublicKey', [\plugin\condoradmin\app\controller\CommonController::class, 'getPublicKey']);
        Route::get('/getDict', [\plugin\condoradmin\app\controller\CommonController::class, 'getDict']);
        // 
    });

    createRoutes('/menu', \plugin\condoradmin\app\controller\MenuController::class);
    createRoutes('/role', \plugin\condoradmin\app\controller\RoleController::class);
    createRoutes('/dict-type', \plugin\condoradmin\app\controller\DictTypeController::class);
    createRoutes('/dict-data', \plugin\condoradmin\app\controller\DictDataController::class);
    createRoutes('/admin', \plugin\condoradmin\app\controller\AdminController::class);
    createRoutes('/config-group', \plugin\condoradmin\app\controller\ConfigGroupController::class);
    createRoutes('/config', \plugin\condoradmin\app\controller\ConfigController::class);
    Route::post("/config/save", [\plugin\condoradmin\app\controller\ConfigController::class, 'save']);
    createRoutes('/attachment-type', \plugin\condoradmin\app\controller\AttachmentTypeController::class);
    Route::post('/attachment/index', [\plugin\condoradmin\app\controller\AttachmentController::class, 'index']);
    Route::post('/attachment/del', [\plugin\condoradmin\app\controller\AttachmentController::class, 'del']);
    Route::post('/attachment/upload', [\plugin\condoradmin\app\controller\AttachmentController::class, 'upload']);
    createRoutes('/crontab', \plugin\condoradmin\app\controller\CrontabController::class);
    Route::post('/crontab/run-once', [\plugin\condoradmin\app\controller\CrontabController::class, 'runOnce']);
    Route::post('/crontab-log/index', [\plugin\condoradmin\app\controller\CrontabLogController::class, 'index']);

    Route::options('[{path:.+}]', function () {
        return response('');
    });
});
