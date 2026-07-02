<?php

declare(strict_types=1);

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\library\StorageService;
use plugin\condoradmin\app\model\SystemAttachment;

class AttachmentController extends Backend
{
    protected $selectFields = ['a.*'];

    protected $alias = 'a';

    protected $excludeSearchValues = ['a.type' => 'all'];

    protected array $with = ['AttachmentType.translations'];

    protected array $hidden = ['attachment_type'];

    protected array $searchable = [
        'a.type' => [
            'type' => 'string'
        ],
        'a.type_id' => [
            'type' => 'int',
        ],
        'createtime' => [
            'type' => 'string',
            'as' => 'a.createtime'
        ],
        'filename' => [
            'type' => 'string',
            'as' => 'a.filename'
        ],
        'storage' => [
            'type' => 'string',
            'as' => 'a.storage'
        ]
    ];

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemAttachment();
    }

    /**
     * 上传文件
     */
    public function upload(Request $request): \support\Response
    {
        $file = $request->file('file');
        if (empty($file)) {
            return $this->fail(trans('condoradmin.no.file.uploaded'));
        }
        $file = is_array($file) ? $file[0] : $file;

        try {
            $row = StorageService::upload($file, [
                'admin_id' => $this->auth->id,
                'type_id'  => (int) $request->post('type_id', 0),
                'disk'     => $request->post('disk') ?: null,
            ]);
        } catch (\RuntimeException $e) {
            return $this->fail($e->getMessage());
        }

        return $this->success(trans('condoradmin.ok'), $row);
    }
}
