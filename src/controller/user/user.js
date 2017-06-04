var module = angular.module('userController', ['httpService', 'commonService'])
// 基本信息
module.controller('userInfoCtrl', function($scope, $state, httpData) {
    // 存储用户信息
    $scope.userInfo = {}
    // 判断是否登录
    if(sessionStorage['userInfo']){

    } else {
        $state.go('login')
    }

    $scope.userInfoData = {
        url: '/api/getUserInfo',
        data: {
            accessToken:''
        }
    }

    httpData.GET($scope.userInfoData).then(
        function(resp){
            if(resp.code == 10000){
                $scope.userInfo = resp.data.userInfo
                $scope.$apply()
            } else {
                alert(resp.msg)
            }
        },function(err){
            alert(resp.msg)
    })
});
// 修改密码
module.controller('editPassWordCtrl', function($scope, $state, httpData) {
    $scope.editPassword = function () {
        if ($scope.formData.reNewPwd !== $scope.formData.newPwd) {
            alert('输入有误')
            return
        }
        $scope.formData.oldPwd = md5($scope.formData.oldPwd)
        $scope.formData.newPwd = md5($scope.formData.newPwd)
        $scope.formData.reNewPwd = md5($scope.formData.reNewPwd)
        $scope.formData.accessToken = ''
        var params = $scope.formData
        $scope.editParmas = {
            url:'/api/editPwd',
            data: params
        }

        httpData.POST($scope.editParmas).then(
            function(resp){
                if (resp.code == 10000){
                    alert('密码已修改！')
                    $scope.formData.oldPwd = ''
                    $scope.formData.newPwd = ''
                    $scope.formData.reNewPwd = ''
                } else{
                    alert(resp.msg)
                }
            },function(err){
                alert(err)
        })
    }
})
// 收货地址相关
module.controller('userAddressCtrl', function($scope, $state, httpData, commonData) {
    // 地区对照表
    // $scope.regions = commonData.regions
    commonData.getRegions('getProvince')
    $scope.provinceList = commonData.provinceList


    // 现有收获地址
    // $scope.addrList = []

    $scope.getCity = function () {
        commonData.getRegions('getCity', $scope.formData.provinceId)
        $scope.cityList = commonData.cityList
    }

    $scope.getArea = function () {
        commonData.getRegions('getArea', $scope.formData.cityId)
        $scope.areaList = commonData.areaList
        console.log($scope.areaList)
    }

    $scope.addData = {
        url:'/api/getAddress',
        data: {
            accessToken: ''
        }
    }

    httpData.GET($scope.addData).then(
        function(resp){
            if (resp.code == 10000){
                 $scope.addrList = resp.data.consigneeList
                 console.log($scope.addrList)
            } else{
                alert(resp.msg)
            }
        },function(err){
            alert(err)
    })

    $scope.addAddress = function () {
        $scope.formData.accessToken = ''
        $scope.formData.type = 1
        var params = $scope.formData
        $scope.addAddr = {
            url:'/api/operAddress',
            data: params
        }

        httpData.POST($scope.addAddr).then(
            function(resp){
                if (resp.code == 10000){
                    $scope.addData = {
                        url:'/api/getAddress',
                        data: {
                            accessToken: ''
                        }
                    }

                    httpData.GET($scope.addData).then(
                        function(resp){
                            if (resp.code == 10000){
                                 $scope.addrList = resp.data.consigneeList
                                 console.log($scope.addrList)
                            } else{
                                alert(resp.msg)
                            }
                        },function(err){
                            alert(err)
                    })
                } else{
                    alert(resp.msg)
                }
            },function(err){
                alert(err)
        })
    }
});
// 订单相关
module.controller('userOrderCtrl', function($scope, $state, httpData, commonData) {
    // 订单列表
    $scope.orderList = []
    $scope.orderData = {
        url: '/api/orderList',
        data: {
            offset: 1,
            count: 10,
            accessToken: ''
        }
    }
    httpData.GET($scope.orderData).then(function(resp){
        if(resp.code == 10000){
            $scope.orderList = resp.data.orderList
            console.log($scope.orderList)
            $scope.$apply()
        } else {
            alert(resp.msg)
        }
    }, function(err){
        alert(err)
    })
})















