<%@ page language="java" import="java.util.*,com.ich.core.listener.SystemConfig" pageEncoding="UTF-8"%>
<%@ include file="../../admin/common/taglib.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  	<head>
	    <base href="<%=basePath%>">
	    <title>网站后台管理首页面</title>
	   	<jsp:include page="../../admin/common/shareJs.jsp" />
 	</head>
 	<script type="text/javascript">
 		var userMenuList = "admin/employeeMenus";
 	</script>
 	<!-- 主框架最小尺寸1280*768。内框架最小尺寸1024*630 -->
	<body style="width:100%;height:100%;">
		<div style="padding: 8px 35px 8px 14px;text-shadow: 0 1px 0 rgba(255,255,255,0.5);background-color: #fcf8e3;border: 1px solid #fbeed5;-webkit-border-radius: 4px;-moz-border-radius: 4px;border-radius: 4px;color: #666;">
			<div style="line-height:30px">功能说明：提供系统所需的配置信息，仅可动态修改</div>
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100px"  onclick="openEditWindow()">修改</a>
		</div>
	</body>
</html>
