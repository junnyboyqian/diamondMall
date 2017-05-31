var module = angular.module('loginMainCtrl', ['loginService', ])

module.controller('loginCtrl', function($scope, $state, $cookies, LoginData, md5) {
    // 判断登录还是注册
    $scope.login = false
    $scope.signup = false
    $scope.isSignup = false
    if ($state.current.name == 'login') {
        $scope.login = true
        $scope.signup = false
    }
    if ($state.current.name == 'signup') {
        $scope.signup = true
        $scope.login = false
    }

    // 登录
    $scope.userInfo = {
        mobile: '',
        pwd: ''
    }
    $scope.loginData = {
        url: '/api/login',
        data: $scope.userInfo
    }
    $scope.loginFun = function() {
            $scope.loginData.data.mobile = $scope.userInfo.mobile
            $scope.loginData.data.pwd = md5.createHash($scope.userInfo.pwd)
            LoginData.POST($scope.loginData).then(function(resp) {
                if (resp.code == 10000) {
                    $cookies.put("userInfo", JSON.stringify(resp.data), { "path": "/" });
                    sessionStorage['userInfo'] = JSON.stringify(resp.data);
                    $state.go('index')
                } else {
                    alert(resp.msg)
                }
            }, function(err) {
                alert(err)
            })
        }
        // 注册
    $scope.z_info = {
        mobile: '',
        pwd: '',
        repwd: '',
        vcode: ''
    }

    $scope.zData = {
            url: '',
            data: {}
        }
        // 获取验证
    $scope.vcodeCount = 1
    $scope.send_msg = function() {
            if (!$scope.z_info.mobile) {
                alert('请输入手机号')
                return
            }
            $scope.zData.data.mobile = $scope.z_info.mobile
            $scope.zData.data.type = 1
            $scope.zData.url = '/api/sendVcode'
            if ($scope.vcodeCount > 1) {
                return
            }
            $scope.vcodeCount = 2
            LoginData.GET($scope.zData).then(function(resp) {
                if (resp.code == 10000) {
                    // $scope.z_info.vcode = resp.data
                    alert('验证码发送成功')
                    $scope.vcodeCount = 1
                } else if (resp.code == 20010) {
                    alert(resp.msg)
                }
            }, function(err) {
                alert(err)
                $scope.vcodeCount = 1

            })
        }
        //注册
    $scope.zCount = 1
    $scope.submitForm = function() {
        $scope.zData.data = {}
        $scope.zData.data.mobile = $scope.z_info.mobile
        $scope.zData.data.pwd = md5.createHash($scope.z_info.pwd)
        $scope.zData.data.repwd = md5.createHash($scope.z_info.repwd)
        $scope.zData.data.vcode = $scope.z_info.vcode
        $scope.zData.url = '/api/register'
        if ($scope.zCount > 1) {
            return
        }
        $scope.zCount = 2
        LoginData.POST($scope.zData).then(function(resp) {
            if (resp.code == 10000) {
                $cookies.put("userInfo", JSON.stringify(result.data), { "path": "/" });
                sessionStorage["userInfo"] = JSON.stringify(resp.data)
                $scope.vcodeCount = 1
                $state.go('index')
            }
        }, function(err) {
            alert(err)
            $scope.vcodeCount = 1
        })

    }


})
