var module = angular.module('userCtrl', ['userService'])

module.controller('groupListCtrl', function ($scope, userData) {
    //  管理组列表
    userData.getAdminGroupList()
    $scope.adminGroupList = userData.adminGroupList
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
    console.log($scope.permissionList)
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
    console.log($scope.permissionList)
})

module.controller('adminListCtrl', function ($scope, userData) {
    //  管理员列表
    userData.getAdminList()
    $scope.adminList = userData.adminList
})

module.controller('userListCtrl', function ($scope, userData) {
    //  客户列表
    userData.getUserList()
    $scope.userList = userData.userList
})

module.controller('userGroupListCtrl', function ($scope, userData) {
    //  客户登记列表
    userData.getUserGroupList()
    $scope.userGroupList = userData.userGroupList
})
