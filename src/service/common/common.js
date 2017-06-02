var module = angular.module('commonService', [])
//  通用 service
module.service('commonData', function ($http) {
  let self = this
  self.regions = []
  self.getRegions = function(){
    $http({
      method: "GET",
      url: '/api/getRegions'
      // params: data.data
    }).success(function(resp) {
        if (resp.code == 10000){
            self.regions = resp.data.regions
        } else {
            alert(resp.msg)
        }
    }).error(function(resp) {
      alert(resp);
    });
  }
})