//创建选择器。数据选择器
function newSelector(window,property){
    var datagrid = "<table></table>";
    this.$window=window;
    this.$datagrid=$(datagrid);
    this.$window.append(this.$datagrid);
    var dg = this.$datagrid;
    //创建Window
    this.$window.window({
        title:property.title,
        width:(property.width||800),
        height:(property.height||400),
        modal:true,
        collapsible:false,
        minimizable:false,
        maximizable:false,
        resizable:false,
        closable:false,
        closed:false
    });
    //创建DataGrid
    this.$datagrid.datagrid({
        url:basePath+property.dataUrl,
        queryParams:property.params,
        striped:true,
        fit:true,
        pageSize:20,
        pageList:[20,50,100],
        idField:'id',
        loadMsg:'加载中……',
        rownumbers:true,//序号
        pagination:true,//显示底部分页工具栏
        singleSelect:property.singleSelect,//单选
        columns:property.columns,
        toolbar:(property.toolbar||null)
    });
    var pager = this.$datagrid.datagrid('getPager');
    var buttons = "<div><table style=\"border-spacing:0\"><tr>"
        +"<td><input  id=\"selb_search\" class=\"easyui-searchbox\" style=\"width:150px\"></td>"
        +"<td><a id=\"selb_ok\" href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-ok',plain:false\">选择</a></td>"
        +"<td><a id=\"selb_cancel\" href=\"javascript:void(0)\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-cancel',plain:false\">取消</a></td>"
        +"</tr></table></div>";
    pager.pagination({
        buttons:$(buttons)
    });
    $.parser.parse(pager);
    $("#selb_cancel").on("click",{inthis:this},function(e){
        window.window("close");
        window.empty();
    });
    $("#selb_ok").on("click",{inthis:this},function(e){
        var checkedItems = dg.datagrid('getChecked');
        /* 		if(checkedItems.length==0){
                     $.messager.alert("提示框","请选择一条记录！");
                     return;
                 }*/
        property.callback(checkedItems);
        window.window("close");
        window.empty();
    });
    $("#selb_search").searchbox({
        searcher:function(value){
            property.searchCall(dg,value);
        },
        prompt:(property.searchPrompt||'请输入关键字')
    });
}

//将此类的构造函数加入至JQUERY对象中
jQuery.extend({
    createSelector:function(window,property){
        return new newSelector(window,property);
    }
});
///调用例子
//function openSelector2(){
//	var property={
//		title:"请选择副领导",
//		dataUrl:employequery,//数据连接
//		singleSelect:false,//单选/多选
//		searchPrompt:"请输入关键字",//搜索提示
//		columns:[[
//				{field:'accountCode',title:'系统编号'},
//				{field:'name',title:'姓名'},
//				{field:'positionName',title:'职位'},
//				{field:'orgName',title:'组织机构'},
//				{field:'phone',title:'绑定手机号'},
//		    ]],
//		searchCall:function(dg,value){//搜索值回调
//			dg.datagrid('reload',{name:value});
//		},
//		callback:function(data){//选择值回调
//			var ids=[];
//			var names = [];
//			$.each(data, function(index, item){
//				ids.push(item.id);
//				names.push(item.name);
//			});               
//			$('#deputyLeader_input').val(ids.join(","));
//			$('#deputyLeaderName_input').val(names.join(","));	
//		}
//	};
//	$.createSelector($("#selector"),property);
//}