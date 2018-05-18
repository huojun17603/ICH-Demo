$(function(){
	$("#treegrid").treegrid({
		url:noteclassListUrl,
		border:false,
		fit:true,
		rownumbers:true,
		idField:"id",
		treeField:"id",
		columns:[[
			{field:'id',title:'编号'},
			{field:'name',title:'名称'},
			{field:'remark',title:'备注'}
		]],
		toolbar:'#tool'
	});
	
});
function openWindowWithB(){
	var node = $("#treegrid").treegrid('getSelected');
	var pid = null;
	if(node != null){
		pid = node.pid;
	}
	$('#applyForm').form('clear');
	$('#applyForm').form('load',{
		pid:pid
    });
	$('#window').window('open');
	$('#window').window('center');	
}

function openWindowWithS(){
	var node = $("#treegrid").treegrid('getSelected');
	if(node == null){
		$.messager.alert("提示框","请选择一条记录！");
		return;
	}
	var pid = node.id;
	$('#applyForm').form('clear');
	$('#applyForm').form('load',{
		pid:pid
    });
	$('#window').window('open');
	$('#window').window('center');	
}


function openWindowWithU(){
	var node = $("#treegrid").treegrid('getSelected');
	if(node == null){
		$.messager.alert("提示框","请选择一条记录！");
		return;
	}
	$('#applyForm').form('clear');
	$('#applyForm').form('load',{
		id:node.id,
		pid:node.pid,
		name:node.name,
		remark:node.remark
    });
	$('#window').window('open');
	$('#window').window('center');	
}


function submitForm(){
	if(!$("#applyForm").form('validate'))return;
 	$.ajax({
	    url:noteclassSaveOrUpdateUrl,
	    data:$("#applyForm").serialize(),
	    success: function (data){
	    	if(data.status==0){
				$('#treegrid').treegrid('reload');
				$('#window').window('close');
				$.messager.alert("提示框","完成操作请求！");
            }else if(data.status==1){
            	$.messager.alert("错误",data.msg,'warning');
            }else if(data.status==3){
            	$.messager.alert("警告","无权访问",'warning');
            }
	    }
 	});
 	clearForm();
 	$('#window').window('close');
}


function clearForm(){
	$('#window').window('close');
}

function delClass(){
	var node = $("#treegrid").treegrid('getSelected');
	if(node == null){
		$.messager.alert("提示框","请选择一条记录！");
		return;
	}
	$.messager.confirm('删除提示', '注意只能删除其下没有文章的分类！你确定要删除这个分类吗？', function(r){
		if(r){
			$.ajax({
				url:noteclassDeleteUrl,
				data:{id:node.id},
				success: function (data) {
	            	if(data.status==0){
						$('#treegrid').treegrid('reload');
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