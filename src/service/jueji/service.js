var module = angular.module('juejiService', [])

module.service('goodsData', function ($http) {
    let self = this;
    //  列表
    self.AllList = [];
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
            return angular.copy(data.data, self.AllList);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    };
})