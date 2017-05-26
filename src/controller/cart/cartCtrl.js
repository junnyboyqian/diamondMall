var module = angular.module('cartCtrl', ['cartService'])

module.controller('cartFlowCtrl', function ($scope, $stateParams, cartFlowData) {
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
})