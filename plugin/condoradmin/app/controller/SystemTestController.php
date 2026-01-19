<?php

namespace plugin\condoradmin\app\controller;

use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemTest;

class SystemTestController extends Backend
{

    protected array $searchable = [
        'id' => ['type' => 'int'],
        'name' => ['type' => 'string'],
        'target' => ['type' => 'string'],
        'image' => ['type' => 'string'],
        'createtime' => ['type' => 'string'],
        'updatetime' => ['type' => 'int'],
    ];

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemTest();
    }
}