var module = angular.module('userCtrl', ['userService'])

module.controller('groupListCtrl', function ($scope, userData) {
    //  管理组列表
    userData.getAdminGroupList()
    $scope.adminGroupList = userData.adminGroupList
    console.log('adminGroupList',$scope.adminGroupList)
})

// module.controller('operAdminGroupCtrl', function ($scope,userData) {
//     //  添加管理组权限
//     $scope.formData = {};
//     $scope.formData.type = '1';
//     $scope.processForm = function () {
//         var params = $scope.formData;
//         userData.addOperAdminGroup(params)
//     };
//     userData.getPermissionList();
//     $scope.permissionList = userData.permissionList;
//     console.log('permissionList',$scope.permissionList)
// })

module.controller('operAdminGroupCtrl', function ($scope, userData) {
    //  添加管理组权限
    $scope.formData = {};
    $scope.formData.type = '1';
    // $scope.processForm = function () {
    //     var params = $scope.formData
    //     userData.addOperAdminGroup(params)
    // };
    userData.getPermissionList();
    $scope.permissionList = userData.permissionList;
    console.log('permissionList',$scope.permissionList)
    $scope.processForm = function () {
        console.log($scope.formData)
    }
})

module.controller('adminListCtrl', function ($scope, userData,SweetAlert,$state) {
    //  管理员列表
    userData.getAdminList()
    $scope.adminList = userData.adminList
    console.log('adminList', $scope.adminList)
    $scope.deleteAdmin = function (id) {
        SweetAlert.swal({
            title: '确认',
            text: '确认删除管理员？',
            type: 'warning',
            showCancelButton:true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定删除！",
            cancelButtonText: "取消删除！",
            closeOnConfirm: false,
            closeOnCancel: true
        },function (isConfirm) {
            if(isConfirm){
                userData.operAdmin({adminId:id,type:'3'},function () {
                    $state.go('index.adminUserList',{},{reload:true})
                })
            }else{
                return;
            }

        })

    }
})
module.controller('addAdminCtrl', function ($scope, userData,$state,SweetAlert) {
    //  添加管理员
    userData.getAdminGroupList();
    $scope.adminGroupList = userData.adminGroupList;
    $scope.formData = {};
    $scope.formData.type = '1';
    $scope.submitForm = function () {
        var params = $scope.formData;
        userData.operAdmin(params, function () {
            $state.go('index.adminUserList')
        })
    }
    console.log('adminList', $scope.adminGroupList)
})
module.controller('editAdminCtrl',function ($scope, userData, $stateParams,$state) {
    userData.getAdminGroupList();
    $scope.adminGroupList = userData.adminGroupList;
    userData.getAdminDetail($stateParams.id);
    console.log($stateParams.id);
    $scope.adminDetail = {};
    $scope.adminDetail.type = '2';
    $scope.adminDetail = userData.adminDetail;
    $scope.submitForm = function () {
        var params = $scope.adminDetail;
        console.log(params);
        userData.operAdmin(params,function () {
            $state.go('index.adminUserList')
        })
    }


})

module.controller('userListCtrl', function ($scope, userData) {
    //  客户列表
    userData.getUserList()
    $scope.userList = userData.userList
    console.log('userList', $scope.userList)

})

module.controller('userGroupListCtrl', function ($scope, userData) {
    //  客户登记列表
    userData.getUserGroupList()
    $scope.userGroupList = userData.userGroupList
    console.log('userGroupList',$scope.userGroupList)
})

module.controller('groupInfoCtrl',function ($scope,userData,$stateParams) {
    userData.getPermissionList();
    $scope.permissionList = userData.permissionList;

    userData.getAdminGroupDetail($stateParams.id, function () {
        $scope.adminGroupDetail = userData.adminGroupDetail;
        $scope.adminGroupDetail.permission = JSON.parse(angular.fromJson($scope.adminGroupDetail.permission))
        console.log($scope.adminGroupDetail.permission)
    });



    console.log('adg',$scope.adminGroupDetail);
    console.log($scope.permissionList)
    $scope.submitForm = function () {
        console.log($scope.adminGroupDetail)
        console.log('xxx')
    }

})
module.controller('userInfoCtrl',function ($scope, $stateParams,userData) {
    console.log($stateParams.id)
    userData.getUserDetail($stateParams.id);
    $scope.userDetail = userData.userDetail;
    console.log($scope.userDetail)
})
