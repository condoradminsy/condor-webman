<?php

namespace plugin\condoradmin\app\controller;

use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemAdminLog;

class AdminLogController extends Backend
{

    protected array $searchable = [
        'username' => ['type' => 'string'],
        'title' => ['type' => 'string'],
        'url' => ['type' => 'string'],
    ];

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemAdminLog();
    }
}
