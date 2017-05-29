var module = angular.module('loginService', [])

module.service('LoginData', function ($http) {
    let self = this
    self.GET = function(data){
        return new Promise(function(resolve, reject) {
            $http({
              method: "GET",
              url: data.url,
              params: data.data
            }).success(function(resp) {
              resolve(resp);
            }).error(function(resp) {
              reject(resp);
            });
        });
    }
    self.POST = function(data) {
      return new Promise(function(resolve, reject) {
        $http({
          method: "POST",
          url: data.url,
          data: data.data
        }).success(function(resp) {
          resolve(resp);
        }).error(function(resp) {
          reject(resp);
        });
      });
    }
})