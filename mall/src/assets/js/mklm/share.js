var _url = encodeURIComponent(document.location);
var _site = 'http://www.mklm.cn/';
function push2Tx(_c, _t, _pic){window.open('http://v.t.qq.com/share/share.php?title=“'+_t+'” '+_c+' &url='+_url+'&site='+_site+'&pic='+_pic,'转播到腾讯微博');}
function push2Sina(_c, _t, _pic){window.open('http://v.t.sina.com.cn/share/share.php?title=“'+_t+'” '+_c+' &url='+_url+'&site='+_site,'分享到新浪微博');}
function push2QZone(_c, _t, _pic){window.open('http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url='+_url+'&rcontent=','_blank'); void 0}
function push2Ren(_c, _t, _pic){window.open('http://share.renren.com/share/buttonshare.do?title='+_t+'&link='+_url+'&content=','_blank'); void 0}
function push2DCang(_c, _t, _pic){window.open('http://cang.baidu.com/do/add?it='+_t+'&iu='+_url+'&fr=ien#nw=1','_blank','搜藏到百度');}
//#TX#整合分享函数
function snsShare(to, contents, brandAndStyle, imageUrl){
	imageUrl = encodeURI(_site+imageUrl);
	eval("push2"+to+"('"+contents+"','"+brandAndStyle+"','"+imageUrl+"')");
}
