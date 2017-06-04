var module = angular.module('userCtrl', ['userService'])

module.controller('groupListCtrl', function ($scope, userData) {
    //  管理组列表
    userData.getAdminGroupList()
    $scope.adminGroupList = userData.adminGroupList
    console.log('adminGroupList',$scope.adminGroupList)
})

module.controller('operAdminGroupCtrl', function ($scope, userData) {
    //  添加管理组权限
    $scope.formData = {};
    $scope.formData.type = '1';
    $scope.processForm = function () {
        var params = $scope.formData;
        userData.addOperAdminGroup(params)
    };
    userData.getPermissionList();
    $scope.permissionList = userData.permissionList;
    console.log('permissionList',$scope.permissionList)
})

module.controller('operAdminGroupCtrl', function ($scope, userData) {
    //  添加管理组权限
    $scope.formData = {};
    $scope.formData.type = '1';
    $scope.processForm = function () {
        var params = $scope.formData
        userData.addOperAdminGroup(params)
    };
    userData.getPermissionList();
    $scope.permissionList = userData.permissionList;
    console.log('permissionList',$scope.permissionList)
})

module.controller('adminListCtrl', function ($scope, userData) {
    //  管理员列表
    userData.getAdminList()
    $scope.adminList = userData.adminList
    console.log('adminList', $scope.adminList)
})

module.controller('userListCtrl', function ($scope, userData) {
    //  客户列表
    userData.getUserList()
    $scope.userList = userData.userList
    console.log('adminList', $scope.userList)

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
    userData.getAdminGroupDetail($stateParams.id);
    $scope.adminGroupDetail = userData.adminGroupDetail;
    console.log($scope.adminGroupDetail);
    console.log($scope.permissionList)

})
module.controller('userDetailCtrl',function ($scope, $stateParams,userData) {
    console.log($stateParams.id)
    userData.getUserDetail($stateParams.id);
    $scope.
    console.log()
})
