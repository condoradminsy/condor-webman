<?php

use Webman\Route;
Route::disableDefaultRoute('condoradmin');
Route::group('/core', function () {
    // 路由配置
    Route::group('/common', function () {
        Route::get('/captcha', [\plugin\condoradmin\app\controller\AccountController::class, 'captcha']);
        Route::post('/login', [\plugin\condoradmin\app\controller\AccountController::class, 'login']);
        Route::get('/getUserInfo', [\plugin\condoradmin\app\controller\AccountController::class, 'getUserInfo']);
        Route::post('/updateProfile', [\plugin\condoradmin\app\controller\AccountController::class, 'updateProfile']);
        // 
        Route::get('/getRoutes', [\plugin\condoradmin\app\controller\CommonController::class, 'getRoutes']);
        Route::get('/isRouteExist', [\plugin\condoradmin\app\controller\CommonController::class, 'isRouteExist']);
        Route::get('/getPublicKey', [\plugin\condoradmin\app\controller\CommonController::class, 'getPublicKey']);
        Route::get('/getDict', [\plugin\condoradmin\app\controller\CommonController::class, 'getDict']);
        Route::get('/getConfig', [\plugin\condoradmin\app\controller\CommonController::class, 'getConfig']);
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
    Route::post("/config/send-test-email", [\plugin\condoradmin\app\controller\ConfigController::class, 'sendTestEmail']);
    createRoutes('/attachment-type', \plugin\condoradmin\app\controller\AttachmentTypeController::class);
    Route::post('/attachment/index', [\plugin\condoradmin\app\controller\AttachmentController::class, 'index']);
    Route::post('/attachment/del', [\plugin\condoradmin\app\controller\AttachmentController::class, 'del']);
    Route::post('/attachment/upload', [\plugin\condoradmin\app\controller\AttachmentController::class, 'upload']);
    createRoutes('/crontab', \plugin\condoradmin\app\controller\CrontabController::class);
    Route::post('/crontab/run-once', [\plugin\condoradmin\app\controller\CrontabController::class, 'runOnce']);
    Route::post('/crontab-log/index', [\plugin\condoradmin\app\controller\CrontabLogController::class, 'index']);
    // 日志
    Route::post('/login-log/index', [\plugin\condoradmin\app\controller\LoginLogController::class, 'index']);
    Route::post('/login-log/del', [\plugin\condoradmin\app\controller\LoginLogController::class, 'del']);
    Route::post('/admin-log/index', [\plugin\condoradmin\app\controller\AdminLogController::class, 'index']);
    Route::post('/admin-log/del', [\plugin\condoradmin\app\controller\AdminLogController::class, 'del']);
    // crud
    Route::get('/crud/config', [\plugin\condoradmin\app\controller\CrudController::class, 'config']);
    Route::post('/crud/fields', [\plugin\condoradmin\app\controller\CrudController::class, 'fields']);
    Route::post('/crud/create', [\plugin\condoradmin\app\controller\CrudController::class, 'create']);
    createRoutes('/system-test', \plugin\condoradmin\app\controller\SystemTestController::class);
    Route::options('[{path:.+}]', function () {
        return response('');
    });
});