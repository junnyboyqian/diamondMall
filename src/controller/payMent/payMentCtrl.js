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
    httpData.GET($scope.payInfoData).then(function (resp) {
		if(resp.code == 10000){
		    $scope.payInfo = resp.data.orderInfo
		    $scope.$apply()
		} else {
		    alert(resp.msg)
		}
		}, function (err){
	})
    // 去支付
    $scope.payData = {
    	url: '/api/updatePayMethod',
		data: {
			accessToken: '',
			orderId: $scope.orderId,
			paymentId: ''
		}
    }
    $scope.pay = function () {
 		$scope.payData.data.paymentId = $scope.payInfo.paymentId
	    httpData.GET($scope.payData).then(function (resp) {
			if(resp.code == 10000){
				window.location.href = $scope.payInfo.onlinePays[0].paymentLink + '?orderId=' + $scope.orderId
			} else {
			    alert(resp.msg)
			}
			}, function (err){
		})
    }

})