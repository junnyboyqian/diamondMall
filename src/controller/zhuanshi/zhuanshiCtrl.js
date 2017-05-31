var module = angular.module('zhuanshiCtrl', ['zhuanshiService'])

module.controller('zhuanshiListCtrl', function ($scope, $stateParams, goodsData) {

    $scope.showTopNav = function (layerName) {
        document.getElementById(layerName).style.display = 'block'
    }

    $scope.hideTopNav = function (layerName) {
        document.getElementById(layerName).style.display = 'none'
    }
    // 砖石系列
    var id = $stateParams.id
    goodsData.getGoodsList(id)
    $scope.AllList = goodsData.AllList
})