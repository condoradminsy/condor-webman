<?php

/**
 * Here is your custom functions.
 */
if (!function_exists('getInviteCode')) {
    /**
     * 获取邀请码
     */
    function getInviteCode($seed = '', $length = 6): string
    {
        $seed = $seed ?: uniqid(mt_rand(), true);
        $hash = strtoupper(substr(md5($seed), 0, $length));
        return preg_replace('/[0O1I]/', rand(2, 9), $hash);
    }
}
