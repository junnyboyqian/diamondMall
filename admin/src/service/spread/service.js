var module = angular.module('spreadService', [])

module.service('spreadData', function ($http, $state, SweetAlert) {
    var self = this;
    //  证书货数据
    self.articleCateList = [];
    self.getArticleCateList = function (offset, count) {
        var url = '/api/admin/articleCateList';
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
            return angular.copy(data.data.articleCateList, self.articleCateList);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
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
    self.addProduct = function (formData) {
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


    //uploadImg
    self.goodsImages = [];
    self.tryThumb = '';
    self.uploadImg = function (type, formData, cb) {
        var url = '';
        if (type === 'addProduct') {
            var count = 0;
            var result = 'succ';
            url = '/api/admin/uploadGoodsImage';
            for (var i = 0; i < formData.length; i++) {
                var data = new FormData();
                data.append('imageUrl', formData[i]);
                $http({
                    method: 'POST',
                    url: url,
                    data: data,
                    headers: {
                        'Content-Type': undefined
                    }
                }).success(function (data) {
                    count++;
                    self.goodsImages.push(data.data.fileurl);
                    console.log(count, data);
                    if (count >= formData.length && result === 'succ') {
                        // SweetAlert.swal({
                        //     title: '正确',
                        //     text: '添加图片成功',
                        //     type: 'success'
                        // });
                        cb && cb();
                    }
                }).error(function (res) {
                    count++;
                    result = 'fail';
                    if (count >= formData.length && result === 'fail') {
                        SweetAlert.swal({
                            title: '错误',
                            text: '图片上传失败',
                            type: 'error'
                        });
                    }
                })


            }

        } else if (type === 'uploadGoodsTry') {
            var data = new FormData();
            url = '/api/admin/uploadGoodsTryThumb';
            data.append('tryThumb', formData);
            return $http({
                method: 'POST',
                url: url,
                data: data,
                headers: {
                    'Content-Type': undefined
                }
            }).success(function (data) {
                // SweetAlert.swal({
                //     title: '正确',
                //     text: '添加图片成功',
                //     type: 'success'
                // });
                self.tryThumb = data.data.fileurl;
                console.log(type, data);
                cb && cb();
            }).error(function (res) {
                SweetAlert.swal({
                    title: '错误',
                    text: '图片上传失败',
                    type: 'error'
                });
            })
        }

        // return $http({
        //     method: 'POST',
        //     url: url,
        //     data: data,
        //     headers: {
        //         'Content-Type': undefined
        //     }
        // }).success(function (data) {
        //     SweetAlert.swal({
        //         title: '正确',
        //         text: '添加图片成功',
        //         type: 'success'
        //     });
        //     console.log(type,data)
        //     // $state.go('index.productList');
        // }).error(function (res) {
        //     SweetAlert.swal({
        //         title: '错误',
        //         text: '图片上传失败',
        //         type: 'error'
        //     });
        // })
    };

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