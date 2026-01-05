<?php

namespace plugin\condoradmin\app\controller;

use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemCrontabLog;

class CrontabLogController extends Backend
{

    protected array $searchable = [
        'crontab_id' => ['type','int'],
        'status' => ['type','int'],
        'name' => ['type','string'],
    ];

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemCrontabLog();
    }
}
