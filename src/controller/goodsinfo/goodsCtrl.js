var module = angular.module('goodsinfoCtrl', ['goodsinfoService'])

module.controller('goodsitemCtrl', function ($scope, $stateParams, goodsitemData) {
    $scope.setTab = function (m, n) {
        var tli = document.getElementById("menu" + m).getElementsByTagName("li");
        var mli = document.getElementById("main" + m).getElementsByTagName("ol");
        for (i = 0; i < tli.length; i++) {
            tli[i].className = i == n ? "hover": "";
            mli[i].style.display = i == n ? "block": "none";
        }
    }
    var id = $stateParams.id
    goodsitemData.getGoodsInfo(id)
    $scope.goodsInfo = goodsitemData.goodsInfo
    $scope.goodsAddCart = function () {
        $scope.formData.specId = $scope.goodsInfo.defaultSpec
        $scope.formData.isLz = 0
        $scope.formData.quantity = 1
        $scope.formData.accessToken = ''
        if(sessionStorage["userInfo"]){
            $scope.formData.accessToken = JSON.parse(sessionStorage["userInfo"]).accessToken
        }
        if ($scope.formData.ringSize === '0') {
            alert("请选择手指尺寸")
            return
        }
        var params = $scope.formData
        goodsitemData.goodsAddCartserviece(params)
    }
})