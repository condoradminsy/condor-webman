<?php

namespace plugin\condoradmin\app\controller;

use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemLoginLog;

class LoginLogController extends Backend
{

    protected array $searchable = [
        'username' => ['type' => 'string'],
        'status' => ['type' => 'int'],
    ];

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemLoginLog();
    }
}
