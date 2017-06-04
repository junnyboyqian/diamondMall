var module = angular.module('searchCtrl', [])

module.controller('searchListCtrl', function ($scope, $stateParams, $rootScope, httpData) {

    $scope.showTopNav = function (layerName) {
        document.getElementById(layerName).style.display = 'block'
    }

    $scope.hideTopNav = function (layerName) {
        document.getElementById(layerName).style.display = 'none'
    }
    // 砖石系列
    $scope.skeywords = ''
    $rootScope.$on('skeywords', function(event, data){
        $scope.skeywords = data
        $scope.searchListFunc()
    })

    $scope.searchListFunc = function () {

        $scope.userInfoData = {
            url: '/api/search',
            data: {
                keywords: $scope.skeywords,
                accessToken:'',
                offset: '0',
                count: '20'
            }
        }

        httpData.GET($scope.userInfoData).then(
            function(resp){
                if(resp.code == 10000){
                    $scope.goodsList = resp.data.goodsList
                    $scope.$apply()
                } else {
                    alert(resp.msg)
                }
            },function(err){
                alert(resp.msg)
        })
    }
})