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
	<script type="text/javascript" src="<%=basePath%>view/admin/system/configIndex.js"></script>
	<script type="text/javascript" src="<%=basePath%>script/easyui/datagrid-groupview.js"></script>
	<script type="text/javascript">
		var configList = "admin/config/list";
		var configEdit = "admin/config/edit";
	</script>
  </head>
  
  <body style="width:100%;height:100%;">

    <table id="datagrid"></table>
    
    <div id="tool" style="padding:0px;height:auto;overflow: hidden;">
   		<div style="padding: 8px 35px 8px 14px;text-shadow: 0 1px 0 rgba(255,255,255,0.5);background-color: #fcf8e3;border: 1px solid #fbeed5;-webkit-border-radius: 4px;-moz-border-radius: 4px;border-radius: 4px;color: #666;">
			<div style="line-height:30px">功能说明：提供系统所需的配置信息，仅可动态修改</div>
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100px"  onclick="openEditWindow()">修改</a>		
		</div>
		<!-- 
		<div class="sgtz_atn">
			<span style="font-weight: bold;">搜索筛选：</span>
			<input id="sk_searchkey" class="easyui-searchbox" data-options="prompt:'搜索关键字（组名、说明）',searcher:doSearch" style="width:300px"></input>
		</div> -->
	</div>
    
    <div id="apply_window2" class="easyui-window" title="信息表单" 
		data-options="modal:true,collapsible:false,minimizable:false,maximizable:false,resizable:false,closable:false,closed:true" 
		style="width:400px;height:200px;padding:10px;">
       	<form id="apply_form2">
       		<input name="ikey" type="hidden">
       		<ul class="fm_s" style="overflow: inherit;">
				<li class="fm_1l">
					<label>值：</label>
					<input name="ivalue" class="easyui-validatebox textbox vipt " data-options="required:true">
				</li>
				<li class="fm_1l">
					<label>值表达式：</label>
					<input name="driver" class="easyui-validatebox textbox vipt" disabled="disabled">
				</li>
				<li style="text-align: center;padding-left:80px;">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"  style="width:100px"  onclick="applyEdit()">确认</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"  style="width:100px"  onclick="closeEditWindow()">取消</a>
				</li>
			</ul>
       	</form>
    </div>
  </body>
</html>
