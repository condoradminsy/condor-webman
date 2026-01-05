<?php

namespace plugin\condoradmin\app\controller;

use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemDictType;

class DictTypeController extends Backend
{

    protected $createdByField = 'created_by';

    protected $updatedByField = 'updated_by';

    protected $selectpageFields = ['id', 'name', 'title'];

    protected array $searchable = [
        'title' => ['type' => 'string'],
    ];

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemDictType();
    }
}
