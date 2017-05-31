var module = angular.module('headerController', ['httpService'])

module.controller('headerCtrl', function($scope, $state, $cookies, httpData) {
    // 是否登录
    $scope.loginOn = false
    if(sessionStorage['userInfo']){
        $scope.userInfo = JSON.parse(sessionStorage['userInfo'])
        $scope.loginOn = true
    }
})