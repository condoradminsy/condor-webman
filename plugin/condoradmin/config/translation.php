<?php

return [
    // Default language
    'locale' => 'zh-cn',
    // Fallback language
    'fallback_locale' => ['zh-cn', 'en-us'],
    // Content languages
    'languages' => [["label" => "English", "key" => "en-us"], ["label" => "中文", "key" => "zh-cn"]],
    // Folder where language files are stored
    'path' => [
        base_path() . "/resource/translations",
        base_path() . "/plugin/condoradmin/resource/translations",
    ],
];
