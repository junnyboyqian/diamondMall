var module = angular.module('goodsinfoService', [])

module.service('goodsitemData', function ($http, $state) {
    let self = this;
    //  获取信息
    self.goodsInfo = {};
    self.specId = null;
    self.getGoodsInfo = function (id) {
        var url = '/api/goods';
        return $http({
            method: 'GET',
            url: url,
            params: {
                goodsId: id
            },
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            angular.copy(data.data.goodsInfo.defaultSpec, self.specId);
            return angular.copy(data.data.goodsInfo, self.goodsInfo);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    };
    // 下单
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
            if (data.code === '10000') {
                $state.go('cart-flow');
            } else if (data.code === '-3') {
                alert('库存不足,请挑选其他商品');
            } else {
                alert('请完善信息');
            }
        }).error(function (res) {
            console.log(res)
        })
    };
})