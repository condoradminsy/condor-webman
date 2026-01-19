<?php

namespace plugin\condoradmin\app\model;

use support\Model;
use Respect\Validation\Validator as v;


class SystemTest extends Model
{
    
    /**
     * @var string
     */
    protected $table = 'system_test';

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
    const UPDATED_AT = null;

    // 让所有属性都可以批量分配
    protected $guarded = [];

    protected function serializeDate(\DateTimeInterface $date)
    {
        return $date->format('Y-m-d H:i:s');
    }

    public function rules()
    {
        return [
            'name' => v::optional(v::notEmpty())->setName('名称'),
            'target' => v::optional(v::notEmpty())->setName('目标'),
            'image' => v::optional(v::notEmpty())->setName('图片'),
            'createtime' => v::optional(v::notEmpty())->setName('创建时间'),
        ];
    }
}
