<?php

namespace plugin\condoradmin\app\model;

use support\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Respect\Validation\Validator as v;

class SystemAttachmentType extends Model
{

    use SoftDeletes;

    /**
     * @var string
     */
    protected $table = 'system_attachment_type';

    /**
     * @var string
     */
    protected $primaryKey = 'id';

    /**
     * 指示是否自动维护时间戳
     *
     * @var bool
     */
    public $timestamps = true;

    protected $dateFormat = 'U';

    // 定义时间戳字段名
    const CREATED_AT = 'createtime';
    const UPDATED_AT = 'updatetime';

    // 让所有属性都可以批量分配
    protected $guarded = [];

    public function rules()
    {
        return [
            'name' => v::NotEmpty()->setName(trans('fields.name', [], 'config'))->setTemplate(trans('condoradmin.validation.required')),
        ];
    }
}
