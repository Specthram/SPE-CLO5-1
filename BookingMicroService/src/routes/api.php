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

	$connection = new Cassandra\Connection(['127.0.0.1'], 'booking');

	try {
		$connection->connect();
	} catch (Cassandra\Exception $e) {
		echo 'Caught exception: ',  $e->getMessage(), "\n";
		exit;
	}

	if($request->getHeader('token')){
		$auth = $connection->querySync("SELECT * FROM users WHERE session_token=? LIMIT 1 ALLOW FILTERING", [(string)$request->getHeader('token')[0]])->fetchAll();
		if (!$auth){
			$response->withStatus(403);
			$response->write(json_encode(["error" => "invalid credentials (token)"]));
			return $response;
		}
	} elseif ($request->getHeader('username') && $request->getHeader('password')){
		$auth = $connection->querySync("SELECT * FROM users WHERE username = ? AND password = ? LIMIT 1 ALLOW FILTERING", [(string)$request->getHeader('username')[0], (string)$request->getHeader('password')[0]])->fetchAll();
		if (!$auth){
			$response->withStatus(403);
			$response->write(json_encode(["error" => "invalid credentials (username / password)"]));
			return $response;
		}
	} else {
		$response->withStatus(403);
		$response->write(json_encode(["error" => "missing credentials"]));
		return $response;
	}

	$queryResponse = $connection->querySync('SELECT * FROM booking WHERE "id" = ?', [(int)$args['id']])->fetchAll()->toArray();

	$response->write(json_encode($queryResponse));

	$connection->disconnect();

	return $response;

});

$app->post('/api/v1/booking/book', function(\Slim\Http\Request $request, \Slim\Http\Response$response, Array $args){

	$connection = new Cassandra\Connection(['127.0.0.1'], 'booking');

	try {
		$connection->connect();
	} catch (Cassandra\Exception $e) {
		echo 'Caught exception: ',  $e->getMessage(), "\n";
		exit;
	}

	if($request->getHeader('token')){
		$auth = $connection->querySync("SELECT * FROM users WHERE session_token=? LIMIT 1 ALLOW FILTERING", [(string)$request->getHeader('token')[0]])->fetchAll();
		if (!$auth){
			$response->withStatus(403);
			$response->write(json_encode(["error" => "invalid credentials (token)"]));
			return $response;
		}
	} elseif ($request->getHeader('username') && $request->getHeader('password')){
		$auth = $connection->querySync("SELECT * FROM users WHERE username = ? AND password = ? LIMIT 1 ALLOW FILTERING", [(string)$request->getHeader('username')[0], (string)$request->getHeader('password')[0]])->fetchAll();
		if (!$auth){
			$response->withStatus(403);
			$response->write(json_encode(["error" => "invalid credentials (username / password)"]));
			return $response;
		}
	} else {
		$response->withStatus(403);
		$response->write(json_encode(["error" => "missing credentials"]));
		return $response;
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
			(string)$auth[0]['id'],
			$startDateC,
			$endDateC
		]
	);

	$response->withStatus(200);
	$response->write("registered.");

	$connection->disconnect();

	return $response;
});