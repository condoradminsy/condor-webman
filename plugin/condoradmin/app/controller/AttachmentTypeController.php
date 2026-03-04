<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\TranslatableBackend;
use plugin\condoradmin\app\model\SystemAttachmentType;
use plugin\condoradmin\app\model\SystemAttachmentTypeTranslations;

class AttachmentTypeController extends TranslatableBackend
{

    protected $dataLimit = true;

    protected array $multilingualFields = ['name'];

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemAttachmentType();
        // 多语言表模型
        $this->translationModel = new SystemAttachmentTypeTranslations();
    }

    public function index(Request $request)
    {
        $list = $this->model->with(['translations'])->get()->toArray();
        return $this->success(trans('ok'), array_merge([
            [
                'id' => 0,
                'name' => [
                    'en-us' => 'Default',
                    'zh-cn' => '默认'
                ]
            ]
        ], $this->renderTranslations($list)));
    }
}
