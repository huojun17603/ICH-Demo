$(function(){
	$("#datagrid").datagrid({
		url:basePath + feedbackListUrl,
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
			{field:'id',title:'id',hidden:true},
			{field:'username',title:'反馈人',align:"center",width:150},
			{field:'contact',title:'联系方式',align:"center",width:150},
			{field:'context',title:'反馈内容',align:"center",width:300,formatter: formatterTitle},
			{field:'createtime',title:'创建时间',align:"center",width:200,formatter:formatterTime},
            {field:'status',title:'状态',align:"center",width:100,
                formatter: function(value,row,index){
                    switch (value) {
                        case 0:return "<font color='red'>未处理</font>";
                        case 1:return "<font color='green'>已处理</font>";
                        default:
                            break;
                    }
                }
            },
            {field:'handlername',title:'处理人',align:"center",width:150},
            {field:'handletime',title:'处理时间',align:"center",width:200,formatter:formatterTime},
			{field:'handlermark',title:'处理说明',align:"center",width:200,formatter: formatterTitle}
		]],
		toolbar:'#tool',
		onLoadSuccess:function(){
			$("#datagrid").datagrid('scrollTo',0);
            initPermissionButton();
		}
	});
	
});

function openHandleWin(){
    var row = $('#datagrid').datagrid('getSelected');
    if(row == null){
        $.messager.alert("提示框","请选择一条记录！");
        return;
    }
    if(row.status == 1){
        $.messager.alert("提示框","此记录已完成处理！");
        return;
    }
	$('#applyForm').form('clear');
    $('#applyForm').form('load',{
        id:row.id,
        username:row.username,
        contact:row.contact,
        context:row.context,
        createtime:formatterTime(row.createtime)
    });
	$('#window').window('open');
	$('#window').window('center');	
}

function handle(){
 	$.ajax({
	    url:feedbackHandleUrl,
	    data:$("#applyForm").serialize(),
	    success: function (data){
	    	if(data.status==0){
	    		$('#datagrid').datagrid('reload');
                $('#window').window('close');
				$.messager.alert("提示框","完成操作请求！");
            }else if(data.status==1){
            	$.messager.alert("错误",data.msg,'warning');
            }else if(data.status==3){
            	$.messager.alert("警告","无权访问",'warning');
            }
	    }
 	});
}

function closeHandleWin(){
	$('#window').window('close');
}


function doSearch(){
	var searchkey = $("#sk_searchkey").val();
    $("#datagrid").datagrid("reload",{"searchkey":searchkey});
}
