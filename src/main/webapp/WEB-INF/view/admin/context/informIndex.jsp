<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/taglib.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>系统配置-系统参数</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<jsp:include page="../common/shareJs.jsp" />
	<script type="text/javascript" src="<%=basePath%>view/admin/context/informIndex.js"></script>
	<script type="text/javascript" src="<%=basePath%>script/easyui/datagrid-groupview.js"></script>
	<script type="text/javascript">
		var informList = "inform/list";
		var informAddOrEdit = "inform/addOrEdit";
		var informDelete = "inform/delete";
		var informCancel = "inform/cancel";

	</script>
  </head>
  
  <body style="width:100%;height:100%;">

    <table id="datagrid"></table>
    
    <div id="tool" style="padding:0px;height:auto;overflow: hidden;">
   		<div style="padding: 8px 35px 8px 14px;text-shadow: 0 1px 0 rgba(255,255,255,0.5);background-color: #fcf8e3;border: 1px solid #fbeed5;-webkit-border-radius: 4px;-moz-border-radius: 4px;border-radius: 4px;color: #666;">
			<div style="line-height:30px">功能说明：</div>
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100px"  onclick="openAddWindow()">新增</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100px"  onclick="openEditWindow()">修改</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100px"  onclick="cancelInform()">取消</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100px"  onclick="deleteInform()">删除</a>
		</div>
		<!-- 
		<div class="sgtz_atn">
			<span style="font-weight: bold;">搜索筛选：</span>
			<input id="sk_searchkey" class="easyui-searchbox" data-options="prompt:'搜索关键字（组名、说明）',searcher:doSearch" style="width:300px"></input>
		</div> -->
	</div>
    
    <div id="apply_window" class="easyui-window" title="信息表单"
		data-options="modal:true,collapsible:false,minimizable:false,maximizable:false,resizable:false,closable:false,closed:true" 
		style="width:500px;height:250px;padding:10px;">
       	<form id="apply_form">
       		<input name="id" type="hidden">
       		<ul class="fm_s" style="overflow: inherit;">
				<li class="fm_1l">
					<label>内容：</label>
					<input name="info" class="easyui-textbox textbox vipt" data-options="labelPosition:top,multiline:true" style="height:60px;width:300px">
				</li>
				<li class="fm_1l">
					<label>到期时间：</label>
					<input name="etime" class="easyui-datetimebox textbox vipt">
				</li>
				<li class="fm_1l" style="text-align: center;">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"  style="width:100px"  onclick="applyEdit()">确认</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"  style="width:100px"  onclick="closeWindow()">取消</a>
				</li>
			</ul>
       	</form>
    </div>
  </body>
</html>
