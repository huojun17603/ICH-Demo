$(function(){

   
	$('#ac').accordion({
		onSelect:function(title,index){
			index = index - 1;
			var id = $('#menuId_'+index).val();
			$('#user_menu_'+index).tree({
			    url:userMenuList+"?mid="+id,
			    animate:true,
			    lines:true,
			    onClick:function(node){
		  			if(node.attributes!=undefined&&node.attributes!=null){

                        $('#home_panel').panel({
                            content : "<iframe frameborder='0' style='width: 100%;height: 100%' src='"+basePath+"admin/view/"+node.id+"'></iframe>"
                        });
		  			}else{
		  				$('#user_menu').tree('expand',node.target);
		  			}
				}
			});
		}
	});
	var ha = $('#ac').accordion('getPanel',0);	//获取第一个面板
	$(ha).panel({
		closed:true	//初始化默认关闭
	});
	
});
//关闭第一个默认展开的面板

function openEditWinx(){
    ASSSS();
	$('#edit_form').form("clear");
	$('#edit_window').window('open');
	$('#edit_window').window('center');
}

function applyEdit(){
	$.ajax({
	    url:basePath+"admin/home/editkey",
	    data: $('#edit_form').serialize(),
	    success: function (data){
	    	if(data.status==0){
            	$('#edit_window').window('close');
				$.messager.alert("提示框","完成操作请求！");
	    	}else if(data.status==1){
            	$.messager.alert("错误",data.msg,'warning');
            }else if(data.status==3){
            	$.messager.alert("警告","无权访问",'warning');
            }
	    }
 	});
}

function closeEditWin(){
	$('#edit_window').window('close');
}
