var module = angular.module('productService', [])

module.service('proData', function ($http, $state, SweetAlert) {
    var self = this;
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
    self.goodsTotal = '';
    self.getGoodsList = function (count, offset, cb) {
        var url = '/api/admin/goodsList';
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
            console.log('getGoodslist', data);
            self.goodsTotal = data.data.total;
            cb && cb(data);
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
    // 获取单个产品系列
    self.goodsSeries = [];
    self.getGoodsSeriesById = function (id) {
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

    //产品详情，编辑页
    self.goodsInfo = [];
    self.getGoodsDetail = function (id) {
        var url = '/api/admin/getGoodsDetail';
        return $http({
            method: 'GET',
            params: {
                goodsId: id
            },
            url: url,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            console.log(data)
            return angular.copy(data.data.goodsInfo, self.goodsInfo)
        }).error(function (res) {
            return console.log('ERROR' + res)
        })
    }

    //  添加产品
    self.addProduct = function (formData, cb) {
        console.log('addProduct')
        var url = '/api/admin/operGoods';
        return $http({
            method: 'POST',
            url: url,
            params: formData,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            console.log('addPro result',data)
            if (data.code !== '10000') {
                return cb && cb('error')
            }else{
                SweetAlert.swal({
                    title: '正确',
                    text: '添加成功',
                    type: 'success'
                });
                cb && cb();
            }


        }).error(function (res) {
            SweetAlert.swal({
                title: '错误',
                text: '请填写所有字段',
                type: 'error'
            });
        })
    };

    //添加系列
    self.addGoodsSeries = function (formData) {
        console.log('addGoodsSeries')
        var url = '/api/admin/operGoodsSeries';
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
            $state.go('index.productList', {page: 1});
        }).error(function (res) {
            SweetAlert.swal({
                title: '错误',
                text: '请填写所有字段',
                type: 'error'
            });
        })
    }

    //上传商品图片
    self.uploadZshImg = function (file, cb) {
        var url = '/api/admin/uploadZshImage';
        var data = new FormData();
        console.log(file);
        data.append('imageUrl', file);
        return $http({
            method: "POST",
            url: url,
            data: data,
            headers: {
                "Content-Type": undefined
            }
        }).success(function (data) {
            console.log('filedata', data);
            if (data.code === '10000') {
                cb && cb(data)
            } else {
                cb && cb('error')
            }
        }).error(function (err) {
            cb && cb('error')

        })
    }
    //上传商品图片
    self.uploadGoodsImg = function (file, cb) {
        var url = '/api/admin/uploadGoodsImage';
        var data = new FormData();
        console.log(file);
        data.append('imageUrl', file);
        return $http({
            method: "POST",
            url: url,
            data: data,
            headers: {
                "Content-Type": undefined
            }
        }).success(function (data) {
            console.log('filedata', data);
            if (data.code === '10000') {
                cb && cb(data)
            } else {
                cb && cb('error')
            }

        }).error(function (err) {
            cb && cb('error')

        })
    }
    //上传试穿图片
    self.uploadTryImg = function (file, cb) {
        var url = '/api/admin/uploadGoodsTryThumb';
        var data = new FormData();
        data.append('tryThumb', file)
        return $http({
            method: "POST",
            url: url,
            data: data,
            headers: {
                "Content-Type": undefined
            }
        }).success(function (data) {
            if (data.code === '10000') {
                cb && cb(data)
            } else {
                cb && cb('error')
            }
        }).error(function (err) {
            cb && cb('error')
        })
    }


    //uploadVideo
    self.uploadVideo = function (type, formData) {
        var url = '';
        var data = new FormData();

        if (type === 'goodsVideo') {
            url = '/api/admin/uploadGoodsVideoAdds';
            data.append('videoAdds', formData);
        }
        return $http({
            method: 'POST',
            url: url,
            data: data,
            headers: {
                'Content-Type': undefined
            }
        }).success(function (data) {
            SweetAlert.swal({
                title: '正确',
                text: '添加视频成功',
                type: 'success'
            });
            console.log(type, data)
            // $state.go('index.goodsList');
        }).error(function (res) {
            SweetAlert.swal({
                title: '错误',
                text: '视频上传失败',
                type: 'error'
            });
        })
    };


})