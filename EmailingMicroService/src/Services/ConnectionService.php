<?php
/**
 * Created by PhpStorm.
 * User: anthony
 * Date: 04/04/17
 * Time: 22:27
 */

class ConnectionService {

	public static function getConnectionOrExit(){
		$connection = new Cassandra\Connection(['127.0.0.1'], 'booking');

		try {
			$connection->connect();
		} catch (Cassandra\Exception $e) {
			echo 'Caught exception: ',  $e->getMessage(), "\n";
			exit;
		}

		return $connection;
	}
}