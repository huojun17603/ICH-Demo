$(function(){
	$("#datagrid").treegrid({
		url:basePath + organizationList,
		border:false,
	    fit:true,
	    rownumbers:true,
	    idField:'id',
	    treeField:"orgName",
		columns:[[
		          {field:'parentId',title:'parentId',hidden:true},
		          {field:'orgName',title:'机构名称',width:250},
		          {field:'leaderName',title:'领导',align:"center",width:150 },
		          {field:'deputyLeaderName',title:'副领导',align:"center",width:150}
		]],
		toolbar:'#tool'
	});
	
	function initIsAbleHandle(value,row,index){
		return value?"通过":"未通过";
	}
	
	
	$('#parentId_input').combotree({
		url:basePath + organizationTree,
		animate:true,
	    lines:true,
		valueField:'id',
		textField:'orgName'
	});
	
});

/** 员工模糊查询加载器 */
var emploader = function(param,success,error){
    var q = param.q || '';
    if (q.length < 2){return false}
    $.ajax({
        url: employeList,
        dataType: 'json',
        data: {
        	name: q
        },
        success: function(data){
            var items = $.map(data, function(item,index){
                return {
                    id: item.id,
                    name: item.name
                };
            });
            success(items);
        },
        error: function(){
            error.apply(this, arguments);
        }
    });
}

//
function addOrgWindow(){
	$('#organization_save_form').form("clear");
	$('#organization_save_window').window('open');
	$('#organization_save_window').window('center');	
}

function editOrgWindow(){
	var row = $('#datagrid').datagrid('getSelected');
	if(isEmpty(row)){
		$.messager.alert("提示框","请选择一条数据记录！");
		return ;
	}
	$('#parentId_input').combotree('tree').tree('expandAll');
	$("#organization_save_form").form("load",{
		id:row.id,
		parentId:row.parentId,
		orgName:row.orgName,
		leader:row.leader,
		leaderName:row.leaderName,
		deputyLeader:row.deputyLeader,
		deputyLeaderName:row.deputyLeaderName,
	});
	$('#organization_save_window').window('open');
	$('#organization_save_window').window('center');	
}

function removeOrg(){
	var row = $('#datagrid').datagrid('getSelected');
	if(isEmpty(row)){
		$.messager.alert("提示框","请选择一条数据记录！");
		return ;
	}
	$.messager.confirm('删除提示', '<font color="red">警告：删除组织机构信息可能会导致其他使用到其数据的功能模块无法运行！是否继续?</font>', function(r){
		if (r){
			$.ajax({
		        url: basePath+organizationDelete,
		        data: {id:row.id},
		        success: function(data){
		            if(data.status==0){
			    		$('#datagrid').treegrid('reload');
			    		$('#parentId_input').combotree('reload');
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

function addOrg(){
	if(!$('#organization_save_form').form("validate")) return;
	$.ajax({
        url: basePath+organizationInsert,
        data: $('#organization_save_form').serialize(),
        success: function(data){
            if(data.status==0){
	    		$('#datagrid').treegrid('reload');
	    		$('#parentId_input').combotree('reload');
            	$('#organization_save_window').window('close');
            	$.messager.alert("提示框","完成操作请求！");
            }else if(data.status==1){
            	$.messager.alert("错误",data.msg,'warning');
            }else if(data.status==3){
            	$.messager.alert("警告","无权访问",'warning');
            }
        }
    });
}

function closedOrgWindow(){
	$('#organization_save_window').window('close');
}

function selectLeader(){
	var property={
		title:"请选择领导",
		width:800,
		height:400,
		dataUrl:employequery,//数据连接
		singleSelect:false,//单选/多选
		toolbar:null,
		columns:[[
				{field:'accountCode',title:'系统编号'},
				{field:'name',title:'姓名'},
				{field:'positionName',title:'职位'},
				{field:'orgName',title:'组织机构'},
				{field:'phone',title:'绑定手机号'},
				{field:'email',title:'绑定电子邮箱'}
		    ]],
	    searchCall:function(dg,value){
			dg.datagrid('reload',{name:value});
		},
	    callback:function(data){
	    	var ids=[];
			var names = [];
			$.each(data, function(index, item){
				ids.push(item.id);
				names.push(item.name);
			});               
			$('#leader_input').val(ids.join(","));
			$('#leaderName_input').val(names.join(","));	
		}
	};
	$.createSelector($("#selector"),property);
}

function selectDeputyLeader(){
	var property={
		title:"请选择副领导",
		dataUrl:employequery,//数据连接
		singleSelect:false,//单选/多选
		searchPrompt:"请输入关键字",
		columns:[[
				{field:'accountCode',title:'系统编号'},
				{field:'name',title:'姓名'},
				{field:'positionName',title:'职位'},
				{field:'orgName',title:'组织机构'},
				{field:'phone',title:'绑定手机号'},
		    ]],
		searchCall:function(dg,value){
			dg.datagrid('reload',{name:value});
		},
		callback:function(data){
			var ids=[];
			var names = [];
			$.each(data, function(index, item){
				ids.push(item.id);
				names.push(item.name);
			});               
			$('#deputyLeader_input').val(ids.join(","));
			$('#deputyLeaderName_input').val(names.join(","));	
		}
	};
	$.createSelector($("#selector"),property);
}

