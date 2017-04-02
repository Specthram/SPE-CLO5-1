<?php

$app->get('/api/v1/booking', function(\Slim\Http\Request $request, \Slim\Http\Response$response, $args){

	$routes = [];
	$routes['list'][] = array("route" => "/booking/book", "method" => "GET", 'description' => 'gives all reserved rooms');
	$routes['list'][] = array("route" => "/booking/book", "method" => "POST", 'description' => 'book a room (json -> ["room": "id_room"]), return 200 if ok or 403 if not');

	$response->withStatus(200);
	$response->write(json_encode($routes));

	return $response;
});

$app->get('/api/v1/booking/test', function (\Slim\Http\Request $request, \Slim\Http\Response $response, $args){

	$connection = new Cassandra\Connection(['127.0.0.1'], 'booking');

	try {
		$connection->connect();
	} catch (Cassandra\Exception $e) {
		echo 'Caught exception: ',  $e->getMessage(), "\n";
		exit;
	} finally {
		echo 'ok ca marche';
	}


	//	$connection->queryAsync()
});

$app->get('/api/v1/booking/init', function(\Slim\Http\Request $request, \Slim\Http\Response$response, $args){
	// Connecteur PDO_CASSANDRA
	$db = new PDO('cassandra:host=127.0.0.1;port=9160');
	$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	$db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

	// Création de l'espace de travail
	$db->exec("CREATE KEYSPACE mytest with strategy_class = 'SimpleStrategy' and strategy_options:replication_factor=1;");
});

//TODO voir ça
$app->get('/booking/{table}', function ($request, $response, $args) use ($app, $db) {

	$connection = new Cassandra\Connection(['127.0.0.1'], 'booking');

	$params = $request->getQueryParams();

	$select = FluentCQL\Query::select('*')->from($args['table']);

	if (!empty($params)){
		$conditions = [];
		foreach($params as $columnName => $value)
			$conditions[] = $columnName . ' = ?';

		$select->where(implode(' AND ', $conditions));
	}

	$preparedData = $select->prepare();

	$bind = [];
	$index = 0;
	foreach($params as $value){
		$bind[] = Cassandra\Type\Base::getTypeObject($preparedData['metadata']['columns'][$index]['type'], $value);
		++$index;
	}

	$rows = $db->executeSync($preparedData['id'], $bind)->fetchAll();

	$response->json($rows->toArray());

	$connection->disconnect();
});
