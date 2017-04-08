<?php

$app->post('/api/v1/email/mail', function(\Slim\Http\Request $request, \Slim\Http\Response $response, Array $args){

	$connection     = ConnectionService::getConnectionOrExit();
	$authService    = new AuthService();
	/** @var \Monolog\Logger $logger */
	$logger         = $this->get('logger');

	$return = $authService->authAction($request, $connection, $this->get('settings'), $logger);

	if ($return || !$authService->getAdmin()){
		return $return;
	}

	$json   = json_decode($request->getBody());

	if (!$json || !isset($json->to->address) || !isset($json->to->name) || !isset($json->subject) || !isset($json->body)){
		var_dump($json);
		$response->withStatus(400);
		$response->write(json_encode(['bad json']));
		return $response;
	}

	$mail = new PHPMailer(true);

	$mail->setFrom($json->smtpUser);
	$mail->addAddress($json->to->address, $json->to->name);

	$mail->isHTML(false);

	$mail->isSMTP();
	$mail->SMTPAuth = true;
	$mail->Host     = "smtp.gmail.com";
	$mail->Username = $json->smtpUser;
	$mail->Password = $json->smtpPassword;
	$mail->Port     = 587;
	$mail->SMTPSecure = 'tls';

	$mail->Subject = $json->subject;
	$mail->Body    = $json->body;

//	$mail   = new SimpleMail();
//	$mail
//		->setFrom('admin@emailinghoteltest.com', 'Anthony O.')
//		->setTo($json->to->address, $json->to->name)
//		->setMessage($json->body)
//		->setSubject($json->subject);

	if(!$mail->send()) {
		$response->write(json_encode(['Message could not be sent.' => 'Mailer Error: ' . $mail->ErrorInfo]));
		$response->withStatus(500);
	} else {
		$response->write(json_encode('Message has been sent'));
	}

	$connection->disconnect();

	return $response;

});
