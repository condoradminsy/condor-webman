<?php

namespace plugin\condoradmin\app\controller;

use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemAttachmentType;

class AttachmentTypeController extends Backend
{

    protected $dataLimit = true;

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemAttachmentType();
    }
}
