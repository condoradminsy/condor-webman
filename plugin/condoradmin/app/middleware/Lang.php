<?php

namespace plugin\condoradmin\app\middleware;

use Webman\MiddlewareInterface;
use Webman\Http\Response;
use Webman\Http\Request;

class Lang implements MiddlewareInterface
{
    public function process(Request $request, callable $handler): Response
    {
        $lang = $request->header('locale') ?: $request->header('accept-language') ?: $request->cookie('locale');
        // - 替换 _ ，大写转小写
        $lang = str_replace('-', '_', strtolower($lang));
        $fallback_locale = config('plugin.condoradmin.translation.fallback_locale');
        if (in_array($lang, $fallback_locale)) {
            locale($lang);
        }
        return $handler($request);
    }
}
