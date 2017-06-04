var module = angular.module('indexService', [])

module.service('indexgoodsData', function ($http) {
    let self = this;
    //  获取商品列表
    self.indexList = [];
    self.getGoodsList = function (id) {
        var url = '/api/category';
        return $http({
            method: 'GET',
            url: url,
            params: {
                offset: '0',
                count: '20',
                cateId: id
            },
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            console.log('service')
            return angular.copy(data.data.goodsList, self.indexList);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    };
})