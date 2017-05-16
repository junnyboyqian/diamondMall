var module = angular.module('zhuanshiCtrl', ['zhuanshiService'])

module.controller('zhuanshiListCtrl', function ($scope, goodsData) {
    // 砖石系列
    goodsData.getGoodsList()
    $scope.goodsList = goodsData.goodsList
})