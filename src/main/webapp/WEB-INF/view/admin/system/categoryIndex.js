$(function(){
	$("#datagrid").treegrid({
        border:false,
        fit:true,
        rownumbers:true,
        idField:"id",
        treeField:"name",
	    columns:[[
			{field:'id',title:'id',hidden:true},
			{field:'name',title:'名称',width:150},
			{field:'remark',title:'说明',width:300},
            {field:'attr',title:'其他属性',width:200},
            {field:'onum',title:'排序值',width:100},
			{field:'status',title:'状态',align:"center",width:100,
				formatter: function(value,row,index){
					return value?"<font color='green'>正常</font>":"<font color='red'>禁用</font>";
				}
			}
		]],
		toolbar:'#tool',
		onLoadSuccess:function(){
            initPermissionButton();
		}
	});
    goto1();
});
var source = 0;
function goto1(){
    $.ajax({
        url:categoryTreeUrl,
        data:{source:1},
        success: function (data){
            $("#datagrid").treegrid({
                    data:data.data
			});
            source = 1;
        }
    });
}
function goto2(){
    $.ajax({
        url:categoryListUrl,
        data:{source:2},
        success: function (data){
            $("#datagrid").treegrid({
                data:data.data
            });
            source = 2;
        }
    });
}

function restView(){
    if(source == 1){
        goto1();
    }else if(source == 2){
        goto2();
    }
}

function openAddWin(){
    $('#applyForm').form('clear');
    var row = $('#datagrid').datagrid('getSelected');
    if(row != null){
        $('#applyForm').form('load',{
            pid:row.parent_id
        });
    }
	$('#window').window('open');
	$('#window').window('center');	
}
function openAddSWin(){
    $('#applyForm').form('clear');
    var row = $('#datagrid').datagrid('getSelected');
    if(row == null){
        $.messager.alert("提示框","请选择一条记录！");
        return;
    }
    $('#applyForm').form('load',{
        pid:row.id
    });
    $('#window').window('open');
    $('#window').window('center');
}
function openEditWin(){
	var row = $('#datagrid').datagrid('getSelected');
	if(row == null){
		$.messager.alert("提示框","请选择一条记录！");
		return;
	}
	$('#applyForm').form('clear');

	$('#applyForm').form('load',{
		id:row.id,
        pid:row.parent_id,
        name:row.name,
        onum:row.onum,
        http:row.http,
        attr:row.attr,
		remark:row.remark
    });
	$('#window').window('open');
	$('#window').window('center');	
}

function apply(){
    $('#applyForm').form('load', {
        source: source,
    });
 	$.ajax({
	    url:categoryAddOrEditUrl,
	    data:$("#applyForm").serialize(),
	    success: function (data){
	    	if(data.status==0){
                restView();
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

function editStatus(){
    var row = $('#datagrid').datagrid('getSelected');
    if(row == null){
        $.messager.alert("提示框","请选择一条记录！");
        return;
    }
    var popt = row.status?"请确认：是否要禁用此类目？":"请确认：是否要启用此类目？";
    $.messager.confirm('提示',popt,function(r) {
        if (r) {
            $.ajax({
                url:categoryEditSUrl,
                data:{id:row.id,status:!row.status},
                success: function (data){
                    if(data.status==0){
                        restView();
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

function delCategory(){
    var row = $('#datagrid').datagrid('getSelected');
    if(row == null){
        $.messager.alert("提示框","请选择一条记录！");
        return;
    }
    $.messager.confirm('提示','请确认：是否删除此记录?',function(r) {
        if (r) {
            $.ajax({
                url:categoryDelUrl,
                data:{id:row.id},
                success: function (data){
                    if(data.status==0){
                        restView();
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

