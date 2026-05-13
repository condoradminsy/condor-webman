<?php

namespace plugin\condorauth\app\model;

use support\Model;

class SystemThirdUser extends Model
{
    /**
     * @var string
     */
    protected $table = 'system_third_user';

    /**
     * @var string
     */
    protected $primaryKey = 'id';

    /**
     * 指示是否自动维护时间戳
     */
    public $timestamps = false;

    /**
     * 批量赋值白名单
     */
    protected $guarded = [];

    /**
     * 关联 system_user
     */
    public function user()
    {
        return $this->belongsTo(SystemUser::class, 'user_id', 'id');
    }
}
