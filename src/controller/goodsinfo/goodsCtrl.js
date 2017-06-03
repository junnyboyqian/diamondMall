var module = angular.module('goodsinfoCtrl', ['goodsinfoService'])

module.controller('goodsitemCtrl', function ($scope, $stateParams, goodsitemData) {
    /*大图查看*/
    $(function() {
        $(".dts_datu_img").jqueryzoom({
            xzoom: 400,
            yzoom: 400,
            offset: 10,
            position: "absolute",
            preload: 1,
            lens: 1
        });
        $("#speclist").jdMarquee({
            deriction: "left",
            width: 360,
            height: 80,
            step: 1,
            speed: 4,
            delay: 10,
            control: true,
            _front: "#specright",
            _back: "#specleft"
        });
        $("#speclist img").bind("click",
        function() {
            var src = $(this).attr("src");
            $("#specn1 img").eq(0).attr({
                src: src.replace("\/n5\/", "\/n1\/"),
                jqimg: src.replace("\/n5\/", "\/n0\/")
            });
            $(this).css({
                "border": "1px solid #f60",
                "padding": "0"
            });
        }).bind("mouseout",
        function() {
            $(this).css({
                "border": "1px solid #ccc",
                "padding": "0"
            });
        });
    })
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