<?php

class AuthService {

	private $admin  = false;

	private $id     = 0;

	public function authAction (\Slim\Http\Request $request, $connection){

		$response = new \Slim\Http\Response();

		if ($request->getHeader('token')){
			$auth = $connection->querySync("SELECT * FROM users WHERE session_token=? LIMIT 1 ALLOW FILTERING", [(string)$request->getHeader('token')[0]])->fetchAll();
			if (!$auth){
				$response->withStatus(403);
				$response->write(json_encode(["error" => "invalid credentials (token)"]));
				return $response;
			}

			if ((boolean)$auth[0]['admin']){
				$this->admin = true;
			}

			$this->id   = (string)$auth[0]['id'];

		} else if ($request->getHeader('username') && $request->getHeader('password')){
			$auth = $connection->querySync("SELECT * FROM users WHERE username = ? AND password = ? LIMIT 1 ALLOW FILTERING", [(string)$request->getHeader('username')[0], (string)$request->getHeader('password')[0]])->fetchAll();
			if (!$auth){
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

		return null;
	}

	public function getAdmin(){
		return $this->admin;
	}

	public function getId(){
		return $this->id;
	}
}
