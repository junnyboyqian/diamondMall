var module = angular.module('juejiCtrl', ['juejiService'])

module.controller('juejiListCtrl', function ($scope, goodsData) {
    // 爵迹系列
    goodsData.getGoodsList()
    $scope.goodsList = goodsData.goodsList
})