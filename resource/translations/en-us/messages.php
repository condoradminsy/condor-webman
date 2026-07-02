<?php

return [
    'common.validation.required' => '{{name}} is required',
    'common.validation.in' => '{{name}} must be in {{haystack}}',
    'common.validation.length.both' => '{{name}} must have a length between {{minValue}} and {{maxValue}}',
    'common.validation.length.lower' => '{{name}} must have a length greater than {{minValue}}',
    'common.validation.length.lower.inclusive' => '{{name}} must have a length greater than or equal to {{minValue}}',
    'common.validation.length.greater' => '{{name}} must have a length less than {{maxValue}}',
    'common.validation.length.greater.inclusive' => '{{name}} must have a length less than or equal to {{maxValue}}',
    'common.validation.length.exact' => '{{name}} must have a length of {{maxValue}}',
    'common.validation.email' => '{{name}} must be a valid email',
    'common.validation.mobile' => '{{name}} must be a valid mobile',

    // 登录与授权
    'common.please.log.in.first' => 'Please log in first',
    'common.access.denied' => 'Access denied',
    'common.invalid.token' => 'Invalid token',

    // Common operation responses
    'common.ok' => 'Success',
    'common.system.error' => 'System error',
    'common.parameter.can.not.be.empty' => 'Parameter cannot be empty',
    'common.no.results.were.found' => 'No results found',
    'common.request.method.incorrect' => 'Invalid request method',
    'common.no.rows.were.inserted' => 'No rows were inserted',
    'common.no.rows.were.updated' => 'No rows were updated',
    'common.no.rows.were.deleted' => 'No rows were deleted',
    'common.you.have.no.permission' => 'You have no permission',
    'common.delete.failed' => 'Delete failed',
    'common.update.failed' => 'Update failed',
    'common.restore.failed' => 'Restore failed',
    'common.invalid.parameters' => 'Invalid parameters',
    'common.parameter.type.error' => 'Parameter type error',
    'common.system.translation_locale_key_empty' => 'Translation locale key cannot be empty',
    'common.system.translation_foreign_key_empty' => 'Translation foreign key cannot be empty',
];
