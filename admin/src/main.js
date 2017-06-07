var app = angular.module('app', [
    'ui.router',
    'oc.lazyLoad',
    'oitozero.ngSweetAlert',
    'productCtrl',
    'userCtrl',
    'spreadCtrl'
])

app.run(['$rootScope',function ($rootScope) {
    $rootScope.seriesName = [

    ];
}])

app.config(function ($stateProvider, $urlRouterProvider, $ocLazyLoadProvider) {
    $urlRouterProvider.when('', '/');
    $urlRouterProvider.when('user', '/user');
    $urlRouterProvider.when('addGroup', '/addGroup');
    $urlRouterProvider.when('groupInfo', '/groupInfo');
    $urlRouterProvider.when('adminUserList', '/adminUserList');
    $urlRouterProvider.when('adminUserInfo', '/adminUserInfo');
    $urlRouterProvider.when('userList', '/userList');
    $urlRouterProvider.when('userInfo', '/userInfo');
    $urlRouterProvider.when('userAddList', '/userAddList');
    $urlRouterProvider.when('adminUserAddInfo', '/adminUserAddInfo');
    $urlRouterProvider.when('userRank', '/userRank');
    $urlRouterProvider.when('userRankInfo', '/userRankInfo');
    $urlRouterProvider.when('productList', '/productList');
    $urlRouterProvider.when('productCatLits', '/productCatLits');
    $urlRouterProvider.when('productAttributeList', '/productAttributeList');
    $urlRouterProvider.when('goodsSeriesList', '/goodsSeriesList');
    $urlRouterProvider.when('productInfo', '/productInfo');
    $urlRouterProvider.when('productCatLitsupdatepic', '/productCatLitsupdatepic');
    $urlRouterProvider.when('goodsSeriesUpdate', '/goodsSeriesUpdate');
    $urlRouterProvider.when('goodsList', '/goodsList');
    $urlRouterProvider.when('proList', '/proList');
    $urlRouterProvider.when('addProduct', '/addProduct');
    $urlRouterProvider.when('addGoods', '/addGoods');
    $urlRouterProvider.when('addGoodsSeries', '/addGoodsSeries');
    $ocLazyLoadProvider.config({
      debug: false
    });
    return $stateProvider
        .state('index', {
            url: '/',
            templateUrl: 'src/views/index/index.html'
        })
        .state('index.user', {
            url: 'user',
            templateUrl: 'src/views/user/groupList.html'
        })
        .state('index.groupInfo', {
            url: 'index/groupInfo/:id',
            templateUrl: 'src/views/user/groupInfo.html'
        })
        .state('index.addGroup', {
            url: 'index/addGroup',
            templateUrl: 'src/views/user/addGroup.html'
        })
        .state('index.adminUserList', {
            url: 'index/adminUserList/:id',
            templateUrl: 'src/views/user/adminUserList.html'
        })
        .state('index.adminUserInfo', {
            url: 'index/adminUserInfo/:id',
            templateUrl: 'src/views/user/adminUserInfo.html'
        })
        .state('index.userList', {
            url: 'index/userList',
            templateUrl: 'src/views/user/userList.html'
        })
        .state('index.userInfo', {
            url: 'index/userInfo/:id',
            templateUrl: 'src/views/user/userInfo.html'
        })
        .state('index.userAddList', {
            url: 'index/userAddList',
            templateUrl: 'src/views/user/userAddList.html'
        })
        .state('index.adminUserAddInfo', {
            url: 'index/adminUserAddInfo',
            templateUrl: 'src/views/user/adminUserAddInfo.html'
        })
        .state('index.userRank', {
            url: 'index/userRank',
            templateUrl: 'src/views/user/userRank.html'
        })
        .state('index.userRankInfo', {
            url: 'index/userRankInfo',
            templateUrl: 'src/views/user/userRankInfo.html'
        })
        .state('index.productList', {
            url: 'index/productList/:page',
            templateUrl: 'src/views/product/productList.html'
        })
        .state('index.productCatLits', {
            url: 'index/productCatLits',
            templateUrl: 'src/views/product/productCatLits.html'
        })
        .state('index.productCatLitsupdatepic', {
            url: 'index/productCatLitsupdatepic',
            templateUrl: 'src/views/product/productCatLitsupdatepic.html'
        })
        .state('index.productAttributeList', {
            url: 'index/productAttributeList',
            templateUrl: 'src/views/product/productAttributeList.html'
        })
        .state('index.goodsSeriesList', {
            url: 'index/goodsSeriesList',
            templateUrl: 'src/views/product/goodsSeriesList.html'
        })
        .state('index.goodsSeriesUpdate', {
            url: 'index/goodsSeriesUpdate',
            templateUrl: 'src/views/product/goodsSeriesUpdate.html'
        })
        .state('index.productInfo', {
            url: 'index/productInfo/:id',
            templateUrl: 'src/views/product/productInfo.html'
        })
        .state('index.goodsList', {
            url: 'index/goodsList',
            templateUrl: 'src/views/product/goodsList.html'
        })
        .state('index.proList', {
            url: 'index/proList',
            templateUrl: 'src/views/product/proList.html'
        })
        .state('index.addProduct', {
            url: 'index/addProduct',
            templateUrl: 'src/views/product/addProduct.html'
        })
        .state('index.addGoods', {
            url: 'index/addGoods',
            templateUrl: 'src/views/product/addGoods.html'
        })
        .state('index.addGoodsSeries', {
            url: 'index/addGoodsSeries',
            templateUrl: 'src/views/product/addGoodsSeries.html'
        })
        .state('index.articleCateList', {
            url: 'index/articleCateList',
            templateUrl: 'src/views/spread/articleCateList.html'
        })
        .state('index.addArticleCate', {
            url: 'index/addArticleCate',
            templateUrl: 'src/views/spread/addArticleCate.html'
        })
        .state('index.articleList', {
            url: 'index/articleList',
            templateUrl: 'src/views/spread/articleList.html'
        })
})
