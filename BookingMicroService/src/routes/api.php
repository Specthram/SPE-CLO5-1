<?php

$app->get('/api/v1/booking', function(\Slim\Http\Request $request, \Slim\Http\Response$response, Array $args){

	$routes = [];
	$routes['list'][] = array("route" => "/booking/book", "method" => "GET", 'description' => 'gives all reserved rooms');
	$routes['list'][] = array("route" => "/booking/book", "method" => "POST", 'description' => 'book a room (json -> ["room": "id_room"]), return 200 if ok or 403 if not');

	$response->withStatus(200);
	$response->write(json_encode($routes));

	return $response;
});

$app->get('/api/v1/booking/book/{id}', function(\Slim\Http\Request $request, \Slim\Http\Response$response, Array $args){

	$connection     = ConnectionService::getConnectionOrExit();
	$authService    = new AuthService();

	$return = $authService->authAction($request, $connection);

	if ($return){
		return $return;
	}

	$queryResponse = $connection->querySync('SELECT * FROM booking WHERE "id" = ?', [(int)$args['id']])->fetchAll()->toArray();

	$response->write(json_encode($queryResponse));

	$connection->disconnect();

	return $response;

});

$app->post('/api/v1/booking/book', function(\Slim\Http\Request $request, \Slim\Http\Response$response, Array $args){

	$response       = new \Slim\Http\Response();
	$authService    = new AuthService();
	$connection     = ConnectionService::getConnectionOrExit();


	$return = $authService->authAction($request, $connection);

	if ($return){
		return $return;
	}

	$jsonBody = json_decode($request->getBody(), true);

	if (!$jsonBody || !$jsonBody['room'] || !$jsonBody['reserved'] || !$jsonBody['start_date'] || !$jsonBody['end_date']){
		$response->withStatus(400);
		$response->write(json_encode(["error" => "bad json"]));
		return $response;
	}

	$startDate  = DateTime::createFromFormat('Y-m-d', (string)$jsonBody['start_date']);
	$endDate  = DateTime::createFromFormat('Y-m-d', (string)$jsonBody['end_date']);

	$startDateC = new \Cassandra\Type\Timestamp($startDate->getTimestamp());
	$endDateC = new \Cassandra\Type\Timestamp($endDate->getTimestamp());

	$queryResponse = $connection->querySync('INSERT INTO booking ("id", "room", "reserved", "user", "start_date", "end_date") VALUES (?, ?, ?, ?, ?, ?);',
		[
			(string)uniqid(),
			(int)$jsonBody['room'],
			(boolean)$jsonBody['reserved'],
			$authService->getId(),
			$startDateC,
			$endDateC
		]
	);

	$response->withStatus(200);
	$response->write("registered.");

	$connection->disconnect();

	return $response;
});