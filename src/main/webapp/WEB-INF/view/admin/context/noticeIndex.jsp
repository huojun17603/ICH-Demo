<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/taglib.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>博彩公司管理页</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<jsp:include page="../common/shareJs.jsp" />
	<link rel="stylesheet" href="<%=basePath%>script/kindeditor/themes/default/default.css" />
	<link rel="stylesheet" href="<%=basePath%>script/kindeditor/plugins/code/prettify.css" />
	<script charset="utf-8" src="<%=basePath%>script/kindeditor/kindeditor.js"></script>
	<script charset="utf-8" src="<%=basePath%>script/kindeditor/lang/zh_CN.js"></script>
	<script charset="utf-8" src="<%=basePath%>script/kindeditor/plugins/code/prettify.js"></script>
	<!-- HTML5上传 -->
	<script type="text/javascript" src="<%=basePath %>script/common/html5.upload.js"></script>
	<script type="text/javascript" src="<%=basePath%>view/admin/context/noticeIndex.js"></script>
	<script type="text/javascript">
		var tagsList = "noteclass/tags";
		var postionsList = "noteclass/postions";
		var noticeClassesList = "noteclass/tree";
		var noticeQuery = "notice/query";
		var noticeSaveOrUpdate = "notice/addOrEdit";
		var noticeDetails = "notice/detail";
		var noticeEditstatus = "notice/editstatus";
		var uploadUrl = "<%=basePath%>"+"management/file/kindeditor/uploadJson";
		var fileManager="<%=basePath%>"+"portal/attachment/FileManagerJson";
		var editor1;
		KindEditor.ready(function(K) {
				editor1 = K.create('textarea[name="html"]', {
				resizeType : 0,//不许自己调整编辑大小
				autoHeightMode: true, //自动高度模式开启
				cssPath : '<%=basePath%>script/kindeditor/plugins/code/prettify.css',
				formatUploadUrl:false,
				uploadJson :uploadUrl+"?code=${code}",
				fileManagerJson : fileManager+"?code=${code}",
				allowFileManager : true,
				afterCreate : function() {
					this.loadPlugin('autoheight');
				},
				afterBlur: function(){this.sync();}
			});
		});
	</script>
  </head>
  
  <body>
    <table id="datagrid"></table>
    <div id="tool" style="padding:0px;height:auto;overflow: hidden;">
    	<div style="padding: 8px 35px 8px 14px;text-shadow: 0 1px 0 rgba(255,255,255,0.5);background-color: #fcf8e3;border: 1px solid #fbeed5;-webkit-border-radius: 4px;-moz-border-radius: 4px;border-radius: 4px;color: #666;">
			<div style="line-height:30px">功能说明：用于购彩中心页面内容管理。目前用于：资讯、公告</div>
			<a href="javascript:void(0)" class="easyui-linkbutton"  style="width:80px"  onclick="openAddWindow()">新增</a>
			<a href="javascript:void(0)" class="easyui-linkbutton"  style="width:80px"  onclick="openEditWindow()">修改</a>
			<a href="javascript:void(0)" class="easyui-linkbutton"  style="width:120px"  onclick="editStatus()">禁用/启用</a>
			<a href="javascript:void(0)" class="easyui-linkbutton"  style="width:80px"  onclick="openDetailWindow()">图文详情</a>
			<div class="sgtz_atn">
				搜索：<input id="sk_classesid"  class="easyui-combotree">
				<input id="sk_searchkey" class="easyui-searchbox" data-options="prompt:'请输入搜索关键字（标题）',searcher:doSearch" style="width:300px"/>
			</div>
		</div>
	</div>
	
	<div id="add_window" class="easyui-window" title="新增文章"
		data-options="modal:true,collapsible:false,minimizable:false,maximizable:false,resizable:false,closable:false,closed:true" 
		style="width:900px;height:600px;padding:10px;">
        <div style="padding:5px 20px 5px 20px">
        	<input id="uploadify" type="file" style="display: none"/>
        	<form id="add_form">
        		<input name="id" type="hidden">
        		<ul class="fm_s">
        			<li class="fm_1l">
						<label>内容类型：</label>
						<input id="classes_input" name="classid" class="easyui-combobox vipt">
					</li>
        			<li class="fm_1l">
						<label>标题：</label>
						<input id="title_input" name="title" class="easyui-validatebox textbox vipt" data-options="required:true">
						<label>短标题：</label>
						<input id="samlltitle_input" name="samlltitle" class="easyui-validatebox textbox vipt">
					</li>
        			<li class="fm_1l">
						<label>作者：</label>
						<input id="author_input" name="author" class="easyui-validatebox textbox vipt" >
					</li>
					<li class="fm_1l">
						<label>简介：</label>
						<input id="info_input" name="info" class="easyui-validatebox textbox vipt" style="width: 500px;" >
					</li>
					<li class="fm_1l">
						<label>远程链接：</label>
						<input id="http_input" name="http" class="easyui-validatebox textbox vipt" style="width: 500px;" >
					</li>
					<li class="fm_1l">
						<label>位置：</label>
						<input id="postion_input" name="postion" class="easyui-combobox vipt">
						<label>标记：</label>
						<input id="tag_input" name="tag" class="easyui-combobox vipt">
					</li>
					<li class="fm_1l">
						<div style="float: left;margin-right: 20px">
							<label>图片上传：</label>
							<input id="img_input" name="img" type="hidden"/>
        					<a href="javascript:void(0)" class="easyui-linkbutton" style="width:100px"  onclick="$('#uploadify').click()">上传图片</a>
						</div>
					</li>
					<li class="fm_1l">
						<div style="width:80%;height:300px;background-color: #676767;position: relative;margin: auto;">
							<img id="img" alt="上传预览" src="" onclick="$.createIMG(this.src)" style="width:80%;max-height:300px;overflow: auto;margin: auto;position: absolute;top: 0; left: 0; bottom: 0; right: 0;  ">
						</div>
					</li>
        			<li>
						<textarea name="html" cols="100" rows="8" style="width:800px;height:300px;visibility:hidden;"></textarea>
					</li>
				</ul>

        		<div class="sgtz_center">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"  style="width:100px"  onclick="addNew()">确认</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"  style="width:100px"  onclick="closeAddWindow()">取消</a>
        		</div>
        	</form>
        </div>
    </div>
    
    <div id="detail_window" class="easyui-window" title="图文详情"
		data-options="modal:true,collapsible:false,minimizable:false,maximizable:false,resizable:false,closed:true" 
		style="width:900px;height:600px;padding:10px;">
        <div style="padding:5px 20px 5px 20px">
        	<div id="context_div"></div>
        </div>
    </div>
    <script type="text/javascript" src="<%=basePath%>view/admin/context/noticeImgIndex.js"></script>
  </body>
</html>
<%!
private String htmlspecialchars(String str) {
	str = str.replaceAll("&", "&amp;");
	str = str.replaceAll("<", "&lt;");
	str = str.replaceAll(">", "&gt;");
	str = str.replaceAll("\"", "&quot;");
	return str;
}
%>
