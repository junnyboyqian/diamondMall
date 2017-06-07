var module = angular.module('userService', [])

module.service('userData', function ($http, $state, SweetAlert) {
    var self = this;
    //  管理组列表
    self.adminGroupList = [];
    self.getAdminGroupList = function () {
        var url = '/api/admin/adminGroupList';
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
            return angular.copy(data.data.adminGroupList, self.adminGroupList);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    };
    // 添加管理组权限
    self.addOperAdminGroup = function (formData) {
        var url = '/api/admin/operAdminGroup';
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
            $state.go('index.user');
        }).error(function (res) {
            SweetAlert.swal({
                title: '错误',
                text: '请填写所有字段',
                type: 'error'
            });
        })
    };

    ////groupInfo
    // 管理员组详情
    // url：admin/getAdminGroupDetail
    // GET
    // input:
    //     adminGpId
    // output:
    //     adminGroupDetail
    self.adminGroupDetail = [];
    self.getAdminGroupDetail = function (id, cb) {
        var url = '/api/admin/getAdminGroupDetail';
        return $http({
            method: 'GET',
            url: url,
            params: {
                adminGpId: id
            },
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            console.log(data)
            angular.copy(data.data.adminGroupDetail[0], self.adminGroupDetail);
            return cb && cb()
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    }

    //  管理员列表
    self.permissionList = [];
    self.getPermissionList = function () {
        var url = '/api/admin/getPermissions';
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
            console.log('permissions', data.data.permissionList)
            return angular.copy(data.data.permissionList, self.permissionList);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    };

    //  管理员列表
    self.adminList = [];
    self.getAdminList = function () {
        var url = '/api/admin/adminList';
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
            return angular.copy(data.data.adminList, self.adminList);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    };


    //  客户列表
    self.userList = [];
    self.getUserList = function () {
        var url = '/api/admin/userList';
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
            return angular.copy(data.data.userList, self.userList);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    };
    //  用户等级
    self.userGroupList = [];
    self.getUserGroupList = function () {
        var url = '/api/admin/userGroupList';
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
            return angular.copy(data.data.userGroupList, self.userGroupList);
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
    self.getGoodsList = function () {
        var url = '/api/admin/goodsList';
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
    }
    // 产品分类
    self.productCatLits = [];
    self.getProductCatList = function () {
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
    //操作管理员
    self.operAdmin = function (formData, cb) {
        var url = '/api/admin/operAdmin';
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
                text: '操作成功',
                type: 'success'
            }, function () {
                cb && cb();
            });
        }).error(function (res) {
            SweetAlert.swal({
                title: '错误',
                text: '请填写所有字段',
                type: 'error'
            });
        })
    }
    //管理员详情
    self.adminDetail = [];
    self.getAdminDetail = function (id) {
        var url = '/api/admin/getAdminDetail';
        return $http({
            method: 'GET',
            url: url,
            params: {
                adminId: id
            },
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            console.log(data)
            return angular.copy(data.data.adminDetail[0], self.adminDetail);
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    }

    //用户详情
    self.userDetail = [];
    self.getUserDetail = function (id) {
        var url = '/api/admin/getUserDetail';
        return $http({
            method: 'GET',
            url: url,
            params: {
                userId: id
            },
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).success(function (data) {
            return angular.copy(data.data.userDetail, self.userDetail);
            console.log('userDetail', self.userDetail)
        }).error(function (res) {
            return console.log('ERROR: ' + res);
        })
    }


})