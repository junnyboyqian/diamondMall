var module = angular.module('productCtrl', ['productService', 'filter'])

module.controller('goodsListCtrl', function ($scope, proData) {
    //  证书货数据
    proData.getZshList()
    $scope.zshList = proData.zshList;
    console.log('goodslist', $scope.zshList)
})

module.controller('addGoodsCtrl', function ($scope, proData, SweetAlert) {
    //  添加证书
    $scope.formData = {};
    $scope.formData.type = '1';
    $scope.error = {
        name: '',
        certificate_number: '',
        address: '',
        jd: '',
        dia_global_price: '',
        stock: ''
    };
    $scope.checkInputError = function (code) {
        // console.log($scope.formData.image_url)
    };
    $scope.processForm = function () {
        var file = document.getElementById('id-input-file-3').files[0];
        var file1 = document.getElementById('id-input-file-4').files[0];
        if (!file) {
            SweetAlert.swal({
                title: '错误',
                text: '请上传图片',
                type: 'error'
            });
            return
        }
        if (!file1) {
            SweetAlert.swal({
                title: '错误',
                text: '请上传视频',
                type: 'error'
            });
            return
        }
        $scope.formData.image_url = file.name
        $scope.formData.video_url = file1.name
        var params = $scope.formData
        proData.addZshList(params)
    };
})

module.controller('proListCtrl', function ($scope, proData) {
    $scope.person = proData.person()
})
module.controller('productList', function ($scope, proData) {
    $scope.productList = proData.person()
})

module.controller('productAttributeListCtrl', function ($scope, proData) {
    // 产品属性
    proData.getAttributeList()
    $scope.AttributeList = proData.AttributeList
})

module.controller('goodsSeriesListCtrl', function ($scope, proData) {
    // 产品系列
    proData.getGoodsSeriesList()
    $scope.goodsSeriesList = proData.goodsSeriesList
    console.log('goodsSeriesList', proData.goodsSeriesList)
})

module.controller('productCatLitsCtrl', function ($scope, proData) {
    // 产品分类
    proData.getProductCatLits()
    $scope.productCatLits = proData.productCatLits
})
module.controller('productListCtrl', function ($scope, proData, $stateParams, $rootScope) {
    // 产品分类
    var pageCount = 20;
    $scope.currentPage = $stateParams.page;
    console.log('currPage', $scope.currentPage);
    var offset = ($scope.currentPage - 1) * pageCount;
    proData.getGoodsList(pageCount, offset, function () {
        $scope.pageCount = Math.ceil(proData.goodsTotal / pageCount);
        $rootScope.goodsPageList = new Array($scope.pageCount);
    });
    $scope.goodsList = proData.goodsList;
})

module.controller('productInfoCtrl', function ($scope, proData, SweetAlert, $stateParams) {
    proData.getGoodsDetail($stateParams.id);
    $scope.goodsInfo = proData.goodsInfo;

    proData.getProductCatLits();
    $scope.productCatList = proData.productCatLits;

    $scope.deleteImage = function (index) {
        $scope.goodsInfo.goodsImages.splice(index, 1)
    }
    $scope.deleteTryImage = function () {
        console.log('deleteTryImage');
        $scope.goodsInfo.tryThumb = null;
        console.log($scope.goodsInfo.tryThumb);

    }
    $scope.$watch('goodsInfo',function (newV) {
        $('#editor1').html(newV.description)
    })

    //  添加产品
    $scope.goodsInfo.type = '2';
    $scope.goodsInfo.videoAdds = '11';
    $scope.submitEdit = function () {
        var file1 = document.getElementById('id-input-file-1');
        var file2 = document.getElementById('id-input-file-2');
        var total = file1.files.length + file2.files.length;
        var count = 0;
        var succ = true;

        $scope.sendData = {};
        $scope.goodsInfo.description = $('#editor1').html()

        $scope.goodsInfo.zdiaNum = 1;
        $scope.goodsInfo.fdiaNum = 1;
        $scope.goodsInfo.zdiaWeight = 1;
        $scope.goodsInfo.fdiaWeight = 1;
        $scope.goodsInfo.isSpot = 1;
        $scope.goodsInfo.imagesPath = '11';

        console.log(total);
        var sendImg = [];
        if (file1) {
            for (var i = 0; i < file1.files.length; i++) {
                proData.uploadGoodsImg(file1.files[i], function (data) {
                    if (data === 'error') {
                        succ = false;
                        return;
                    }
                    console.log('receive', data)
                    count++;
                    sendImg.push(data.data.fileurl);
                    goSubmit();
                })
            }
        }
        if (file2) {
            proData.uploadTryImg(file2.files[0], function (data) {
                if (data === 'error') {
                    succ = false;
                    return;
                }
                count++;
                $scope.goodsInfo.tryThumb = data.data.fileurl;
                goSubmit();
            })
        }
        if (!file1.files.length && !file2.files.length) {
            console.log('gogogo', $scope.goodsInfo);
            goSubmit();
        }
        function deepCopy(source) {
            var result={};
            for (var key in source) {
                result[key] = typeof source[key]==='object'? deepCopy(source[key]): source[key];
            }
            return result;
        }

        function goSubmit() {

            if (succ === false) {
                SweetAlert.swal({
                    title: '错误',
                    text: '图片上传失败',
                    type: 'error'
                });
            }
            if (count === total) {
                $scope.sendData = deepCopy($scope.goodsInfo);
                for (var i = $scope.goodsInfo.goodsImages.length - 1; i >= 0; i--) {
                    sendImg.unshift($scope.goodsInfo.goodsImages[i].imageUrl.replace('http://hzmozhi.com:85/', ''))
                }
                $scope.sendData.defaultImage = sendImg[0];
                console.log('final data',$scope.sendData);
                $scope.sendData.goodsImages = angular.toJson(sendImg);
                proData.addProduct($scope.sendData);
            }
        }

    }

    console.log('goodsInfo', $scope.goodsInfo)
})

module.controller('addProductCtrl', function ($scope, proData, SweetAlert) {
    // 获取分类
    proData.getProductCatLits()
    $scope.productCatLits = proData.productCatLits
    //  添加产品
    $scope.formData = {};
    $scope.formData.type = '1';
    $scope.checkInputError = function (code) {
        // console.log($scope.formData.image_url)
    };
    $scope.addProForm = function () {
        var file1 = document.getElementById('id-input-file-1').files;
        var file2 = document.getElementById('id-input-file-2').files[0];
        var file3 = document.getElementById('id-input-file-3').files[0];
        if (!file1) {
            SweetAlert.swal({
                title: '错误',
                text: '请上传图片',
                type: 'error'
            });
            return
        }
        if (!file2) {
            SweetAlert.swal({
                title: '错误',
                text: '请上传图片',
                type: 'error'
            });
            return
        }
        // if (!file3) {
        //     SweetAlert.swal({
        //         title: '错误',
        //         text: '请上传视频',
        //         type: 'error'
        //     });
        //     return
        // }
        // proData.uploadVideo('goodsVideo',file3);

        // $scope.formData.goodsImages = [];
        // for (var g = 0; g < file1.length; g++) {
        //     $scope.formData.goodsImages.push(file1[g].name)
        // }
        //

        $scope.formData.videoAdds = '';
        $scope.formData.description = $('#editor1').html()
        proData.uploadImg('addProduct', file1, function () {
            $scope.formData.goodsImages = angular.toJson(proData.goodsImages)
            $scope.formData.defaultImage = proData.goodsImages[0];
            proData.uploadImg('uploadGoodsTry', file2, function () {
                $scope.formData.tryThumb = proData.tryThumb;
                console.log('img array', $scope.formData.goodsImages)
                console.log('try img', $scope.formData.tryThumb)
                var params = $scope.formData
                proData.addProduct(params)
            });
        });


    };
})