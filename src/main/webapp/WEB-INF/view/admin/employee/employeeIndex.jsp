<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/taglib.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>员工管理</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<jsp:include page="../common/shareJs.jsp" />
	<script type="text/javascript" src="<%=basePath%>view/admin/employee/employeeIndex.js"></script>
	<script type="text/javascript">
		var organizationTree = "admin/organization/tree";
		var positionList = "admin/position/list";
		
		var employeeList = "admin/employee/query";
		var employeeQuick = "admin/employee/quick";
		var employeeUpdate = "admin/employee/update";
		var employeeDisable = "admin/employee/disable";
		var employeeAble = "admin/employee/able";
		var restkeyurl = "admin/employee/restkey";
		var isave = 1;
	</script>
	<style type="text/css">
		.tree-icon {width: 0px;}
	</style>
  </head>
  
  <body class="easyui-layout"  style="width:100%;height:100%;">
  	
 	<div data-options="region:'west',title:'组织机构树',split:false" style="width:200px;">
 		<ul id="org_tree"></ul>
    </div>
    <div data-options="region:'center'" style="background-color: #E0ECFF">
    	<table id="datagrid"></table>
    </div>
    
    <div id="tool" style="padding:0px;height:auto;overflow: hidden;">
		<div class="sgtz_atn">
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add"  style="width:160px"  onclick="openQuickWindow()">注册员工基本信息</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add"  style="width:160px"  onclick="openQuickEditWindow()">修改员工基本信息</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add"  style="width:160px"  onclick="restkey()">重置员工密码</a>

		</div>
	</div>
	
	<div id="employee_apply_window" class="easyui-window" title="员工快速申请表单" 
		data-options="modal:true,collapsible:false,minimizable:false,maximizable:false,resizable:false,closable:false,closed:true" 
		style="width:450px;height:400px;padding:10px;">
        <div style="padding:5px 20px 5px 20px">
        	<form id="employee_apply_form">
        		<input id="id" name="id" type="hidden">
        		<ul class="fm_s">
        			<li>
						<label>组织机构：</label>
						<input id="orgId_input" name="orgId" class="easyui-combotree" style="width: 220px;" >
					</li>
					<li>
						<label>职位：</label>
						<input id="positionId_input" name="positionId" class="easyui-combobox" >
					</li>
					<li>
						<label>登录账号：</label>
						<input id="logincode_input" name="logincode" class="easyui-validatebox textbox" data-options="required:true" >
					</li>
					<li>
						<label>登录密码：</label>
						<input id="loginkey_input" name="loginkey" class="easyui-validatebox textbox" data-options="required:true" >
					</li>
					<li>
						<label>员工名称：</label>
						<input id="name_input" name="name" class="easyui-validatebox textbox" data-options="required:true" >
					</li>
					<li>
						<label>绑定手机：</label>
						<input id="phone_input" name="phone" class="easyui-validatebox textbox" >
					</li>
					<li>
						<label>绑定邮箱：</label>
						<input id="email_input" name="email" class="easyui-validatebox textbox" >
					</li>
				</ul>
        		<div class="sgtz_center">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"  style="width:100px"  onclick="addEmployee()">确认</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"  style="width:100px"  onclick="closedWindow()">取消</a>
        		</div>
        	</form>
        </div>
    </div>

  </body>
</html>
