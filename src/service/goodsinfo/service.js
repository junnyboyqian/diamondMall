var module = angular.module('goodsinfoService', [])

module.service('goodsitemData', function ($http) {
    let self = this;
    //  管理组列表
    self.goodsInfo = {};
    self.getGoodsInfo = function () {
        var url = '/api/goods';
        return $http({
            method: 'GET',
            url: url,
            params: {
                goodsId: '1'
            },
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            return angular.copy(data.data.goodsInfo, self.goodsInfo);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    };
    //  添加证书
    self.goodsAddCartserviece = function (formData) {
        var url = '/api/addCart';
        return $http({
            method: 'GET',
            url: url,
            params: formData,
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            $state.go('cart-flow');
        }).error(function (res) {
            console.log(res)
        })
    };
})