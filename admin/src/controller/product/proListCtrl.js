var module = angular.module('productCtrl', ['productService'])

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
module.controller('productListCtrl', function ($scope, proData) {
    // 产品分类
    proData.getGoodsList()
    $scope.goodsList = proData.goodsList;
    console.log($scope.goodsList)
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
        $scope.formData.goodsImages = [];
        for (var g = 0; g < file1.length; g++) {
            $scope.formData.goodsImages.push(file1[g].name)
        }
        $scope.formData.defaultImage = file1[0].name;
        $scope.formData.goodsImages = angular.toJson($scope.formData.goodsImages)
        $scope.formData.tryThumb = file2.name
        $scope.formData.videoAdds = file3.name || '';
        $scope.formData.description = $('#editor1').html()
        var params = $scope.formData
        proData.uploadImg('addProduct', file1 ,function () {
            proData.uploadImg('uploadGoodsTry', file2 , function () {
                proData.addProduct(params)
            });
        });


    };
})