var module = angular.module('cartService', [])

module.service('cartFlowData', function ($http) {
    let self = this;
    //  管理组列表
    self.cartList = {};
    self.getCartList = function () {
        var url = '/api/cartList';
        return $http({
            method: 'GET',
            url: url,
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            return angular.copy(data.data.cartList, self.cartList);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    };
    //  删除商品
    self.delCartserviece = function (id) {
        var url = '/api/delCart';
        return $http({
            method: 'GET',
            url: url,
            params: {
                recId: id
            },
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            // $state.go('index.goodsList');
        }).error(function (res) {
            console.log(res)
        })
    };
    //  清空商品
    self.dropCartserviece = function (formData) {
        var url = '/api/dropCart';
        return $http({
            method: 'GET',
            url: url,
            params: formData,
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            // $state.go('index.goodsList');
        }).error(function (res) {
            console.log(res)
        })
    };
})