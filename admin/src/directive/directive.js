angular.module('directive', [])
    .directive('breadCrumb', function () {
        return {
            restrict: 'AE',
            templateUrl: 'src/components/breadCrumb.html',
            scope: {
                title: '@',
                subTitle: '@',
                endTitle:'@'
            },
            replace: true
        }
    })
    .directive('cLoading',function () {
        return {
            restrict:'AE',
            templateUrl :'src/components/cLoading.html',
            scope:{
                state:'@',
                title:'@'
            },
        }
    })