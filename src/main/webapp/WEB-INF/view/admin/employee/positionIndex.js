$(function(){
	$("#datagrid").datagrid({
		url:basePath+positionQuery,
		border:false,
	    fit:true,
	    rownumbers:true,
	    singleSelect:true,//单选
		columns:[[
		          {field:'name',title:'职位名称',align:"center",width:150},
		          {field:'orgName',title:'所属机构',align:"center",width:200},
		          {field:'permissionOrgId',title:'数据权限',width:400,formatter:initPermissionOrgId},
		          {field:'id',title:'菜单（窗口）权限操作项',width:220,formatter:initOp}
		]],
		toolbar:'#tool'
	});
	
	function initPermissionOrgId(value,row,index){
		var result = "";
		if(!isEmpty(value)){
			result += "拥有【"+row.permissionOrgName+"】下所有数据权限！";
		}
		return result;
	}
	
	function initOp(value,row,index){
		return '<button style="color:green" onclick="openMenuConfig(\''+row.id+'\')">配置菜单权限</button>'
				+'&nbsp;&nbsp;'
				+'<button style="color:green" onclick="openWindowConfig(\''+row.id+'\')">配置窗口权限</button>';
	}
	
	
	$("#positionMenu_treegrid").treegrid({
	    fit:true,
	    border:false,
	    idField:'menuCode',
	    treeField:"menuName",
		columns:[[
		          {field:'menuName',title:'名称',width:200},
		          {field:'menuType',title:'类型',align:"center",width:80,formatter:initType},
		          {field:'positionId',title:'配置权限',width:400,formatter:initMenuPower}
		]],
	});
	
	$("#positionWindow_datagrid").datagrid({
		border:false,
	    fit:true,
	    rownumbers:true,
	    singleSelect:true,//单选
		columns:[[
		          {field:'name',title:'名称',width:150},
		          {field:'positionId',title:'配置权限',width:250,formatter:initWindowPower}
		]],
	});
	
	function initWindowPower(value,row,index){
		var o = "";
		if(row.isRead){
			o += '<input id="isRead_'+row.windowCode+'" type="checkbox" checked="checked"  onchange="setWindowPower(\''+row.windowCode+'\')">查看</input>';
		}else{
			o += '<input id="isRead_'+row.windowCode+'" type="checkbox" onchange="setWindowPower(\''+row.windowCode+'\')">查看</input>';
		}
		return o;
	}
	
	function initType(value,row,index){
		if(value==2){
			return "菜单";
		}else{
			return "目录";
		}
	}
	
	function initMenuPower(value,row,index){
		var o = "";
		if(row.isRead){
			o += '<input id="isRead_'+row.menuCode+'" type="checkbox" checked="checked"  onchange="setPower(\''+row.menuCode+'\')">查看</input>&nbsp;&nbsp;';
		}else{
			o += '<input id="isRead_'+row.menuCode+'" type="checkbox" onchange="setPower(\''+row.menuCode+'\')">查看</input>&nbsp;&nbsp;';
		}
		if(row.menuType==2){
			if(row.isWrite){
				o += '<input id="isWrite_'+row.menuCode+'" type="checkbox"  checked="checked"  onchange="setPower(\''+row.menuCode+'\')">新增</input>&nbsp;&nbsp;';
			}else{
				o += '<input id="isWrite_'+row.menuCode+'" type="checkbox" onchange="setPower(\''+row.menuCode+'\')">新增</input>&nbsp;&nbsp;';
			}
			if(row.isEdit){
				o += '<input id="isEdit_'+row.menuCode+'" type="checkbox" checked="checked" onchange="setPower(\''+row.menuCode+'\')">修改</input>&nbsp;&nbsp;';
			}else{
				o += '<input id="isEdit_'+row.menuCode+'" type="checkbox" onchange="setPower(\''+row.menuCode+'\')" >修改</input>&nbsp;&nbsp;';
			}
			if(row.isAudit){
				o += '<input id="isAudit_'+row.menuCode+'" type="checkbox" checked="checked" onchange="setPower(\''+row.menuCode+'\')">审核</input>&nbsp;&nbsp;';
			}else{
				o += '<input id="isAudit_'+row.menuCode+'" type="checkbox" onchange="setPower(\''+row.menuCode+'\')">审核</input>&nbsp;&nbsp;';
			}
			if(row.isDelete){
				o += '<input id="isDelete_'+row.menuCode+'" type="checkbox" checked="checked" onchange="setPower(\''+row.menuCode+'\')">删除</input>&nbsp;&nbsp;';
			}else{
				o += '<input id="isDelete_'+row.menuCode+'" type="checkbox" onchange="setPower(\''+row.menuCode+'\')">删除</input>&nbsp;&nbsp;';
			}
		}
		return o;
	}

	
	$('#org_tree').tree({
	    url:basePath+organizationTree,
	    animate:true,
	    lines:true,
	    onClick:function(node){
	    	$("#datagrid").datagrid("load",{orgId:node.id});
		}
	});
	
	$('#orgId_input').combotree({
		url:basePath + organizationTree,
		animate:true,
	    lines:true,
		valueField:'id',
		textField:'orgName'
	});
	
	$('#permissionOrgId_input').combotree({
		url:basePath + organizationTree,
		animate:true,
	    lines:true,
		valueField:'id',
		textField:'orgName'
	});
});

function openPositionWindow(){
	$('#position_save_form').form("clear");
	$('#position_save_window').window('open');
	$('#position_save_window').window('center');	
}

function editPositionWindow(){
	var row = $('#datagrid').datagrid('getSelected');
	if(isEmpty(row)){
		$.messager.alert("提示框","请选择一条数据记录！");
		return ;
	}
	$('#orgId_input').combotree('tree').tree('expandAll');
	$('#permissionOrgId_input').combotree('tree').tree('expandAll');
	$("#position_save_form").form("load",{
		id:row.id,
		orgId:row.orgId,
		name:row.name,
		permissionOrgId:row.permissionOrgId
	});
	$('#position_save_window').window('open');
	$('#position_save_window').window('center');	
}

function removePosition(){
	var row = $('#datagrid').datagrid('getSelected');
	if(isEmpty(row)){
		$.messager.alert("提示框","请选择一条数据记录！");
		return ;
	}
	$.messager.confirm('删除提示', '<font color="red">警告：删除职位信息会导致其权限失效，是否继续?</font>', function(r){
		if (r){
			$.ajax({
		        url: basePath+positionDelete,
		        data: {id:row.id},
		        success: function(data){
		            if(data.status==0){
		            	$('#datagrid').datagrid('reload');
		            	$.messager.alert("提示框","完成操作请求！");
		            }else if(data.status==1){
		            	$.messager.alert("错误",data.msg,'warning');
		            }else if(data.status==3){
		            	$.messager.alert("警告","无权访问",'warning');
		            }
		        }
		    });
		}
	});
	
}

function addPosition(){
	if(!$('#position_save_form').form("validate")) return;
	$.ajax({
        url: basePath+positionInsert,
        data: $('#position_save_form').serialize(),
        success: function(data){
            if(data.status==0){
            	$('#datagrid').datagrid('reload');
            	$('#position_save_window').window('close');
            	$.messager.alert("提示框","完成操作请求！");
            }else if(data.status==1){
            	$.messager.alert("错误",data.msg,'warning');
            }else if(data.status==3){
            	$.messager.alert("警告","无权访问",'warning');
            }
        }
    });
}

function closedPositionWindow(){
	$('#position_save_window').window('close');
}

function openMenuConfig(id){
	$("#positionMenu_treegrid").treegrid({
		url:basePath+positionMenuPermission+"?id="+id
	});
	positionId = id;
	$('#positionMenu_save_window').window('open');
	$('#positionMenu_save_window').window('center');
	
}


function openWindowConfig(id){
	$("#positionWindow_datagrid").datagrid({
		url:basePath + positionWindowPermission+"?id="+id
	});
	positionId = id;
	$('#positionWindow_save_window').window('open');
	$('#positionWindow_save_window').window('center');
}


function setPower(mc){
	var data = {menuCode:mc,positionId:positionId,isRead:false,isWrite:false,isEdit:false,isAudit:false,isDelete:false};
	if(!isEmpty($("#isRead_"+mc)))data.isRead = $("#isRead_"+mc).prop("checked");
	if(!isEmpty($("#isWrite_"+mc)))data.isWrite = $("#isWrite_"+mc).prop("checked");
	if(!isEmpty($("#isEdit_"+mc)))data.isEdit = $("#isEdit_"+mc).prop("checked");
	if(!isEmpty($("#isAudit_"+mc)))data.isAudit = $("#isAudit_"+mc).prop("checked");
	if(!isEmpty($("#isDelete_"+mc)))data.isDelete = $("#isDelete_"+mc).prop("checked");
	
	$.ajax({
	    url: basePath+positionSaveMenuPermission,
	    data: data,
	    success: function(data){
	        if(data.status==0){
	        }else if(data.status==1){
	        	$("#positionMenu_treegrid").treegrid("reload");
	        	$.messager.alert("错误",data.msg,'warning');
	        }else if(data.status==3){
	        	$.messager.alert("警告","无权访问",'warning');
	        }
	    }
	});
}

function setWindowPower(wc){
	var data = {windowCode:wc,positionId:positionId,isRead:false};
	if(!isEmpty($("#isRead_"+wc)))data.isRead = $("#isRead_"+wc).prop("checked");
	$.ajax({
	    url: basePath+positionSaveWindowPermission,
	    data: data,
	    success: function(data){
	        if(data.status==0){
	        }else if(data.status==1){
	        	$("#positionWindow_datagrid").datagrid("reload");
	        	$.messager.alert("错误",data.msg,'warning');
	        }else if(data.status==3){
	        	$.messager.alert("警告","无权访问",'warning');
	        }
	    }
	});
}