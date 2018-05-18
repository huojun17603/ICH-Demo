<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/taglib.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>..</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<jsp:include page="../common/shareJs.jsp" />
	<script type="text/javascript" src="<%=basePath%>view/admin/context/noteclassIndex.js"></script>
  	<style type="text/css">
  		.tree-icon{display: none}
  	</style>
  </head>
  
  <body style="">
  	<script type="text/javascript">
  		var basePath = "<%=basePath%>";
  		var noteclassListUrl = "noteclass/tree";
  		var noteclassDeleteUrl = "noteclass/delete";
  		var noteclassSaveOrUpdateUrl = "noteclass/saveOrUpdate";
  	</script>
	<table id="treegrid" >
	    
	</table>
	<div id="tool" style="height:auto;overflow: hidden;">
		<div style="padding: 8px 35px 8px 14px;text-shadow: 0 1px 0 rgba(255,255,255,0.5);background-color: #fcf8e3;border: 1px solid #fbeed5;-webkit-border-radius: 4px;-moz-border-radius: 4px;border-radius: 4px;color: #666;">
			<div style="line-height:30px">功能说明：提供店铺类目配置功能，注：未选中状态下选同级新增自动变成顶级类目</div>
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" onclick="openWindowWithB()">新增同级</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add"  onclick="openWindowWithS()">新增子级</a>
		  	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="openWindowWithU();">修改</a>
		  	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"  onclick="delClass()">删除</a>
		</div>
	</div>
	
	<div id="window" class="easyui-window" title="商品服务分类信息编辑" data-options="modal:true,closable:false,collapsible:false,minimizable:false,maximizable:false,resizable:false,closed:true" style="width:450px;height:250px;padding:10px;">
        <div style="padding:5px 60px 5px 20px">
        <form id="applyForm" action="">
        	<input type="hidden" id="id_input" name="id">
        	<input type="hidden" id="pid_input" name="pid">
        	<table cellpadding="5" style="font-size: 13px;">
                <tr>
                    <td>名称:</td>
                    <td><input class="easyui-textbox" type="text" name="name" data-options="required:true"></input></td>
                </tr>
                <tr>
                    <td>备注:</td>
                    <td>
                    	<textarea name="remark" rows="4" cols="25" style="resize:none" ></textarea>
                    </td>
                </tr>
            </table>
        </form>
        </div>
        <div style="text-align:center;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="submitForm()">提交</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()">关闭</a>
        </div>
    </div>
  </body>
</html>
