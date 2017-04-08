<?php

$app->get('/api/v1/payment/pay/{id}', function(\Slim\Http\Request $request, \Slim\Http\Response$response, Array $args){

	$connection     = ConnectionService::getConnectionOrExit();
	$authService    = new AuthService();
	/** @var \Monolog\Logger $logger */
	$logger         = $this->get('logger');

	$return = $authService->authAction($request, $connection, $this->get('settings'), $logger);

	if ($return){
		return $return;
	}

	$queryResponse = $connection->querySync('SELECT * FROM payment WHERE "id" = ?', [(string)$args['id']])->fetchAll()->toArray();

	$response->write(json_encode($queryResponse));

	$connection->disconnect();

	return $response;

});

$app->post('/api/v1/payment/pay', function(\Slim\Http\Request $request, \Slim\Http\Response $response, Array $args){

	$response       = new \Slim\Http\Response();
	$authService    = new AuthService();
	$connection     = ConnectionService::getConnectionOrExit();
	$guzzle         = new GuzzleHttp\Client();
	/** @var \Monolog\Logger $logger */
	$logger         = $this->get('logger');
	$settings       = $this->get('settings');

	$return = $authService->authAction($request, $connection, $settings, $logger);

	if ($return){
		return $return;
	}

	$jsonBody = json_decode($request->getBody(), true);

	if (!$jsonBody || !$jsonBody['mod'] || !$jsonBody['booking'] || !$jsonBody['transaction']){
		$response->withStatus(400);
		$response->write(json_encode(["error" => "bad json"]));
		return $response;
	}

	$date       = new \DateTime('now');
	$timestamp  = new \Cassandra\Type\Timestamp($date->getTimestamp());

	error_log('making cassandra query : INSERT INTO payment ("id", "room", "reserved", "user", "start_date", "end_date", "paid") VALUES ...');
	$logger->addDebug('making cassandra query : INSERT INTO payment ("id", "room", "reserved", "user", "start_date", "end_date", "paid") VALUES ...');


	$queryResponse = $connection->querySync('INSERT INTO payment ("id", "booking", "mod", "transaction", "date", "user") VALUES (?, ?, ?, ?, ?, ?);',
		[
			(string)uniqid(),
			(string)$jsonBody['booking'],
			(string)$jsonBody['mod'],
			(string)$jsonBody['transaction'],
			$timestamp,
			(string)$authService->getId()
		]
	);

	try{
		$gRes = $guzzle->patch('http://' . $settings->get('api_booking')['ipAddress'] . ':' . $settings->get('api_booking')['port'] . '/api/v1/booking/book/' . $jsonBody['booking'],
			[
				'headers' => [
					'token' => $authService->getToken()
				],
				GuzzleHttp\RequestOptions::JSON => [
					['op' => 'replace', 'key' => 'paid', 'value' => 'false']
				]]);
		if ($gRes->getStatusCode() != 200){
			throw new Exception('booking api failed.');
		}
		error_log('booking api replied : status(' .$gRes->getStatusCode(). '), ' . $gRes->getBody()->getContents());
		$logger->addCritical('booking api replied : status(' .$gRes->getStatusCode(). '), ' . $gRes->getBody()->getContents());
	} catch (Exception $e) {
		error_log('unable to connect booking api : ' . $e->getMessage());
		$logger->addCritical('unable to connect booking api : ' . $e->getMessage());
		$response->withStatus(500);
		$response->write(json_encode(['internal error' => 'booking api; please contact admin.']));
		return $response;
	}

	$response->withStatus(200);
	$response->write(json_encode(['success' => 'booking paid.']));

	$connection->disconnect();

	return $response;
});