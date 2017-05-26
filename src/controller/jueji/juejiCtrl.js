var module = angular.module('juejiCtrl', ['juejiService'])

module.controller('juejiListCtrl', function ($scope, $stateParams, goodsData) {

    $scope.showTopNav = function (layerName) {
        document.getElementById(layerName).style.display = 'block'
    }

    $scope.hideTopNav = function (layerName) {
        document.getElementById(layerName).style.display = 'none'
    }
    // 爵迹系列
    var id = $stateParams.id
    goodsData.getGoodsList(id)
    $scope.AllList = goodsData.AllList
})