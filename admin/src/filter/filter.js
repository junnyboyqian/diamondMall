angular.module('filter',[])
.filter('toOnlineUrl',function () {
    return function (url) {
        if(url){
            return 'http://hzmozhi.com:85/' + url;
        }

    }
})