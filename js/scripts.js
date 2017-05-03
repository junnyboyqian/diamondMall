$(document).ready(function() {
	//initNivoSlider();
});
/*
function initNivoSlider(){
	$('#slider3').nivoSlider({
		pauseTime:7000,
		pauseOnHover:false,
		directionNav:true,			
		controlNavThumbs:false,
		controlNavThumbsFromRel:false,
		useTransparentBg:false
	});	
}
*/
function showTopNav(layerName){
    var need_inv = get_need_inv();
    if(layerName=='pay_fp2' && need_inv==1){    
        var inv_content = document.getElementById('ECS_INVCONTENT').value;
        var inv_payee = document.getElementById('ECS_INVPAYEE').value;
        if(inv_payee=='' || !inv_payee) {
            alert('请填写发票抬头');
            return true;
        }else{            
            document.getElementById("fapiao_type").innerText = '普通发票（纸质）  '+inv_content+'  '+inv_payee;
        }
    }
    if(layerName=='pay_fp2' && need_inv==0){         
        document.getElementById("fapiao_type").innerText = '不需要发票';      
    }
    if(layerName=='pay_fp' && need_inv==1){         
        document.getElementById('ECS_INVPAYEE').value = "";      
    }
	eval('document.getElementById('+ "'" + layerName + "'" +').style.display = "block"');
}
function hideTopNav(layerName){
    var need_inv = get_need_inv();
    
    if(layerName=='pay_fp' && need_inv==1){
        var inv_payee = document.getElementById('ECS_INVPAYEE').value;
        if(inv_payee=='' || !inv_payee) {
            return true;
        }
    }
	eval('document.getElementById('+ "'" + layerName + "'" +').style.display = "none"');
}
function get_need_inv(){
    var value="";
    var radio=document.getElementsByName("need_inv");
    for(var i=0;i<radio.length;i++){
        if(radio[i].checked==true){
            value=radio[i].value;
            break;
        }
    }

    return value;
}
$(function() {
	var sWidth = $("#focus").width(); //获取焦点图的宽度（显示面积）
	var len = $("#focus ul li").length; //获取焦点图个数
	var index = 0;
	var picTimer;
	
	//以下代码添加数字按钮和按钮后的半透明条，还有上一页、下一页两个按钮
	var btn = "<div class='btnBg'></div><div class='btn'>";
	for(var i=0; i < len; i++) {
		btn += "<span></span>";
	}
	btn += "</div><div class='preNext pre'></div><div class='preNext next'></div>";
	$("#focus").append(btn);
	$("#focus .btnBg").css("opacity",0.5);

	//为小按钮添加鼠标滑入事件，以显示相应的内容
	$("#focus .btn span").css("opacity",0.4).mouseover(function() {
		index = $("#focus .btn span").index(this);
		showPics(index);
	}).eq(0).trigger("mouseover");

	//上一页、下一页按钮透明度处理
	$("#focus .preNext").css("opacity",0.2).hover(function() {
		$(this).stop(true,false).animate({"opacity":"0.5"},300);
	},function() {
		$(this).stop(true,false).animate({"opacity":"0.2"},300);
	});

	//上一页按钮
	$("#focus .pre").click(function() {
		index -= 1;
		if(index == -1) {index = len - 1;}
		showPics(index);
	});

	//下一页按钮
	$("#focus .next").click(function() {
		index += 1;
		if(index == len) {index = 0;}
		showPics(index);
	});

	//本例为左右滚动，即所有li元素都是在同一排向左浮动，所以这里需要计算出外围ul元素的宽度
	$("#focus ul").css("width",sWidth * (len));
	
	//鼠标滑上焦点图时停止自动播放，滑出时开始自动播放
	$("#focus").hover(function() {
		clearInterval(picTimer);
	},function() {
		picTimer = setInterval(function() {
			showPics(index);
			index++;
			if(index == len) {index = 0;}
		},4000); //此4000代表自动播放的间隔，单位：毫秒
	}).trigger("mouseleave");
	
	//显示图片函数，根据接收的index值显示相应的内容
	function showPics(index) { //普通切换
		var nowLeft = -index*sWidth; //根据index值计算ul元素的left值
		$("#focus ul").stop(true,false).animate({"left":nowLeft},300); //通过animate()调整ul元素滚动到计算出的position
		//$("#focus .btn span").removeClass("on").eq(index).addClass("on"); //为当前的按钮切换到选中的效果
		$("#focus .btn span").stop(true,false).animate({"opacity":"0.4"},300).eq(index).stop(true,false).animate({"opacity":"1"},300); //为当前的按钮切换到选中的效果
	}
});
function setTab(m,n){
	var tli=document.getElementById("menu"+m).getElementsByTagName("li");
	var mli=document.getElementById("main"+m).getElementsByTagName("ol");
	for(i=0;i<tli.length;i++){
		//tli[i].className=i==n?"hover":"";
		mli[i].style.display=i==n?"block":"none";
    }        
}