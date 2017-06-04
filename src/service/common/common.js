var module = angular.module('commonService', [])
//  通用 service
module.service('commonData', function ($http) {
  let self = this
  self.provinceList = []
  self.cityList = []
  self.areaList = []
  self.getRegions = function(type, id){
    var params = {}
    if (!id) {
      params.rid = '1'
    } else {
      params.rid = id
    }
    if ('getProvince' == type) {
      $http({
        method: "GET",
        url: '/api/getRegions',
        params: params
      }).success(function(resp) {
          if (resp.code == 10000){
              return angular.copy(resp.data.regions, self.provinceList);
          } else {
              alert(resp.msg)
          }
      }).error(function(resp) {
        alert(resp);
      });
    } else if ('getCity' == type) {
      $http({
        method: "GET",
        url: '/api/getRegions',
        params: params
      }).success(function(resp) {
          if (resp.code == 10000){
              return angular.copy(resp.data.regions, self.cityList);
          } else {
              alert(resp.msg)
          }
      }).error(function(resp) {
        alert(resp);
      });
    } else if ('getArea' == type) {
      console.log('getArea')
      $http({
        method: "GET",
        url: '/api/getRegions',
        params: params
      }).success(function(resp) {
          if (resp.code == 10000){
              return angular.copy(resp.data.regions, self.areaList);
          } else {
              alert(resp.msg)
          }
      }).error(function(resp) {
        alert(resp);
      });
    }
  }

  self.addAddress = function (params) {
      $http({
        method: "GET",
        url: '/api/getRegions',
        params: params
      }).success(function(resp) {
          if (resp.code == 10000){
              return angular.copy(resp.data.regions, self.areaList);
          } else {
              alert(resp.msg)
          }
      }).error(function(resp) {
        alert(resp);
      });
  }
})