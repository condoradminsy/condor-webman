<?php

return [
    'common.validation.required' => '{{name}} 不能为空',
    'common.validation.in' => '{{name}} 必须在 {{haystack}} 中',
    'common.validation.length.both' => '{{name}} 长度必须在 {{minValue}} 与 {{maxValue}} 之间',
    'common.validation.length.lower' => '{{name}} 长度必须大于 {{minValue}}',
    'common.validation.length.lower.inclusive' => '{{name}} 长度必须大于或等于 {{minValue}}',
    'common.validation.length.greater' => '{{name}} 长度必须小于 {{maxValue}}',
    'common.validation.length.greater.inclusive' => '{{name}} 长度必须小于或等于 {{maxValue}}',
    'common.validation.length.exact' => '{{name}} 长度必须是 {{maxValue}}',
    'common.validation.email' => '{{name}} 必须是有效的电子邮件',
    'common.validation.mobile' => '{{name}} 必须是有效的手机号码',

    // 认证相关
    'common.please.log.in.first' => '请先登录',
    'common.access.denied' => '访问被拒绝',
    'common.invalid.token' => '无效的令牌',

    // 公共操作响应
    'common.ok' => '操作成功',
    'common.system.error' => '系统错误',
    'common.parameter.can.not.be.empty' => '参数不能为空',
    'common.no.results.were.found' => '未找到相关结果',
    'common.request.method.incorrect' => '请求方式不正确',
    'common.no.rows.were.inserted' => '没有插入任何行',
    'common.no.rows.were.updated' => '没有更新任何行',
    'common.no.rows.were.deleted' => '没有删除任何行',
    'common.you.have.no.permission' => '你没有权限',
    'common.delete.failed' => '删除失败',
    'common.update.failed' => '更新失败',
    'common.restore.failed' => '恢复失败',
    'common.invalid.parameters' => '无效的参数',
    'common.parameter.type.error' => '参数类型错误',
    'common.system.translation_locale_key_empty' => '翻译区域设置不能为空',
    'common.system.translation_foreign_key_empty' => '翻译外键设置不能为空',
];
