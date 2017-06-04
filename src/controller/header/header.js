var module = angular.module('headerController', ['httpService'])

module.controller('headerCtrl', function($scope, $state, $cookies, httpData, $rootScope) {
    // 是否登录
    $scope.loginOn = false
    if(sessionStorage['userInfo']){
        $scope.userInfo = JSON.parse(sessionStorage['userInfo'])
        $scope.loginOn = true
    }

    // 退出登录
    $scope.logoutData = {
        url: '/api/loginOut',
        data: {
            accessToken: ''
        }
    }
    $scope.logout = function () {
        httpData.GET($scope.logoutData).then(function(resp){
            if(resp.code == 10000){
                $cookies.remove("userInfo");
                sessionStorage.removeItem("userInfo");
                sessionStorage.clear();

                $state.go('login')
            } else {
                alert(resp.msg)
            }
        }, function(err){
            alert(err)
        })
    }
    $scope.addSearch = function () {
        if (!$scope.keywords) return
        $rootScope.$broadcast('skeywords', $scope.keywords);
        setTimeout(function() {
            $state.go("search", )
        }, 0)
    }
})