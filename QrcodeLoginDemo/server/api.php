<?php 

$_mem = new memcache();
$_mem->connect('127.0.0.1', 11211);


$method = isset($_POST['method']) ? $_POST['method'] : '';

if ($method == 'login'){
	$uid = 'yk_'.uniqid();
	
	$ret = $_mem->add($uid, '',60 * 2);

	if ($ret){
		echo json_encode(array(
				'ret_data'=> array('code'=>$uid),
				'ret_code'=>1024,
				'ret_msg' =>'ok',
			));exit;
	} else {
		echo json_encode(array(
				'ret_code'=> -1,
				'ret_msg' =>'system error',
			));exit;
	}

} else if ($method == 'scan') {
	$code = isset($_POST['code']) ? $_POST['code'] : '';
	$_start = time();

	while (true) {
		$_end = time();

		$data = $_mem->get($code);
		if ($data) {
			echo json_encode(array('ret_code'=> 0));exit;
		}

		if ( ($_end-$_start) > 3 ){
			
			echo json_encode(array('ret_code'=> 408));exit;
		} else {


		}
		usleep(50);
	}

	//sleep(1);

} else if ($method == 'setLogin'){
	$code = isset($_POST['code']) ? $_POST['code'] : '';
	$uid = isset($_POST['uid']) ? $_POST['uid'] : '';
	$ret = $_mem->set($uid, $code);
	if ($ret){
		echo json_encode(array(
				'ret_code'=> 0,
				'ret_msg' =>'ok',
			));exit;
	} else {
		echo json_encode(array(
				'ret_code'=> -1,
				'ret_msg' =>'system error',
			));exit;
	}
} else {

	$code = isset($_GET['code']) ? $_GET['code'] : '';
	$uid = isset($_GET['uid']) ? $_GET['uid'] : '';

	$ret = $_mem->set($code, '1');
	if ($ret){
		echo json_encode(array(
				'ret_code'=> 0,
				'ret_msg' =>'ok',
			));exit;
	} else {
		echo json_encode(array(
				'ret_code'=> -1,
				'ret_msg' =>'system error',
			));exit;
	}
}





echo json_encode($_POST);


?>