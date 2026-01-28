<?php

namespace plugin\condoradmin\app\controller;

use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemTest;

class SystemTestController extends Backend
{

    protected array $searchable = [
        'name' => ['type' => 'string'],
        'title' => ['type' => 'string'],
        'price' => ['type' => 'int'],
        'views' => ['type' => 'int'],
        'activitytime' => ['type' => 'int'],
        'refreshtime' => ['type' => 'int'],
        'createtime' => ['type' => 'int'],
    ];

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemTest();
    }
}
