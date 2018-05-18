$(function(){
	/***************************TABS MENU 定义*********************************/
	/*为选项卡绑定右键*/
   // $(".tabs li").live('contextmenu',function(e){
   //
   //     /* 选中当前触发事件的选项卡 */
   //     var subtitle =$(this).text();
   //     $('#home_tabs').tabs('select',subtitle);
   //
   //     //显示快捷菜单
   //     $('#menu').menu('show', {
   //         left: e.pageX,
   //         top: e.pageY
   //     });
   //
   //     return false;
   // });
   // //关闭所有
   // $("#m-closeall").click(function(){
   //     $(".tabs li").each(function(i, n){
   //         var title = $(n).text();
   //         if(title!="首页")
   //         $('#home_tabs').tabs('close',title);
   //     });
   // });
   //
   // //除当前之外关闭所有
   // $("#m-closeother").click(function(){
   //     var currTab = $('#home_tabs').tabs('getSelected');
   //     currTitle = currTab.panel('options').title;
   //
   //     $(".tabs li").each(function(i, n){
   //         var title = $(n).text();
   //         if(currTitle != title&&title !="首页"){
   //             $('#home_tabs').tabs('close',title);
   //         }
   //     });
   // });
   //
   // //关闭当前
   // $("#m-close").click(function(){
   //     var currTab = $('#home_tabs').tabs('getSelected');
   //     currTitle = currTab.panel('options').title;
   //     if(currTitle!="首页") {
   //     	$('#home_tabs').tabs('close', currTitle);
   //     }
   // });
    /************************************************************/
    //关闭第一个默认展开的面板
   
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
		  				var b = $('#home_tabs').tabs('exists',node.text);
		  				if(b){
		  					$('#home_tabs').tabs('close',node.text);
		  				}
						$('#home_tabs').tabs('add',{ 
							title:node.text,
							content:"<iframe frameborder='0' style='width: 100%;height: 100%' src='"+basePath+"admin/view/"+node.id+"'></iframe>",
							closable:true 
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

function openEditWin(){
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
