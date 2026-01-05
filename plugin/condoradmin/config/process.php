<?php
return [
    'condor-sse' => [
        'listen' => 'http://0.0.0.0:5567',
        'handler' => plugin\condoradmin\process\EventSource::class,
    ],
    'condor-crontab' => [
        'handler' => plugin\condoradmin\process\CondorCrontab::class,
    ]
];