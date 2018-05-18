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
	<script type="text/javascript" src="<%=basePath%>script/common/html5.upload.js"></script>
	<script type="text/javascript" src="<%=basePath%>view/admin/context/advIndex.js"></script>
	<script type="text/javascript" src="<%=basePath%>script/easyui/datagrid-groupview.js"></script>
	<script type="text/javascript">
		var advList = "adv/list";
		var advAddOrEdit = "adv/addOrEdit";
		var advDelete = "adv/delete";
		var tagsList = "noteclass/tags";
		var postionsList = "noteclass/postions";
	</script>
  </head>
  
  <body style="width:100%;height:100%;">

    <table id="datagrid"></table>
    
    <div id="tool" style="padding:0px;height:auto;overflow: hidden;">
   		<div style="padding: 8px 35px 8px 14px;text-shadow: 0 1px 0 rgba(255,255,255,0.5);background-color: #fcf8e3;border: 1px solid #fbeed5;-webkit-border-radius: 4px;-moz-border-radius: 4px;border-radius: 4px;color: #666;">
			<div style="line-height:30px">功能说明：平台广告信息发布页，注意：排序是从大到小</div>
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100px"  onclick="openAddWindow()">新增</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100px"  onclick="openEditWindow()">修改</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100px"  onclick="deleteAdv()">删除</a>
		</div>
		<!-- 
		<div class="sgtz_atn">
			<span style="font-weight: bold;">搜索筛选：</span>
			<input id="sk_searchkey" class="easyui-searchbox" data-options="prompt:'搜索关键字（组名、说明）',searcher:doSearch" style="width:300px"></input>
		</div> -->
	</div>
    
    <div id="apply_window" class="easyui-window" title="信息表单"
		data-options="modal:true,collapsible:false,minimizable:false,maximizable:false,resizable:false,closable:false,closed:true" 
		style="width:850px;height:400px;padding:10px;">
		<input id="uploadify" type="file" style="display: none"/>
       	<form id="apply_form">
       		<input name="id" type="hidden">
			<div style="width:50%;height:100%;float: left;">
       		<ul class="fm_s" style="overflow: inherit;">
				<li class="fm_1l">
					<label>标题：</label>
					<input name="title" class="easyui-validatebox textbox vipt" data-options="required:true">
				</li>
				<li class="fm_1l">
					<label>发布位置：</label>
					<input id="postion_input" name="postion" class="easyui-combobox vipt">
				</li>
				<li class="fm_1l">
					<label>链接地址：</label>
					<input name="http" class="easyui-validatebox textbox vipt">
				</li>
				<li>
					<label>排序:</label>
					<input class="easyui-numberbox" type="text" name="onum" data-options="min:0"></input>
				</li>
				<li class="fm_1l">
				<div style="float: left;margin-right: 20px">
				<label>图片上传：</label>
				<input id="img_input" name="image" type="hidden"/>
				<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100px"  onclick="$('#uploadify').click()">上传图片</a>
				</div>
				</li>
				<li style="text-align: center;padding-left:80px;">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"  style="width:100px"  onclick="applyEdit()">确认</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"  style="width:100px"  onclick="closeWindow()">取消</a>
				</li>
			</ul>
			</div>
		<div style="width:50%;height:100%;float: left;background-color: #676767;position: relative;">

			<img id="img" alt="上传预览" src="" onclick="$.createIMG(this.src)" style="width:80%;overflow: auto;margin: auto;position: absolute;top: 0; left: 0; bottom: 0; right: 0;  ">
		</div>
       	</form>
    </div>
	<script type="text/javascript" src="<%=basePath%>view/admin/context/advImgIndex.js"></script>
	</body>
</html>
