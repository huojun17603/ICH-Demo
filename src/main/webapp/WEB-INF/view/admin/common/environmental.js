/**
 * 系统环境验证JS
 */

function environmentalVRY(){ 
//     	var s = "";   
//      s += " 网页可见区域宽："+ document.body.clientWidth+"\n";    
//      s += " 网页可见区域高："+ document.body.clientHeight+"\n";    
//      s += " 网页可见区域宽："+ document.body.offsetWidth + " (包括边线和滚动条的宽)"+"\n";    
//      s += " 网页可见区域高："+ document.body.offsetHeight + " (包括边线的宽)"+"\n";    
//      s += " 网页正文全文宽："+ document.body.scrollWidth+"\n";    
//      s += " 网页正文全文高："+ document.body.scrollHeight+"\n";    
//      s += " 网页被卷去的高(ff)："+ document.body.scrollTop+"\n";    
//      s += " 网页被卷去的高(ie)："+ document.documentElement.scrollTop+"\n";    
//      s += " 网页被卷去的左："+ document.body.scrollLeft+"\n";    
//      s += " 网页正文部分上："+ window.screenTop+"\n";    
//      s += " 网页正文部分左："+ window.screenLeft+"\n";    
//      s += " 屏幕分辨率的高："+ window.screen.height+"\n";    
//      s += " 屏幕分辨率的宽："+ window.screen.width+"\n";    
//      s += " 屏幕可用工作区高度："+ window.screen.availHeight+"\n";    
//      s += " 屏幕可用工作区宽度："+ window.screen.availWidth+"\n";    
//      s += " 你的屏幕设置是 "+ window.screen.colorDepth +" 位彩色"+"\n";    
//      s += " 你的屏幕设置 "+ window.screen.deviceXDPI +" 像素/英寸"+"\n";    
//	 	alert (s);
//要求最低分辨率为：1280*720
	if(window.screen.height<960||window.screen.width<1280){
		alert("您的电脑分辨率过低无法正常显示，要求最低分辨率为：1280*960！");
	}
     
//要求使用浏览器类型	
	var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    var isOpera = userAgent.indexOf("Opera") > -1;
    if (isOpera) {
//        alert("Opera");//判断是否Opera浏览器
    }; 
    if (userAgent.indexOf("Firefox") > -1) {
//    	alert("FF");//判断是否Firefox浏览器
    } 
    if (userAgent.indexOf("Chrome") > -1){
//    	alert("Chrome");
	 }
    if (userAgent.indexOf("Safari") > -1) {
//    	alert("Safari");//判断是否Safari浏览器
    } 
    if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera) {
//    	alert("IE"); //判断是否IE浏览器
    	alert("使用IE会导致部分功能不能正常使用，推荐使用Chrome！");
    };
}
environmentalVRY();
