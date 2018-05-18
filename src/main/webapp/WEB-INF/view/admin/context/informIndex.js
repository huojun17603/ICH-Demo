$(function(){
	$("#datagrid").datagrid({
		url:basePath + informList,
		border:false,
		striped:true,
	    fit:true,
	    idField:'id',
	    loadMsg:'加载中……',
	    rownumbers:true,//序号
	    singleSelect:true,//单选
	    columns:[[
	              {field:'id',title:'id',hidden:true},
		          {field:'info',title:'内容',width:800},
		          {field:'createtime',title:'创建时间',width:150,formatter:formatterTime},
                  {field:'endtime',title:'到期时间',width:150,formatter:formatterTime}

		]],
        rowStyler: function(index,row){
            var timestamp = Date.parse(new Date());
            if (row.endtime<=timestamp){
                return "color:#D4D4D4;";
            }
        },
		toolbar:'#tool',
		onLoadSuccess:function(){
			$("#datagrid").datagrid('scrollTo',0);
		}
	});
});

function openAddWindow() {
    $('#apply_form').form("clear");
    $('#apply_window').window('open');
    $('#apply_window').window('center');
}

function openEditWindow(index){
	$('#apply_form').form("clear");
	var row = $("#datagrid").datagrid("getSelected");
	if(isEmpty(row)){
		$.messager.alert("提示消息",'请选择一条记录！');
		return ;
	}
	$("#apply_form").form("load",{
        id:row.id,
        info:row.info,
        etime:formatterTime(row.endtime)
	});
	$('#apply_window').window('open');
	$('#apply_window').window('center');
}

function closeWindow(){
	$('#apply_window').window('close');
}

function applyEdit(){
	$.ajax({
        url: basePath+informAddOrEdit,
        data: $('#apply_form').serialize(),
        success: function(data){
            if(data.status==0){
            	$('#datagrid').datagrid('reload');
            	$('#apply_window').window('close');
            	$.messager.alert("提示框","完成操作请求！");
            }else if(data.status==1){
            	$.messager.alert("错误",data.msg,'warning');
            }else if(data.status==3){
            	$.messager.alert("警告","无权访问",'warning');
            }
        }
    });
}
function cancelInform(){
    var node = $("#datagrid").datagrid('getSelected');
    if(node == null){
        $.messager.alert("提示框","请选择一条记录！");
        return;
    }
    $.messager.confirm('取消提示', '你确定要让这个公告过期吗？', function(r){
        if(r){
            $.ajax({
                url:informCancel,
                data:{id:node.id},
                success: function (data) {
                    if(data.status==0){
                        $("#datagrid").datagrid('reload');
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
function deleteInform(){
    var node = $("#datagrid").datagrid('getSelected');
    if(node == null){
        $.messager.alert("提示框","请选择一条记录！");
        return;
    }
    $.messager.confirm('删除提示', '你确定要删除这个公告吗？', function(r){
        if(r){
            $.ajax({
                url:informDelete,
                data:{ids:node.id},
                success: function (data) {
                    if(data.status==0){
                        $("#datagrid").datagrid('reload');
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
function doSearch(searchkey){
	var sk_type = $("#sk_type").combobox("getValue");
	if(sk_type=='类型（全部）')sk_type = null;
	$("#datagrid").datagrid("reload",{searchkey:searchkey,type:sk_type});
}
