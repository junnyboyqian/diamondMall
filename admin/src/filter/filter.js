angular.module('filter', [])
    .filter('toOnlineUrl', function () {
        return function (url) {
            if (url) {
                return 'http://hzmozhi.com:85/' + url;
            }

        }
    })
    .filter('showPage',function () {
        return function (data) {
            if(data){
                data = Number(data);
                return data >= 10;
            }

        }
    })
    .filter('productList_gtype', function () {
        return function (data) {
            switch (data) {
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
    .filter('adminUserList_status', function () {
        return function (data) {
            return data === '1' ? '开启' : '关闭'
        }
    })
    .filter('orderList_state',function () {
        return function (data) {
            switch(data){
                case '10':
                    return '货到付款:待发货'; break;
                case '11':
                    return '已下单:等待付款'; break;
                case '20':
                    return '已付款:等待发货'; break;
                case '30':
                    return '卖家已发货'; break;
                case '40':
                    return '交易成功'; break;
                case '50':
                    return '退款'; break;
                case '0':
                    return '交易已取消'; break;
            }
        }

    })