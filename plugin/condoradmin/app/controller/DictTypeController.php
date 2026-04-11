<?php

namespace plugin\condoradmin\app\controller;

use plugin\condoradmin\app\library\TranslatableBackend;
use plugin\condoradmin\app\model\SystemDictType;
use plugin\condoradmin\app\model\SystemDictTypeTranslations;

class DictTypeController extends TranslatableBackend
{

    protected $createdByField = 'created_by';

    protected $updatedByField = 'updated_by';

    protected $selectpageFields = ['id', 'name'];

    // 多语言字段
    protected array $multilingualFields = ['remark', 'title'];

    protected array $searchable = [
        'title' => ['type' => 'string'],
        'name' => ['type' => 'string'],
        'scope' => ['type' => 'int'],
        'status' => ['type' => 'int'],
    ];

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemDictType();
        // 多语言表模型
        $this->translationModel = new SystemDictTypeTranslations();
    }
}
