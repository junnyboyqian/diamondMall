function _uGC(l,n,s){
	if(!l||l==""||!n||n==""||!s||s=="") return "-";
	var i,i2,i3,c="-";
	i=l.indexOf(n);
	i3=n.indexOf("=")+1;
	if(i>-1){
		i2=l.indexOf(s,i);
		if(i2<0){
			i2=l.length;
		}
		c=l.substring((i+i3),i2);
	}
	return c;
}
function checkFirst(){
	newVistor = 0;
	var startOfCookie = _uGC(document.cookie,"_utma=",";");
	if (startOfCookie){
		newVistor = startOfCookie.substring((startOfCookie.lastIndexOf('.')+1));
	}
}
function grabReferrer(){
	if (newVistor == 1) {
		var z = _uGC(document.cookie, "_utmz=", ";");
		urchin_source = _uGC(z, "utmcsr=", "|");
		urchin_medium = _uGC(z, "utmcmd=", "|");
		_gaq.push(['_setVar', 'oldSource_'+urchin_source+ ' / ' +urchin_medium]);
	}
	else if(newVistor > 1){
		var utmvCookie = _uGC(document.cookie,"_utmv",";");
		var oldSource = utmvCookie.indexOf("oldSource_");
		if(oldSource == -1){
			var z = _uGC(document.cookie, "_utmz=", ";");
			urchin_source = _uGC(z, "utmcsr=", "|");
			urchin_medium = _uGC(z, "utmcmd=", "|");
			_gaq.push(['_setVar','oldSource_'+urchin_source+' / '+urchin_medium]);
		}
	}
}
var _gaq = _gaq || [];
_gaq.push(
	['_setAccount', 'UA-24601279-1'],
	['_setDomainName', 'mklm.cn'],
	['_addOrganic', 'm.baidu', 'word'],
	['_addOrganic', 'wap.baidu', 'word'],
	['_addOrganic', 'baidu.mobi', 'word'],
	['_addOrganic', 'news.baidu', 'word'],
	['_addOrganic', 'opendata.baidu', 'wd'],
	['_addOrganic', 'post.baidu', 'kw'],
	['_addOrganic', 'mp3.baidu', 'word'],
	['_addOrganic', 'mp3.baidu', 'song'],
	['_addOrganic', 'box.zhangmen.baidu', 'word'],
	['_addOrganic', 'image.baidu', 'word'],
	['_addOrganic', 'top.baidu', 'w'],
	['_addOrganic', 'baidu', 'word'],
	['_addOrganic', 'baidu', 'kw'],
	['_addOrganic', 'baidu', 'q1'],
	['_addOrganic', 'baidu', 'q2'],
	['_addOrganic', 'baidu', 'q3'],
	['_addOrganic', 'baidu', 'q4'],
	['_addOrganic', 'baidu', 'q5'],
	['_addOrganic', 'baidu', 'q6'],
	['_addOrganic', 'news.google', 'q'],
	['_addOrganic', 'image.soso', 'w'],
	['_addOrganic', 'wenwen.soso', 'sp'],
	['_addOrganic', 'wenwen.soso', 'w'],
	['_addOrganic', 'wap.soso', 'key'],
	['_addOrganic', 'soso', 'w'],
	['_addOrganic', 'bing', 'q'],
	['_addOrganic', '3721', 'name'],
	['_addOrganic', '114', 'kw'],
	['_addOrganic', 'youdao', 'q'],
	['_addOrganic', 'vnet', 'kw'],
	['_addOrganic', 'so.com', 'q'],
	['_addOrganic', 'news.sogou', 'query'],
	['_addOrganic', 'mp3.sogou', 'query'],
	['_addOrganic', 'pic.sogou', 'query'],
	['_addOrganic', 'blogsearch.sogou', 'query'],
	['_addOrganic', 'wap.sogou', 'keyword'],
	['_addOrganic', 'm.sogou', 'keyword'],
	['_addOrganic', 'sogou', 'query'],
	['_setSiteSpeedSampleRate', 100],
	['_trackPageview']
);
/*checkFirst();
grabReferrer();
(function() {var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js';var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);})();

(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
ga('create', 'UA-35712151-3', 'mklm.cn');
ga('send', 'pageview');
*/