<?php


//文件上传
if(isset($_FILES) && !empty($_FILES)){
	file_put_contents('file.txt', json_encode($_FILES));
	if($_FILES['file']['error']==0){

		move_uploaded_file($_FILES['file']['tmp_name'], './'.$_FILES['file']['name']);
		exit('上传成功!!!');
	}else{
		exit('上传失败!!!');
	}
}


// POST 传值
if(isset($_POST['h'])){
	exit('po');
}

// GET 有参数获取数据
if(isset($_GET['h'])){
	exit(json_encode($_GET));
	//exit('o');
}

// GET 无参数获取数据
exit('world!');

?>

