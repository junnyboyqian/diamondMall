var module = angular.module('orderService', [])

module.service('orderData', function ($http, $state, SweetAlert) {
    var self = this;
    self.getData = function (url, params, cb) {
        return $http({
            method: 'GET',
            url: url,
            params: params,
            header: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            if (data.code === '10000') {
                cb && cb(data)
            } else {
                SweetAlert.swal({
                    title: '错误',
                    text: '数据获取失败',
                    type: 'error'
                })
                return;
            }
        }).error(function (data) {
            console.log(data.msg);
            SweetAlert.swal({
                title: '错误',
                text: '数据获取失败',
                type: 'error'
            })
            return;
        })
    }
    //  订单数据
    self.orderList = [];
    self.getOrderList = function (offset, count, cb) {
        var url = '/api/admin/orderList';
        var params = {
            offset: offset,
            count: count
        };
        self.getData(url, params, function (data) {
            console.log(data)
            cb(data)
            return angular.copy(data.data.orderList, self.orderList)
        });
    };
    //  订单详情
    self.orderDetail = [];
    self.getOrderDetail = function (id, cb) {
        var url = '/api/admin/orderDetail';
        var params = {
            orderId: id
        };
        self.getData(url, params, function (data) {
            console.log(data)
            cb && cb(data);
            return angular.copy(data.data.orderInfo, self.orderDetail)
        });
    };
    //  采购单列表

    self.purchaseOrderList = [];
    self.getPurchaseOrderList = function (offset, count, cb) {
        var url = '/api/admin/purchaseOrderList';
        var params = {
            offset: offset,
            count: count
        };
        self.getData(url, params, function (data) {
            console.log(data)
            cb(data)
            return angular.copy(data.data.purchaseOrderList, self.purchaseOrderList)
        });
    };


    //  发货单列表
    self.shipOrderList = [];
    self.getShipOrderList = function (offset, count, cb) {
        var url = '/api/admin/shipOrderList';
        var params = {
            offset: offset,
            count: count
        };
        self.getData(url, params, function (data) {
            console.log(data)
            cb(data)
            return angular.copy(data.data.shipOrderList, self.shipOrderList)
        });
    };

    //  退货单列表
    self.refundOrderList = [];
    self.getRefundOrderList = function (offset, count, cb) {
        var url = '/api/admin/refundOrderList';
        var params = {
            offset: offset,
            count: count
        };
        self.getData(url, params, function (data) {
            console.log(data)
            cb(data)
            return angular.copy(data.data.refundOrderList, self.refundOrderList)
        });
    };

    //  评价列表
    self.evaluationList = [];
    self.getEvaluationList = function (offset, count, cb) {
        var url = '/api/admin/evaluationList';
        var params = {
            offset: offset,
            count: count
        };
        self.getData(url, params, function (data) {
            console.log(data)
            cb(data)
            return angular.copy(data.data.evaluationList, self.evaluationList)
        });
    };

    //add Article
    self.addArticleCate = function (formData) {
        var url = 'api/admin/operArticleCate';
        return $http({
            method: 'POST',
            url: url,
            params: formData,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            SweetAlert.swal({
                title: '正确',
                text: '添加成功',
                type: 'success'
            });
            $state.go('index.articleCateList');
        }).error(function (res) {
            SweetAlert.swal({
                title: '错误',
                text: '请填写所有字段',
                type: 'error'
            });
        })
    }
    //获取文章列表
    self.articleList = [];
    self.getArticleList = function (offset, count) {
        var url = '/api/admin/articleList';
        return $http({
            method: 'GET',
            url: url,
            params: {
                offset: offset,
                count: count
            },
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            if (data.code !== '10000')
                return console.log('ERROR');
            return angular.copy(data.data.articleList, self.articleList);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    }

    //old

})