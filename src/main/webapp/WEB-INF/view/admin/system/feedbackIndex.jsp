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
	<script type="text/javascript" src="<%=basePath%>view/admin/system/feedbackIndex.js"></script>
		
	<script type="text/javascript">
		var feedbackListUrl = "admin/feedback/list";
		var feedbackHandleUrl = "admin/feedback/handle";
	</script>
  </head>
  
  <body style="width:100%;height:100%;">

    <table id="datagrid"></table>
    
    <div id="tool" style="padding:0px;height:auto;overflow: hidden;">
    	<div style="padding: 8px 35px 8px 14px;text-shadow: 0 1px 0 rgba(255,255,255,0.5);background-color: #fcf8e3;border: 1px solid #fbeed5;-webkit-border-radius: 4px;-moz-border-radius: 4px;border-radius: 4px;color: #666;">
			<div style="line-height:30px">页面说明：用于处理向平台提供的反馈意见。</div>
			<a href="javascript:void(0)" class="easyui-linkbutton"  style="width:80px" onclick="openHandleWin()">处理</a>
            <input id="sk_searchkey" class="easyui-searchbox" data-options="prompt:'搜索关键字（提交人、联系方式）',searcher:doSearch" style="width:300px"></input>
		</div>
	</div>
	
	<div id="window" class="easyui-window" title="反馈意见处理"
        data-options="modal:true,closable:false,collapsible:false,minimizable:false,maximizable:false,resizable:false,closed:true"
        style="width:550px;height:500px;padding:10px;">
        <form id="applyForm" action="" method="post">
        	<input type="hidden" id="id_input" name="id">
            <ul class="fm_s" style="overflow: inherit;">
                <li class="fm_1l">
                    <label>反馈人：</label>
                    <input name="username" class="easyui-validatebox textbox vipt " disabled="disabled">
                </li>
                <li class="fm_1l">
                    <label>联系方式：</label>
                    <input name="contact" class="easyui-validatebox textbox vipt " disabled="disabled">
                </li>
                <li class="fm_1l">
                    <label>反馈内容：</label>
                    <input name="context" class="easyui-textbox"   multiline="true" labelPosition="top" style="width:70%;height:100px">
                </li>
                <li class="fm_1l">
                    <label>反馈时间：</label>
                    <input name="createtime" class="easyui-validatebox textbox vipt " disabled="disabled">
                </li>
                <li class="fm_1l">
                    <label>处理说明：</label>
                    <input name="handlermark" class="easyui-textbox"  multiline="true" labelPosition="top" style="width:70%;height:120px">
                </li>
            </ul>
        </form>
        <div style="text-align:center;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"  style="width:100px" onclick="handle()">提交</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"  style="width:100px"  onclick="closeHandleWin()">关闭</a>
        </div>
    </div>

  </body>
</html>
