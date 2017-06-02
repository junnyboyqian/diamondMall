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
// module.controller('editPassWordCtrl', function($scope, $state, httpData) {
//     // 暂无接口
// }）
// 收货地址相关
module.controller('userAddressCtrl', function($scope, $state, httpData, commonData) {
    // 地区对照表
    $scope.regions = commonData.regions
    commonData.getRegions()
    // $scope.addList = commData.getRegions()
    // 现有收获地址
    $scope.addrList = []

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
            } else{
                alert(resp.msg)
            }
        },function(err){
            alert(err)
    })
});
















