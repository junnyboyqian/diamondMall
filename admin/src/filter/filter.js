angular.module('filter',[])
.filter('toOnlineUrl',function () {
    return function (url) {
        if(url){
            return 'http://hzmozhi.com:85/' + url;
        }

    }
})
.filter('productList_gtype',function () {
    return function (data) {
        switch (data){
            case '1':
                return '钻石';
                break;
            case '6':
                return '戒子';
                break;
            case '9':
                return '吊坠';
                break;
            case '10':
                return '耳饰';
                break;
            case '15':
                return '手链';
                break;
            case '41':
                return '腕表';
                break;
            default :
                return '';
        }
    }
})