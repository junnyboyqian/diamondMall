var module = angular.module('cartCtrl', ['cartService', 'httpService'])
// 购物车
module.controller('cartFlowCtrl', function ($scope, $state, cartFlowData, httpData) {
    $scope.delCart = function (id) {
        // $scope.formData.specId = $stateParams.id
        // $scope.formData.isLz = false
        // $scope.formData.quantity = 1
        // var params = $scope.formData
        // goodsitemData.goodsAddCartserviece(params)
        if (confirm('您确实要把该商品移出购物车吗？')){
            cartFlowData.delCartserviece(id)
        }
    }
    $scope.dropCart = function () {
        // $scope.formData.specId = $stateParams.id
        // $scope.formData.isLz = false
        // $scope.formData.quantity = 1
        // var params = $scope.formData
        // goodsitemData.goodsAddCartserviece(params)
        if (confirm('您确实要把该商品移出购物车吗？')){
            cartFlowData.dropCartserviece()
        }
    }
    cartFlowData.getCartList()
    $scope.cartList = cartFlowData.cartList

    // 跳转结算页面
    $scope.goOrderInfo = function () {
        
        if(!sessionStorage["userInfo"]){
            $state.go('login')
        } else {
            $state.go('cart-flow2')
        }
    }
});
module.controller('orderFlowCtrl', function ($scope, $state, httpData) {
    //获取结算信息
    $scope.checkInfo = {}
    $scope.checkData = {
        url: '/api/checkOut',
        data: {
            accessToken: '',
            goods: 'cart'
        }
    }
    httpData.GET($scope.checkData)
    .then(function (resp) {
        if(resp.code == 51000){
            alert('暂无收获地址')
            // 跳转收获地址页面
        } else if (resp.code == -1) {
            alert(resp.msg)
            $state.go('goods')
        } else if(resp.code == 10000){
            $scope.checkInfo = resp.data
            $scope.$apply()
        }
    }, function (err){
    })

    //提交订单
    $scope.orderData = {
        url: '/api/createOrder',
        data: {
            accessToken: '',
            goods: 'cart'
        }
    }
    $scope.submit = function () {
        $scope.orderData.data.addrId = $scope.checkInfo.addressList.addrId
        // 支付方式 暂时默认为在线支付
        $scope.orderData.data.paymentId = 1

        httpData.POST($scope.orderData).then(function (resp) {
            if(resp.code == 10000){
                $state.go('payMent',{
                    orderId: resp.data.orderId
                })
            } else {
                alert(resp.msg)
            }
        }, function (err){
        })
    }
})


