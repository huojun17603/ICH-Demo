$(function(){
	$("#datagrid").datagrid({
		url:basePath + advList,
		border:false,
		striped:true,
	    fit:true,
	    idField:'id',
	    loadMsg:'加载中……',
	    rownumbers:true,//序号
	    pagination:true,//显示底部分页工具栏
	    singleSelect:true,//单选
	    view:groupview,
        groupField:'postionname',
        groupFormatter:function(value,rows){
            return value;
        },
	    columns:[[
	              {field:'id',title:'id',hidden:true},
		          {field:'onum',title:'序号',align:"center",width:50},
                  {field:'image',title:'图片',align:"center",width:100,
                      formatter:function(value,row,index){
                          return "<a href=\"javascript:void(0)\" onclick=\"$.createIMG('"+value+"')\">点击查看</a>";
                      }
                  },
		          {field:'title',title:'标题',align:"center",width:300},
		          {field:'http',title:'链接',width:600}

		]],
		toolbar:'#tool',
		onLoadSuccess:function(){
			$("#datagrid").datagrid('scrollTo',0);
		}
	});
    $.ajax({
        url: basePath+postionsList,
        success: function(data){
            $("#postion_input").combobox({
                editable:false,
                data:data,
                valueField:'code',
                textField:'name'
            });
        }
    });
});

function openAddWindow() {
    $('#apply_form').form("clear");
    $("#img").attr("src","");
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
        title:row.title,
        postion:row.postion,
        onum:row.onum,
        http:row.http,
        image:row.image
	});
    $("#img").attr("src",row.image);
	$('#apply_window').window('open');
	$('#apply_window').window('center');
}

function closeWindow(){
	$('#apply_window').window('close');
}

function applyEdit(){
	$.ajax({
        url: basePath+advAddOrEdit,
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

function deleteAdv(){
    var node = $("#datagrid").datagrid('getSelected');
    if(node == null){
        $.messager.alert("提示框","请选择一条记录！");
        return;
    }
    $.messager.confirm('删除提示', '你确定要删除这个广告吗？', function(r){
        if(r){
            $.ajax({
                url:advDelete,
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
