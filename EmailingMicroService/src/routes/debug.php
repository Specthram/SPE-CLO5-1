<?php

$app->get('/api/v1/debug/test', function (\Slim\Http\Request $request, \Slim\Http\Response $response, $args){

	$connection = new Cassandra\Connection(['127.0.0.1'], 'booking');

	try {
		$connection->connect();
	} catch (Cassandra\Exception $e) {
		echo 'Caught exception: ',  $e->getMessage(), "\n";
		exit;
	} finally {
		echo 'Connection succeed to 127.0.0.1 in booking keyspace';
		$connection->disconnect();
	}
});

$app->get('/api/v1/debug/users', function (\Slim\Http\Request $request, \Slim\Http\Response $response, $args) use ($app) {

	$connection = new Cassandra\Connection(['127.0.0.1'], 'booking');

	$queryResponse = $connection->querySync('SELECT * FROM users;')->fetchAll()->toArray();

	$response->write(json_encode($queryResponse));

	$connection->disconnect();

	return $response;
});

$app->get('/api/v1/debug/book', function (\Slim\Http\Request $request, \Slim\Http\Response $response, $args) use ($app) {

	$connection = new Cassandra\Connection(['127.0.0.1'], 'booking');

	$queryResponse = $connection->querySync('SELECT * FROM booking;')->fetchAll()->toArray();

	$response->write(json_encode($queryResponse));

	$connection->disconnect();

	return $response;
});