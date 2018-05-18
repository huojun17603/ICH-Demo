<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<link rel="stylesheet" type="text/css" href="<%=basePath%>script/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>script/easyui/themes/color.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>script/easyui/themes/bootstrap/easyui.css">
<!-- 注意定义的先后顺序 -->
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/index.css">
<script type="text/javascript" src="<%=basePath%>script/common/jquery.min.js"></script>
<script type="text/javascript" src="<%=basePath%>script/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=basePath%>script/easyui/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=basePath%>view/admin/common/selector.js"></script>
<script type="text/javascript" src="<%=basePath%>view/admin/common/imger.js"></script>
<script type="text/javascript" src="<%=basePath%>view/admin/common/button_permission.js"></script>

<script>
	var basePath = "<%=basePath%>";
	function isEmpty(obj){
    if(obj==undefined||obj==null||obj===""){
        return true;
    }
        return false;
	}
	function img_error(obj){
	$(obj).attr('src','<%=basePath %>images/logo.gif')
	}
	//*************************************************************************//
	//*****************************设置ajax请求全局默认设置***************************//
	//*************************************************************************//
	$.ajaxSetup({
	async:true,
	error:function(jqXHR, textStatus, errorThrown){
	var msg = $.parseJSON(jqXHR.responseText).error;
	$.messager.alert('系统错误',msg,'error');
	CLOSE_MESSAGER_PROGRESS();
	},
	traditional : true,
	dataType : "json",
	type : "POST"
	});
	function fmoney(s, n)
	{
	n = n > 0 && n <= 20 ? n : 2;
	s = parseFloat((s + "").replace(/[^\d\.-]/g, "")).toFixed(n) + "";
	var l = s.split(".")[0].split("").reverse(),
	r = s.split(".")[1];
	t = "";
	for(i = 0; i < l.length; i ++ )
	{
	t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? "," : "");
	}
	return t.split("").reverse().join("") + "." + r;
	}
	Date.prototype.format = function(format) {
	var date = {
	"M+": this.getMonth() + 1,
	"d+": this.getDate(),
	"h+": this.getHours(),
	"m+": this.getMinutes(),
	"s+": this.getSeconds(),
	"q+": Math.floor((this.getMonth() + 3) / 3),
	"S+": this.getMilliseconds()
	};
	if (/(y+)/i.test(format)) {
	format = format.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
	}
	for (var k in date) {
	if (new RegExp("(" + k + ")").test(format)) {
	format = format.replace(RegExp.$1, RegExp.$1.length == 1
	? date[k] : ("00" + date[k]).substr(("" + date[k]).length));
	}
	}
	return format;
	}
	function formatterTime(value,row,index){
	    if(isEmpty(value))return "";
	    var date = new Date(value);
	    return date.format('yyyy-MM-dd hh:mm:ss');
	}
	function formatterTitle(value,row,index){
		if(value)
			return "<div title='"+value+"'>"+value+"</div>";
		return "";
	}
	function OPEN_MESSAGER_PROGRESS(title,msg){
	    $.messager.progress({
            title:(title?title:'进行中……'),
            msg:(msg?msg:'正在处理，请稍等……')
        });
	}
	function CLOSE_MESSAGER_PROGRESS(){
	    $.messager.progress('close');
	}
</script>
