<?php
return [
    'condor-sse' => [
        'listen' => env('CONDOR_SSE_LISTEN', 'http://0.0.0.0:5567'),
        'handler' => plugin\condoradmin\process\EventSource::class,
    ],
    'condor-crontab' => [
        'handler' => plugin\condoradmin\process\CondorCrontab::class,
    ]
];