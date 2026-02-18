<?php

namespace plugin\condoradmin\app\controller;

use plugin\condoradmin\app\library\TranslatableBackend;
use plugin\condoradmin\app\model\SystemDictData;
use plugin\condoradmin\app\model\SystemDictDataTranslations;

class DictDataController extends TranslatableBackend
{

    protected $createdByField = 'created_by';
    protected $updatedByField = 'updated_by';

    // 多语言字段
    protected array $multilingualFields = ['remark', 'label'];

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
        // 多语言表模型
        $this->translationModel = new SystemDictDataTranslations();
    }
}
