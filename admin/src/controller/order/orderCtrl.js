var module = angular.module('orderCtrl', ['orderService', 'filter'])

//订单列表
module.controller('orderListCtrl', function ($scope, orderData, $stateParams) {
    var currentPage = $stateParams.page;
    var count = 20;
    var offset = (currentPage - 1) * count;
    orderData.getOrderList(offset, count, function (data) {
        $scope.pageCount = Number(data.data.total);
        console.log($scope.pageCount)
    });

    $scope.orderList = orderData.orderList;

    console.log($scope.orderList);

});
module.controller('addOrderCtrl', function ($scope, orderData,$stateParams) {
    console.log('addOrder')

});
module.controller('orderDetailCtrl', function ($scope, orderData,$stateParams) {
    orderData.getOrderDetail($stateParams.id);
    $scope.orderDetail = orderData.orderDetail;

    console.log($scope.orderDetail);
});

//采购单列表
module.controller('purchaseOrderListCtrl', function ($scope, orderData,$stateParams) {
    var currentPage = $stateParams.page;
    var count = 20;
    var offset = (currentPage - 1) * count;
    orderData.getPurchaseOrderList(offset, count, function (data) {
        $scope.pageCount = Number(data.data.total);
        console.log($scope.pageCount)
    });

    $scope.purchaseOrderList = orderData.purchaseOrderList;

    console.log($scope.purchaseOrderList);
});
//添加采购单
module.controller('addPurchaseOrderListCtrl', function ($scope, orderData,$stateParams) {


})

//发货单单列表
module.controller('shipOrderListCtrl', function ($scope, orderData,$stateParams) {
    var currentPage = $stateParams.page;
    var count = 20;
    var offset = (currentPage - 1) * count;
    orderData.getShipOrderList(offset, count, function (data) {
        $scope.pageCount = Number(data.data.total);
        console.log($scope.pageCount)
    });

    $scope.shipOrderList = orderData.shipOrderList;

    console.log($scope.shipOrderList);
});

//退货单列表
module.controller('refundOrderListCtrl', function ($scope, orderData,$stateParams) {
    var currentPage = $stateParams.page;
    var count = 20;
    var offset = (currentPage - 1) * count;
    orderData.getRefundOrderList(offset, count, function (data) {
        $scope.pageCount = Number(data.data.total);
        console.log($scope.pageCount)
    });

    $scope.refundOrderList = orderData.refundOrderList;

    console.log($scope.refundOrderList);
});

//评价列表
module.controller('evaluationListCtrl', function ($scope, orderData,$stateParams) {
    var currentPage = $stateParams.page;
    var count = 20;
    var offset = (currentPage - 1) * count;
    orderData.getEvaluationList(offset, count, function (data) {
        $scope.pageCount = Number(data.data.total);
        console.log($scope.pageCount)
    });

    $scope.evaluationList = orderData.evaluationList;

    console.log($scope.evaluationList);
});

