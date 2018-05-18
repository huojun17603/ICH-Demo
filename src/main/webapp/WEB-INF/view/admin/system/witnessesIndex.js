$(function(){
	$("#datagrid").datagrid({
		url:basePath + witnessesListUrl,
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
			{field:'wname',title:'被举报人',align:"center",width:150},
			{field:'reason',title:'举报理由',align:"center",width:500,formatter: formatterTitle},
			{field:'createtime',title:'举报时间',align:"center",width:150,formatter: formatterTime},
            {field:'aname',title:'举报人',align:"center",width:150},
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

    $("#d_datagrid").datagrid({
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
            {field:'wname',title:'被举报人',align:"center",width:150},
            {field:'reason',title:'举报理由',align:"center",width:500,formatter: formatterTitle},
            {field:'createtime',title:'举报时间',align:"center",width:150,formatter: formatterTime},
            {field:'aname',title:'举报人',align:"center",width:150}
        ]],
        toolbar:'#d_tool',
        onLoadSuccess:function(){
            $("#datagrid").datagrid('scrollTo',0);
        }
    });
});

function openDWin(){
    var row = $("#datagrid").datagrid("getSelected");
    if(isEmpty(row)){
        $.messager.alert("提示消息",'请选择一条记录！');
        return ;
    }
    if(row.status == 1){
        $.messager.alert("提示框","此记录已完成处理！");
        return;
    }
    $("#d_datagrid").datagrid({
        url: basePath + witnessesDListUrl + "?wid=" + row.wid
    });
    $('#dwindow').window('open');
    $('#dwindow').window('center');
}


function openHandleWin(){
    var row = $('#datagrid').datagrid('getSelected');
    if(row == null){
        $.messager.alert("提示框","请选择一条记录！");
        return;
    }
    $('#applyForm').form('clear');
    $('#applyForm').form('load',{
        wid:row.wid,
        wname:row.wname
    });
    $('#window').window('open');
    $('#window').window('center');
}


function handle(){
 	$.ajax({
	    url:witnessesHandleUrl,
	    data:$("#applyForm").serialize(),
	    success: function (data){
	    	if(data.status==0){
	    		$('#datagrid').datagrid('reload');
                $('#dwindow').window('close');
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

function closeWin(){
	$('#window').window('close');
}

function doSearch(){
	var searchkey = $("#sk_searchkey").val();
    $("#datagrid").datagrid("reload",{"wname":searchkey});
}
