<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemAttachment;

class AttachmentController extends Backend
{
    protected $selectFields = ['a.*'];

    protected $alias = 'a';

    protected $excludeSearchValues = ['a.type' => 'all'];

    protected array $searchable = [
        'a.type' => [
            'type' => 'string'
        ],
        'a.type_id' => [
            'type' => 'int',
            'join' => [
                'table' => 'system_attachment_type',
                'alias' => 't',
                'fields' => ['t.name as type_name'],
                'on' => [
                    ['a.type_id', '=', 't.id']
                ],
            ]
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
     * @param Request $request
     * @return \support\Response
     */
    public function upload(Request $request)
    {
        $file = $request->file('file');
        if (empty($file)) {
            return $this->fail(trans('condoradmin.no.file.uploaded'));
        }
        $file = is_array($file) ? $file[0] : $file;
        if (!$file->isValid()) {
            return $this->fail(trans('condoradmin.invalid.file'));
        }
        if (!$this->model->validFileMimeType($file->getUploadMimeType())) {
            return $this->fail(trans('condoradmin.invalid.file.type.uploaded'));
        }
        $row = $this->model->upload($file, [
            'admin_id' => $this->auth->id,
            'type_id' => $request->post('type_id', 0),
        ]);
        return $this->success(trans('condoradmin.ok'), $row);
    }
}
