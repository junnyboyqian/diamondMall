angular.module('httpService',[])

.factory('http',['$http','SweetAlert',function ($http, SweetAlert) {
    return {
        getData : function (url , cb , params) {
            return $http({
                url:url,
                method:'GET',
                params:params,

            }).success(function (data) {
                cb && cb();
            })
        }
    }
}])