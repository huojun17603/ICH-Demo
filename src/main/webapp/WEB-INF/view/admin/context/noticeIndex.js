$(function(){
	$("#datagrid").datagrid({
		url:basePath + noticeQuery,
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
		          {field:'classname',title:'类型',align:"center",width:100},
		          {field:'title',title:'标题',align:"center",width:300},
		          {field:'samlltitle',title:'短标题',align:"center",width:100},
		          {field:'author',title:'作者',align:"center",width:120},

		          {field:'info',title:'简介',width:600},
			      {field:'createtime',title:'创建时间',align:"center",width:150,formatter:formatterTime},
		          {field:'status',title:'状态',width:120,align:"center",
		        	  formatter: function(value,row,index){
		        		  switch (value) {
			        		case 1:
								return "正常";
							default:
								return "禁用";
		        		  }
		        	  }
		          }

		]],
		toolbar:'#tool'
	});
	// $("#assign_input").combobox({
	// 	editable:false,
	// 	data:[{id:"0",text:"全部"},{id:"1",text:"PC"},{id:"2",text:"微信"}],
     //    valueField:'id',
     //    textField:'text',
     //    required:true,
	// });


	$("#postion_input").combobox({
        editable:false,
        multiple:true,
		url:postionsList,
		valueField:'code',
		textField:'name'
	});

	$("#tag_input").combobox({
		editable:false,
        multiple:true,
        url:tagsList,
        valueField:'code',
        textField:'name'
	});

	$.ajax({
		url: basePath+noticeClassesList,
	    success: function(data){
            eachTM(data);
			$("#classes_input").combotree({
				editable:false,
				data:data,

			});
            $("#sk_classesid").combotree({
                editable:false,
                data:data,
                onChange:doSearch

            });
	    }
	});

	function eachTM(data){
        $.each(data,function(index,value){
            value.text = value.name;
            if(!isEmpty(value.children)){
                eachTM(value.children)
            }
        });
	}
});



function openAddWindow(){
	$("#add_form").form("clear");
	editor1.html("");
	$('#add_window').window('open');
	$('#add_window').window('center');
}

function openEditWindow(id){
    var row = $("#datagrid").datagrid("getSelected");
    if(isEmpty(row)){
        $.messager.alert("提示消息",'请选择一条记录！');
        return ;
    }
	$.ajax({
        url: basePath+noticeDetails,
        data: {id:row.id},
        success: function(data){
            if(data.status==0){
            	$('#add_window').window('open');
            	$('#add_window').window('center');
            	$("#add_form").form("load",{
            		id:data.data.id,
                    classid:data.data.classid,
            		title:data.data.title,
                    samlltitle:data.data.samlltitle,
                    author:data.data.author,
                    info:data.data.info,
            		http:data.data.http,
            		img:data.data.img,
            		tag:data.data.tag,
                    postion:data.data.postion,
                    keyword:data.data.keyword
            	});
            	$("#img").attr("src",data.data.img);
            	$("#classes_input").combotree("setValue",data.data.classid);
            	editor1.html(data.data.html);
            }else if(data.status==1){
            	$.messager.alert("错误",data.msg,'warning');
            }else if(data.status==3){
            	$.messager.alert("警告","无权访问",'warning');
            }
        }
    });
	
}

function closeAddWindow(){
	$('#add_window').window('close');
}

function addNew(){
	editor1.sync();
	$.ajax({
        url: basePath+noticeSaveOrUpdate,
        data: $('#add_form').serialize(),
        success: function(data){
            if(data.status==0){
            	$('#datagrid').datagrid('reload');
            	$('#add_window').window('close');
            	$.messager.alert("提示框","完成操作请求！");
            }else if(data.status==1){
            	$.messager.alert("错误",data.msg,'warning');
            }else if(data.status==3){
            	$.messager.alert("警告","无权访问",'warning');
            }
        }
    });
}

function editStatus(){
    var row = $("#datagrid").datagrid("getSelected");
    if(isEmpty(row)){
        $.messager.alert("提示消息",'请选择一条记录！');
        return ;
    }
    var status = row.status==0?1:0;
	$.ajax({
        url: basePath+noticeEditstatus,
        data: {id:row.id,status:status},
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

function openDetailWindow(){
    var row = $("#datagrid").datagrid("getSelected");
    if(isEmpty(row)){
        $.messager.alert("提示消息",'请选择一条记录！');
        return ;
    }
    $.ajax({
        url: basePath+noticeDetails,
        data: {id:row.id},
        success: function(data){
            if(data.status==0){
                $('#context_div').html(data.data.html);
                $('#detail_window').window('open');
                $('#detail_window').window('center');
            }else if(data.status==1){
                $.messager.alert("错误",data.msg,'warning');
            }else if(data.status==3){
                $.messager.alert("警告","无权访问",'warning');
            }
        }
    });
}

function doSearch(){
	var classid = $("#sk_classesid").combotree("getValue");
	var searchkey  = $("#sk_searchkey").val();
	$("#datagrid").datagrid("reload",{classid:classid,searchkey:searchkey});
}

