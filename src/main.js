var app = angular.module('app', [
    'ui.router',
    'oc.lazyLoad',
    'indexCtrl',
    'juejiCtrl',
    'zhuanshiCtrl',
    'goodsinfoCtrl',
    'cartCtrl'
])

app.config(function ($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.when('', '/');
    $urlRouterProvider.when('zhuanshi', '/zhuanshi');
    $urlRouterProvider.when('jueji', '/jueji');
    $urlRouterProvider.when('goods', '/goods');
    $urlRouterProvider.when('cart-flow', '/cart-flow');
    $urlRouterProvider.when('cart-flow2', '/cart-flow2');
    $urlRouterProvider.when('order_list', '/order_list');
    $urlRouterProvider.when('profile_password', '/profile_password');
    $urlRouterProvider.when('profile_browse', '/profile_browse');
    $urlRouterProvider.when('address_list', '/address_list');
    $urlRouterProvider.when('help', '/help');
    return $stateProvider
        .state('index', {
            url: '/',
            templateUrl: 'src/views/index/index.html'
        })
        .state('zhuanshi', {
            url: '/zhuanshi/:id',
            templateUrl: 'src/views/zhuanshi/index.html'
        })
        .state('jueji', {
            url: '/jueji/:id',
            templateUrl: 'src/views/jueji/index.html'
        })
        .state('goods', {
            url: '/goods/:id',
            templateUrl: 'src/views/goods/index.html'
        })
        .state('cart-flow', {
            url: '/cart-flow',
            templateUrl: 'src/views/cart/flow.html'
        })
        .state('cart-flow2', {
            url: '/cart-flow2',
            templateUrl: 'src/views/cart/flow2.html'
        })
        .state('order_list', {
            url: '/order_list',
            templateUrl: 'src/views/user/order_list.html'
        })
        .state('profile_password', {
            url: '/profile_password',
            templateUrl: 'src/views/user/profile_password.html'
        })
        .state('profile_browse', {
            url: '/profile_browse',
            templateUrl: 'src/views/user/profile_browse.html'
        })
        .state('address_list', {
            url: '/address_list',
            templateUrl: 'src/views/user/address_list.html'
        })
        .state('help', {
            url: '/help',
            templateUrl: 'src/views/help/help.html'
        })
})

