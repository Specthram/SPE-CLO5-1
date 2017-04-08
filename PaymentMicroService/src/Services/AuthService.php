<?php

class AuthService {

	private $admin      = false;
	private $username   = "";
	private $password   = "";
	private $token      = "";

	private $id     = 0;

	public function authAction (\Slim\Http\Request $request, $connection, \Slim\Collection $settings, \Monolog\Logger $logger){

		$response   = new \Slim\Http\Response();
		$guzzle     = new GuzzleHttp\Client();

		$username   = "";
		$password   = "";
		$token      = "";

		if (isset($request->getHeader('username')[0])){
			$this->username   = (string)$request->getHeader('username')[0];
		}
		if (isset($request->getHeader('password')[0])){
			$this->password   = (string)$request->getHeader('password')[0];
		}
		if (isset($request->getHeader('token')[0])){
			$this->token      = (string)$request->getHeader('token')[0];
		}

		try {
			$gRes       = $guzzle->get('http://' . $settings->get('api_user')['ipAddress'] . ':' . $settings->get('api_user')['port'] . '/api/v1/users/login', ['headers'=>[
				'username'  => $this->username,
				'login'     => $this->username,
				'password'  => $this->password,
				'token'     => $this->token
			]]);
		} catch(Exception $e) {
			error_log('unable to connect user api : ' . $e->getMessage());
			error_log('using local user data');
			$logger->addWarning('unable to connect user api : ' . $e->getMessage());
			$logger->addWarning('using local user data');
		}

		if (isset($gRes) && $gRes && $gRes->getStatusCode() == 200){
			if ($gRes->getStatusCode() == 200){
				$json = json_decode($gRes->getBody());
				if ($json){
					$this->id       = $json->id;
					$this->admin    = $json->isAdmin;
				}
			}
		} else {
			if ($request->getHeader('token')){
				$auth = $connection->querySync("SELECT * FROM users WHERE session_token=? LIMIT 1 ALLOW FILTERING", [(string)$request->getHeader('token')[0]])->fetchAll();
				if (!$auth || !$auth->getSize()){
					$response->withStatus(403);
					$response->write(json_encode(["error" => "invalid credentials (token)"]));
					return $response;
				}

				if (isset($auth[0]['admin']) && $auth[0]['admin'] === true){
					$this->admin = true;
				}

				$this->id   = (string)$auth[0]['id'];

			} else if ($request->getHeader('username') && $request->getHeader('password')){
				$auth = $connection->querySync("SELECT * FROM users WHERE username = ? AND password = ? LIMIT 1 ALLOW FILTERING", [(string)$request->getHeader('username')[0], (string)$request->getHeader('password')[0]])->fetchAll();
				if (!$auth || !$auth->getSize()){
					$response->withStatus(403);
					$response->write(json_encode(["error" => "invalid credentials (username / password)"]));
					return $response;
				}

				if ((boolean)$auth[0]['admin']){
					$this->admin = true;
				}

				$this->id   = (string)$auth[0]['id'];

			} else {
				$response->withStatus(403);
				$response->write(json_encode(["error" => "missing credentials"]));

				return $response;

			}
		}

		return null;
	}

	public function getAdmin(){
		return $this->admin;
	}

	public function getId(){
		return $this->id;
	}

	public function getUsername(){
		return $this->username;
	}

	public function getPassword(){
		return $this->password;
	}

	public function getToken(){
		return $this->token;
	}
}
