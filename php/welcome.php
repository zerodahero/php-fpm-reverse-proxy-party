<?php

extract([
    'message' => 'Welcome to the reverse proxy party!',
]);

http_response_code(200);

echo $message;
