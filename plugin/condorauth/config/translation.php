<?php

return [
    // Default language
    'locale' => 'zh-cn',
    // Fallback language
    'fallback_locale' => ['zh-cn', 'en-us'],
    // Folder where language files are stored
    'path' => [
        base_path() . "/resource/translations",
        base_path() . "/plugin/condorauth/resource/translations",
    ],
];
