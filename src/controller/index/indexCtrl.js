var module = angular.module('indexCtrl', ['indexService'])

module.controller('indexListCtrl', function ($scope, goodsData) {
    angular.element(document).ready(function () {
        $('.flicker-example').flickersss();
    });

    $(".in1606_ad").mouseenter(function() {
        var $this = $(this);
        var $div = $this.find(".in1606_adpicl img");
        $div.eq(1).stop();
        $div.eq(1).css({
            "top": "0px",
            "left": "0px",
            "width": "845px",
            "height": "465px"
        });
        $div.eq(0).stop().animate({
            "top": "-25px",
            "left": "-25px",
            "width": "900px",
            "height": "495px"
        }, 1000);
    }).mouseleave(function() {
        var $this = $(this);
        var $div = $this.find(".in1606_adpicl img");
        $div.eq(0).stop().animate({
            "top": "0",
            "left": "0",
            "width": "845px",
            "height": "465px"
        }, 1000);
    });

    $(document).ready(function() {
        $("#count1").dayuwscroll({
            parent_ele: '#wrapBox1',
            list_btn: '#tabT04',
            pre_btn: '#left1',
            next_btn: '#right1',
            path: 'left',
            auto: true,
            time: 3000,
            num: 4,
            gd_num: 4,
            waite_time: 1000
        });
    });
    // 爵迹系列
    goodsData.getGoodsList()
    $scope.goodsList = goodsData.goodsList
})