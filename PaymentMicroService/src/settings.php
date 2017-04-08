<?php
return [
    'settings' => [
        'displayErrorDetails' => true, // set to false in production
        'addContentLengthHeader' => false, // Allow the web server to send the content-length header

        // Renderer settings
        'renderer' => [
            'template_path' => __DIR__ . '/../templates/',
        ],

        // Monolog settings
        'logger' => [
            'name' => 'slim-app',
            'path' => __DIR__ . '/../logs/app.log',
            'level' => \Monolog\Logger::DEBUG,
        ],
	    'api_user' => [
		    'ipAddress'	=> '172.16.230.18',
		    'port'      => '8083'
	    ],
	    'api_booking' => [
		    'ipAddress'	=> '127.0.0.1',
		    'port'      => '8085'
	    ],
    ],
];
