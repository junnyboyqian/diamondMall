var module = angular.module('productService', [])

module.service('proData', function ($http, $state, SweetAlert) {
    let self = this;
    //  证书货数据
    self.zshList = [];
    self.getZshList = function () {
        var url = '/api/admin/zshList';
        return $http({
            method: 'GET',
            url: url,
            params: {
                offset: '0',
                count: '20'
            },
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            return angular.copy(data.data.zshList, self.zshList);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    };
    //  添加证书
    self.addZshList = function (formData) {
        var url = '/api/admin/operZsh';
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
            $state.go('index.goodsList');
        }).error(function (res) {
            SweetAlert.swal({
                title: '错误',
                text: '请填写所有字段',
                type: 'error'
            });
        })
    };
    // 产品列表
    self.goodsList = [];
    self.getGoodsList = function () {
        var url = '/api/admin/goodsList';
        return $http({
            method: 'GET',
            url: url,
            params: {
                offset: '0',
                count: '20'
            },
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            return angular.copy(data.data.goodsList, self.goodsList);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    };
    // 产品属性
    self.AttributeList = [];
    self.getAttributeList = function () {
        var url = '/api/goodsAttrList';
        return $http({
            method: 'GET',
            url: url,
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            return angular.copy(data.data.goodsAttrList, self.AttributeList);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    }
    // 产品系列
    self.goodsSeriesList = [];
    self.getGoodsSeriesList = function () {
        var url = '/api/admin/goodsSeriesList';
        return $http({
            method: 'GET',
            url: url,
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            return angular.copy(data.data.goodsSeriesList, self.goodsSeriesList);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    };
    // 产品分类
    self.productCatLits = [];
    self.getProductCatLits = function () {
        var url = '/api/goodsCateListV1';
        return $http({
            method: 'GET',
            url: url,
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            return angular.copy(data.data.goodsCateList, self.productCatLits);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    }
    //  添加产品
    self.addProduct = function (formData) {
        var url = '/api/admin/operGoods';
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
            $state.go('index.productList');
        }).error(function (res) {
            SweetAlert.swal({
                title: '错误',
                text: '请填写所有字段',
                type: 'error'
            });
        })
    };
})