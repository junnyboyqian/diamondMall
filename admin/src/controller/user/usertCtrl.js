var module = angular.module('userCtrl', ['userService'])

module.controller('groupListCtrl', function ($scope, userData,$state,SweetAlert) {
    //  管理组列表
    userData.getAdminGroupList()
    $scope.adminGroupList = userData.adminGroupList
    $scope.deleteAdminGroup = function (id) {
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
                userData.addOperAdminGroup({adminGpId:id,type:'3'})
            }else{
                return;
            }

        })

    }
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

module.controller('addAdminGroupCtrl', function ($scope, userData) {
    //  添加管理组权限
    $scope.formData = {};
    $scope.formData.permission = {};
    $scope.formData.type = '1';
    userData.getPermissionList();
    $scope.permissionList = userData.permissionList;
    console.log('permissionList',$scope.permissionList)
    $scope.submitForm = function () {
        $scope.formData.permission = angular.toJson($scope.formData.permission)
        console.log($scope.formData)
        userData.operAdminGroup($scope.formData)
    }
})
//edit admin group
module.controller('groupInfoCtrl',function ($scope,userData,$stateParams) {
    userData.getPermissionList();
    $scope.permissionList = userData.permissionList;
    userData.getAdminGroupDetail($stateParams.id,function () {
        $scope.adminGroupDetail = userData.adminGroupDetail;
        console.log('add detail', $scope.adminGroupDetail);
        $scope.permissionObj = (JSON.parse($scope.adminGroupDetail.permission.replace('"{','{').replace('}"','}')));
        console.log('pobj',$scope.permissionObj);
        $scope.submitForm = function () {
            var params = $scope.adminGroupDetail;
            params.type = '2';
            params.adminGpId = $stateParams.id;
            params.adminGpName = $scope.adminGroupDetail.groupName;
            params.permission = angular.toJson($scope.permissionObj)
            console.log(params)
            userData.operAdminGroup(params)
        }
    });



    // userData.getAdminGroupDetail($stateParams.id, function () {
    //     $scope.adminGroupDetail = userData.adminGroupDetail;
    //     console.log($scope.adminGroupDetail.permission);
    //     if($scope.adminGroupDetail.permission){
    //         $scope.adminGroupDetail.permission = JSON.parse($scope.adminGroupDetail.permission.replace('\"\{','{').replace('\}\"','}'))
    //         console.log($scope.adminGroupDetail.permission)
    //     }
    //
    // });



    console.log('adg',$scope.adminGroupDetail);
    console.log('perlist',$scope.permissionList)
    $scope.submitForm = function () {
        console.log($scope.adminGroupDetail)
        console.log('xxx')
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




module.controller('userInfoCtrl',function ($scope, $stateParams,userData) {
    console.log($stateParams.id)
    userData.getUserDetail($stateParams.id);
    $scope.userDetail = userData.userDetail;
    console.log($scope.userDetail)
})
module.controller('userListCtrl', function ($scope, userData,$state,SweetAlert) {
    //  客户列表
    userData.getUserList()
    $scope.userList = userData.userList
    console.log('userList', $scope.userList)
    $scope.deleteUser = function (id) {

            SweetAlert.swal({
                title: '确认',
                text: '确认删除用户？',
                type: 'warning',
                showCancelButton:true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "确定删除！",
                cancelButtonText: "取消删除！",
                closeOnConfirm: false,
                closeOnCancel: true
            },function (isConfirm) {
                if(isConfirm){
                    userData.operUser({userId:id,type:'3'},function () {
                        $state.go('index.userList',{},{reload:true})
                    })
                }else{
                    return;
                }

            })

    }

})
module.controller('addUserCtrl',function ($scope,userData,$state) {

    //type(1 新增、2 编辑、3 删除) 、userId 、userName 、pwd、realName、groupId、status、ywyId(业务员ID)
    $scope.formData = {};
    $scope.formData.type = '1';

    userData.getUserGroupList()
    $scope.userGroupList = userData.userGroupList;
    console.log($scope.userGroupList);

    $scope.submitForm = function () {
        var params = $scope.formData;
        userData.operUser(params,function () {
            $state.go('index.userList')
        })
    }


})
module.controller('editUserCtrl',function ($scope,userData,$state,$stateParams) {

    //type(1 新增、2 编辑、3 删除) 、userId 、userName 、pwd、realName、groupId、status、ywyId(业务员ID)
    userData.getUserDetail($stateParams.id);
    $scope.formData = userData.userDetail;
    $scope.formData.type = '2';
    console.log($scope.formData)

    userData.getUserGroupList()
    $scope.userGroupList = userData.userGroupList;
    console.log($scope.userGroupList);

    $scope.submitForm = function () {
    // type(1 新增、2 编辑、3 删除) 、userId 、userName 、pwd、realName、groupId、status、ywyId(业务员ID)
        var params = {};
        var data = ['userId','userName','pwd','realName','groupId','status','ywyId'];
        for (var i =0;i<data.length;i++){
            params[data[i]] = $scope.formData[data[i]]
        }
        params.type = '2'
        console.log(params);
        userData.operUser(params,function () {
            $state.go('index.userList')
        })
    }


})


module.controller('userGroupListCtrl', function ($scope, userData,SweetAlert) {
    //  客户登记列表
    userData.getUserGroupList()
    $scope.userGroupList = userData.userGroupList
    console.log('userGroupList',$scope.userGroupList)
    $scope.deleteUserRank = function (id) {
        userData.operUserGroupList({type:'3',userGpId:id},function () {
            SweetAlert.swal({
                title: '正确',
                text: '添加成功',
                type: 'success',
            },function () {

            })
        })
    }
})
module.controller('addUserRankCtrl',function ($scope,userData,SweetAlert,$state) {
    $scope.userRankInfo = {};
    $scope.userRankInfo.type = '1';
    $scope.submitForm = function () {
        console.log('submit',$scope.userRankInfo)
        var params = $scope.userRankInfo;
        userData.operUserGroupList(params,function () {
            SweetAlert.swal({
                title: '正确',
                text: '添加成功',
                type: 'success',
            },function () {
                $state.go('index.userRank')
            })
        })
    }
})
module.controller('editUserRankCtrl',function ($scope,$stateParams,SweetAlert,$state,userData) {

    userData.getUserGroupById($stateParams.id);
    $scope.userRankInfo =  userData.userGroupDetail;
    console.log($scope.userRankInfo);
    //type(1 新增、2 编辑、3 删除) 、userGpId 、userGpName 、remark
    $scope.submitForm = function () {
        var sendData = {};
        sendData.type = '2';
        sendData.userGpName = $scope.userRankInfo.groupName;
        sendData.userGpId = $scope.userRankInfo.id;
        sendData.remark = $scope.userRankInfo.remark;
        console.log('submit',sendData);
        var params = sendData;
        userData.operUserGroupList(params,function () {
            SweetAlert.swal({
                title: '正确',
                text: '添加成功',
                type: 'success',
            },function () {
                $state.go('index.userRank')
            })
        })
    }
})
