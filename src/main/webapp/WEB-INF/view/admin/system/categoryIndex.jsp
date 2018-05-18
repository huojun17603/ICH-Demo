<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/taglib.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>版本管理</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<jsp:include page="../common/shareJs.jsp" />
	<script type="text/javascript" src="<%=basePath%>view/admin/system/categoryIndex.js"></script>
		
	<script type="text/javascript">
		var categoryTreeUrl = "admin/category/obtain/tree";
		var categoryListUrl = "admin/category/obtain/list";
		var categoryAddOrEditUrl = "admin/category/addOrEdit";
        var categoryEditSUrl = "admin/category/editStatus";
        var categoryDelUrl = "admin/category/delete";
	</script>
  </head>
  
  <body style="width:100%;height:100%;">

    <table id="datagrid"></table>
    
    <div id="tool" style="padding:0px;height:auto;overflow: hidden;">
    	<div style="padding: 8px 35px 8px 14px;text-shadow: 0 1px 0 rgba(255,255,255,0.5);background-color: #fcf8e3;border: 1px solid #fbeed5;-webkit-border-radius: 4px;-moz-border-radius: 4px;border-radius: 4px;color: #666;">
            <a href="javascript:void(0)" class="easyui-linkbutton"  style="width:100px" onclick="goto1()">店铺类目</a>
            <a href="javascript:void(0)" class="easyui-linkbutton"  style="width:100px" onclick="goto2()">会员类目</a>
			<div style="line-height:30px">页面说明：管理公共的系统类目信息，建议由培训后的员工使用，以免造成系统问题！</div>
			<a href="javascript:void(0)" class="easyui-linkbutton"  style="width:100px" onclick="openAddWin()">新增同级</a>
            <a href="javascript:void(0)" class="easyui-linkbutton"  style="width:100px" onclick="openAddSWin()">新增子级</a>
		  	<a href="javascript:void(0)" class="easyui-linkbutton"  style="width:80px" onclick="openEditWin();">修改</a>
            <a href="javascript:void(0)" class="easyui-linkbutton"  style="width:100px" onclick="editStatus();">启用/禁用</a>
            <a href="javascript:void(0)" class="easyui-linkbutton"  style="width:80px" onclick="delCategory();">删除</a>
	</div>
	
	<div id="window" class="easyui-window" title="系统类目编辑"
        data-options="modal:true,closable:false,collapsible:false,minimizable:false,maximizable:false,resizable:false,closed:true"
        style="width:550px;height:420px;padding:10px;">
        <form id="applyForm" action="" method="post">
        	<input type="hidden"  name="id">
            <input type="hidden"  name="pid">
            <input type="hidden"  name="source">
            <ul class="fm_s" style="overflow: inherit;">
                <li class="fm_1l">
                    <label>类目名称：</label>
                    <input name="name" class="easyui-validatebox textbox vipt " data-options="required:true">
                </li>
                <li class="fm_1l">
                    <label>排序值：</label>
                    <input name="onum" class="easyui-validatebox textbox vipt " data-options="min:0,max:100,precision:0">
                </li>
                <li class="fm_1l">
                    <label>链接地址：</label>
                    <input name="http" class="easyui-numberbox textbox vipt "  style="width:350px">
                </li>
                <li class="fm_1l">
                    <label>其他属性：</label>
                    <input name="attr" class="easyui-validatebox textbox vipt "  style="width:350px">
                </li>
                <li class="fm_1l">
                    <label>说明：</label>
                    <input name="remark" class="easyui-textbox"  multiline="true" labelPosition="top" style="width:70%;height:130px">
                </li>
            </ul>
        </form>
        <div style="text-align:center;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"  style="width:100px" onclick="apply()">提交</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"  style="width:100px"  onclick="closeWin()">关闭</a>
        </div>
    </div>

  </body>
</html>
