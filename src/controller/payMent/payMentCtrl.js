var module = angular.module('payCtrl', ['httpService',])

module.controller('paymentCtrl', function($scope, $state, httpData) {
	$scope.orderId = $state.params.orderId

	// 查询订单
	$scope.payInfo = {}
	$scope.payInfoData = {
		url: '/api/payment',
		data: {
			accessToken: '',
			orderId: $scope.orderId
		}
	}
    // 去支付参数
    $scope.payData = {
    	url: '',
		data: {
			accessToken: '',
			orderId: $scope.orderId,
			paymentId: ''
		}
    }
    httpData.GET($scope.payInfoData).then(function (resp) {
		if(resp.code == 10000){
		    $scope.payInfo = resp.data.orderInfo
		    $scope.payData.url = $scope.payInfo.onlinePays[0].paymentLink
		    $scope.$apply()
		} else {
		    alert(resp.msg)
		}
		}, function (err){
	})
	
    $scope.pay = function () {
 		$scope.payData.data.paymentId = $scope.payInfo.paymentId
	    httpData.GET($scope.payData).then(function (resp) {
			if(resp.code == 10000){
				// window.location.href = 'http://hzmozhi.com:85/index.html#/goAlipay.php?orderId=' + $scope.orderId
			} else {
			    alert(resp.msg)
			}
			}, function (err){
		})
    }

})