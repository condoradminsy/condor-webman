<?php

namespace {module}controller;

use plugin\condoradmin\app\library\Backend;
use {module}model\{modelName};

class {controllerName} extends Backend
{

    protected array $searchable = {searchable};

    public function __construct()
    {
        parent::__construct();
        $this->model = new {modelName}();
    }
}