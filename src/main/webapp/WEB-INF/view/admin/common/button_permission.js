/**
 * 页面按钮权限自动识别脚本
 * 作者：霍俊
 * 描述：通过admin/employeeGetButtonWithMenu链接获取当前用户在此页面的权限信息。并显示可操作的按钮
 * 要求：页面及链接信息必须在系统资源管理注册，页面必须引入此脚本，页面按钮必须有data-permission属性并且属性值为注册的资源链接编码
 */
function initPermissionButton(){
	var href = window.location.href; 
	var view = href.substring(href.lastIndexOf("/")+1,href.length);
	$.ajax({
        url: basePath+"admin/employeeGetButtonWithMenu",
        data: {MenuCode:view},
        success: function(data){
            if(data.status==0){
            	var permissions = data.data.split(",");
            	$("input").each(function(){
            		var data_permission = $(this).attr("data-permission");
                    if(!isEmpty(data_permission)){
                    	var result = $.inArray(data_permission , permissions);
                        if(result==-1) $(this).hide();
                    }
                }); 
            	$("a").each(function(){
                    var data_permission = $(this).attr("data-permission");
                    if(!isEmpty(data_permission)){
                    	var result = $.inArray(data_permission , permissions);
                        if(result==-1) $(this).hide();
                    }
                }); 
            	$("button").each(function(){
                    var data_permission = $(this).attr("data-permission");
                    if(!isEmpty(data_permission)){
                    	var result = $.inArray(data_permission , permissions);
                        if(result==-1) $(this).hide();
                    }
                }); 
            }else if(data.status==1){
            	$.messager.alert("错误",data.msg,'warning');
            }else if(data.status==3){
            	$.messager.alert("警告","无权访问",'warning');
            }
        }
    });
	
}