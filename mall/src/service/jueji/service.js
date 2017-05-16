var module = angular.module('juejiService', [])

module.service('goodsData', function ($http) {
    let self = this;
    //  管理组列表
    self.goodsList = [];
    self.getGoodsList = function () {
        var url = '/api/category';
        return $http({
            method: 'GET',
            url: url,
            params: {
                offset: '0',
                count: '20',
                cateId: '6'
            },
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            return angular.copy(data.data.goodsList, self.goodsList);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    };
})