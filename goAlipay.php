<?php

$orderId = $_GET['orderId'] ? $_GET['orderId'] : '';
if (!$orderId) {
	exit('订单不存在');
}

?>