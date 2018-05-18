$(function(){
	$("#datagrid").datagrid({
		url:basePath + employeeList,
		border:false,
		striped:true,
	    fit:true,
	    pageSize:50,
	    pageList:[50,100],
	    idField:'id',
	    loadMsg:'加载中……',
	    rownumbers:true,//序号
	    pagination:true,//显示底部分页工具栏
	    singleSelect:true,//单选
		columns:[[
		          {field:'logincode',title:'登录账号',align:"center",width:150},
		          {field:'name',title:'姓名',align:"center",width:80},
		          {field:'positionName',title:'职位',align:"center",width:120},
		          {field:'orgName',title:'组织机构',align:"center",width:200},
		          {field:'phone',title:'绑定手机号',align:"center",width:120 },
		          {field:'email',title:'绑定电子邮箱',align:"center",width:200},
		          {field:'status',title:'状态',align:"center",width:80,formatter:initStatus},
		          {field:'id',title:'操作项',align:"center",width:150,formatter:initOp}
		]],
		toolbar:'#tool'
	});
	
	function initStatus(value,row,index){
		return value==1?"<span class='gd'>已启用</span>":"<span class='rd'>已禁用</span>";
	}
	
	function initOp(value,row,index){
		return row.status
				?'<button style="color:red" onclick="disable(\''+row.id+'\')">禁用</button>'
				:'<button style="color:green" onclick="able(\''+row.id+'\')">启用</button>';
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
		valueField:'id',
		textField:'orgName',
		animate:true,
	    lines:true,
		onSelect: function(node){
			$('#positionId_input').combobox({
			    url:basePath + positionList + "?orgId=" + node.id,
			    valueField:'id',
			    textField:'name'
			});
		}
	});
});

function openQuickWindow(){
    isave = 1;
    $('#logincode_input').validatebox("enable");
    $('#loginkey_input').validatebox("enable");
	$('#employee_apply_form').form("clear");
	$('#employee_apply_window').window('open');
	$('#employee_apply_window').window('center');
}

function openQuickEditWindow(){
	var row = $('#datagrid').datagrid('getSelected');
	if(isEmpty(row)){
		$.messager.alert("提示框","请选择一条数据记录！");
		return ;
	}
    isave = 2;
    $('#logincode_input').validatebox("disable");
    $('#loginkey_input').validatebox("disable");
	$('#employee_apply_form').form("clear");
	$('#orgId_input').combotree('tree').tree('expandAll');
	$('#positionId_input').combobox({
	    url:basePath + positionList + "?orgId=" + row.orgId,
	    valueField:'id',
	    textField:'name'
	});
	$("#employee_apply_form").form("load",{
		id:row.id,
		orgId:row.orgId,
		positionId:row.positionId,
        logincode:row.logincode,
		name:row.name,
		phone:row.phone,
		email:row.email
	});
	$('#employee_apply_window').window('open');
	$('#employee_apply_window').window('center');	
}

function closedWindow(){
	$('#employee_apply_window').window('close');
}

function addEmployee(){
	var url = "";
	if(isave==1){
        url = basePath+employeeQuick;
	}else{
        url = basePath+employeeUpdate;
	}
	if(!$('#employee_apply_form').form("validate")) return;
	$.ajax({
        url: url,
        data: $('#employee_apply_form').serialize(),
        success: function(data){
            if(data.status==0){
            	$('#datagrid').datagrid('reload');
            	$('#employee_apply_window').window('close');
            	$.messager.alert("提示框","完成操作请求！");
            }else if(data.status==1){
            	$.messager.alert("错误",data.msg,'warning');
            }else if(data.status==3){
            	$.messager.alert("警告","无权访问",'warning');
            }
        }
    });
}

function able(id){
	$.ajax({
	    url:basePath+employeeAble,
	    data:{id:id},
	    success: function (data){
	    	if(data.status==0){
				$.messager.alert("提示框","完成操作请求！");
				$('#datagrid').datagrid('reload');
	    	}else if(data.status==1){
            	$.messager.alert("错误",data.msg,'warning');
            }else if(data.status==3){
            	$.messager.alert("警告","无权访问",'warning');
            }
	    }
 	});
}

function disable(id){
	$.ajax({
	    url:basePath+employeeDisable,
	    data:{id:id},
	    success: function (data){
	    	if(data.status==0){
				$.messager.alert("提示框","完成操作请求！");
				$('#datagrid').datagrid('reload');
	    	}else if(data.status==1){
            	$.messager.alert("错误",data.msg,'warning');
            }else if(data.status==3){
            	$.messager.alert("警告","无权访问",'warning');
            }
	    }
 	});
}

function restkey(){
    var row = $('#datagrid').datagrid('getSelected');
    if(isEmpty(row)){
        $.messager.alert("提示框","请选择一条数据记录！");
        return ;
    }
    $.ajax({
        url:basePath+restkeyurl,
        data:{id:row.id},
        success: function (data){
            if(data.status==0){
                $.messager.alert("提示框","完成操作请求！");
                $('#datagrid').datagrid('reload');
            }else if(data.status==1){
                $.messager.alert("错误",data.msg,'warning');
            }else if(data.status==3){
                $.messager.alert("警告","无权访问",'warning');
            }
        }
    });
}

function selectAccount(){
	var property={
		title:"请选择登录账号",
		dataUrl:effectiveAccount,//数据连接
		singleSelect:false,//单选/多选
		searchPrompt:"请输入关键字",//搜索提示
		columns:[[
		          {field:'code',title:'用户编码',align:"center",width:200},
		          {field:'createTime',title:'注册时间',align:"center",width:200}
		    ]],
		searchCall:function(dg,value){//搜索值回调
			dg.datagrid('reload',{searchKey:value});
		},
		callback:function(data){//选择值回调
			var ids=[];
			var names = [];
			$.each(data, function(index, item){
				ids.push(item.id);
				names.push(item.code);
			});               
			$('#accountId_input').val(ids.join(","));
			$('#accountCode_input').val(names.join(","));	
		}
	};
	$.createSelector($("#selector"),property);

}
