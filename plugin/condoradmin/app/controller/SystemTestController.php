<?php

namespace plugin\condoradmin\app\controller;

use plugin\condoradmin\app\library\TranslatableBackend;
use plugin\condoradmin\app\model\SystemTest;
use plugin\condoradmin\app\model\SystemTestTranslations;

class SystemTestController extends TranslatableBackend
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

    // 多语言字段
    protected array $multilingualFields = ['name', 'target', 'title', 'content', 'image', 'images', 'attachfile', 'keywords', 'description'];


    public function __construct()
    {
        parent::__construct();
        // 主表模型
        $this->model = new SystemTest();
        // 多语言表模型
        $this->translationModel = new SystemTestTranslations();
    }
}
