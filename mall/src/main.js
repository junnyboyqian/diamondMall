var app = angular.module('app', [
    'ui.router',
    'oc.lazyLoad',
    'indexCtrl',
    'juejiCtrl',
    'zhuanshiCtrl',
    'goodsinfoCtrl'
])

app.config(function ($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.when('', '/');
    $urlRouterProvider.when('zhuanshi', '/zhuanshi');
    $urlRouterProvider.when('jueji', '/jueji');
    $urlRouterProvider.when('goods', '/goods');
    return $stateProvider
        .state('index', {
            url: '/',
            templateUrl: 'src/views/index/index.html'
        })
        .state('zhuanshi', {
            url: '/zhuanshi',
            templateUrl: 'src/views/zhuanshi/index.html'
        })
        .state('jueji', {
            url: '/jueji',
            templateUrl: 'src/views/jueji/index.html'
        })
        .state('goods', {
            url: '/goods',
            templateUrl: 'src/views/goods/index.html'
        })
})
