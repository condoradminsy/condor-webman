<?php

namespace plugin\condoradmin\app\library;

use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\PHPMailer;
// use PHPMailer\PHPMailer\SMTP;
use plugin\condoradmin\app\service\SystemConfig;
use support\Log;

class Email
{


    /**
     * 发送短信验证码
     * @param $to
     * @param $subject
     * @param $body
     * @return bool
     */
    public static function send($to, $subject, $body)
    {
        $mail = new PHPMailer(true);
        try {
            // SMTP 配置
            $mail->isSMTP();
            // SMTP 服务器地址
            $mail->Host = SystemConfig::config('host', 'email_config');
            // 端口（通常 465 或 587）
            $mail->Port = SystemConfig::config('port', 'email_config');
            $mail->SMTPAuth = true;
            // 邮箱账号
            $mail->Username = SystemConfig::config('username', 'email_config');
            // 邮箱密码/授权码
            $mail->Password = SystemConfig::config('password', 'email_config');
            // 加密方式（如 `ssl` 或 `tls`）
            $mail->SMTPSecure = SystemConfig::config('smtp_secure', 'email_config');
            // 编码
            $mail->CharSet = SystemConfig::config('char_set', 'email_config');
            // $mail->SMTPDebug = SMTP::DEBUG_OFF; // 调试模式，生产环境记得关闭
            // 发件人和收件人
            $mail->setFrom(SystemConfig::config('from', 'email_config'), SystemConfig::config('from_name', 'email_config'));
            // 收件人邮箱
            $mail->addAddress($to);
            // 邮件内容
            $mail->isHTML(true);
            $mail->Subject = $subject;
            $mail->Body = $body;

            $mail->send();

            return true;
        } catch (Exception $e) {
            Log::error("email send fail => ", [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            return false;
        }
    }
}
