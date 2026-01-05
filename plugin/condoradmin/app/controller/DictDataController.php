<?php

namespace plugin\condoradmin\app\controller;

use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemDictData;

class DictDataController extends Backend
{

    protected $createdByField = 'created_by';
    protected $updatedByField = 'updated_by';

    // 搜索白名单字段
    protected array $searchable = [
        'type_id' => ['type' => 'int'],
        'label' => ['type' => 'array'],
        'value' => ['type' => 'string'],
        'status' => ['type' => 'int'],
    ];

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemDictData();
    }
}
