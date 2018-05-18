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
	<script type="text/javascript" src="<%=basePath%>view/admin/system/witnessesIndex.js"></script>
		
	<script type="text/javascript">
		var witnessesListUrl = "admin/witnesses/list";
		var witnessesDListUrl = "admin/witnesses/dlist";
		var witnessesHandleUrl = "admin/witnesses/handle";
	</script>
  </head>
  
  <body style="width:100%;height:100%;">

    <table id="datagrid"></table>
    
    <div id="tool" style="padding:0px;height:auto;overflow: hidden;">
    	<div style="padding: 8px 35px 8px 14px;text-shadow: 0 1px 0 rgba(255,255,255,0.5);background-color: #fcf8e3;border: 1px solid #fbeed5;-webkit-border-radius: 4px;-moz-border-radius: 4px;border-radius: 4px;color: #666;">
			<div style="line-height:30px">页面说明：用于处理举报信息，注意：请在确认并完成具体处理业务后填写处理结果，每次处理会处理掉当前被举报人的所有举报信息。</div>
            <a href="javascript:void(0)" class="easyui-linkbutton"  style="width:120px" onclick="openDWin()">处理</a>

            <input id="sk_searchkey" class="easyui-searchbox" data-options="prompt:'搜索关键字（被举报人）',searcher:doSearch" style="width:300px"></input>
		</div>
	</div>

    <div id="dwindow" class="easyui-window" title="举报列表"
    data-options="modal:true,collapsible:false,minimizable:false,maximizable:false,resizable:false,closed:true"
    style="width:1000px;height:630px;">
        <table id="d_datagrid" style="height:565px;"></table>
        <div id="d_tool" style="padding:0px;height:auto;overflow: hidden;">
            <div class="sgtz_atn">
                <a href="javascript:void(0)" class="easyui-linkbutton"  style="width:120px" onclick="openHandleWin()">填写处理结果</a>
            </div>
        </div>
    </div>

    <div id="window" class="easyui-window" title="举报处理结果"
    data-options="modal:true,closable:false,collapsible:false,minimizable:false,maximizable:false,resizable:false,closed:true"
    style="width:550px;height:500px;padding:10px;">
        <form id="applyForm" action="" method="post">
        <input type="hidden" name="wid">
            <ul class="fm_s" style="overflow: inherit;">
            <li class="fm_1l">
            <label>被举报人：</label>
            <input name="wname" class="easyui-validatebox textbox vipt " disabled="disabled">
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
