<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/taglib.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>网站后台管理登录页面</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<jsp:include page="common/shareJs.jsp" />
	<script type="text/javascript">
		if (window != top){
			top.location.href = location.href; 
		}
		//前端账号密码格式验证
		function onsubmitFrom(){
			var userName = $("#logincode");
			var passwordObj = $("#loginkey");
			var codeObj = $("#vcode_input");
			if(userName.val() == '' ) {
				$("#id_error_span").show();
				$("#message").text( "请输入用户名！" );
				return false;
			}
			if( passwordObj.val() == '' ) {
				$("#id_error_span").show();
				$("#message").text( "请输入密码！" );
				return false;
			}
			if( codeObj.val() == '' ) {
				$("#id_error_span").show();
				$("#message").text( "请输入验证码！" );
				return false;
			}
			
			$.ajax({
				url:'<%=basePath%>admin/login',	//登录
				method:'post',
				dataType:'json',
				data:$("#loginForm").serialize(),
				success:function(result){
					if(0 == result.status){
						window.location.href='<%=basePath%>admin/index';
					}else{
						$("#id_error_span").show();
						$("#code_imge").click();
						$("#code_input").val("");
						$("#message").text(result.msg);
					}
				}
			});
		}
		//回车键快速登录【兼容】
		document.onkeydown = function keyLogin(e){
		 	e = e||event;
			if (e.keyCode==13) {  //回车键的键值为13
			  onsubmitFrom();
			}
		}
		
	</script>
</head>

<body style="background-repeat: no-repeat;background-color: #9CDCF9;background-position: 0px 0px;">
<table width="730" border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:220px;">
	<tr>
	    <td width="353" height="259" align="center" valign="bottom" background="<%=basePath%>images/lgimg/login_1.gif">
	    <table width="90%" border="0" cellspacing="3" cellpadding="0">
	      <tr>
	        <td align="right" valign="bottom" style="color:#05B8E4;" ></td>
	      </tr>
	    </table>
	    </td>
	    <td width="250px;" background="<%=basePath%>images/lgimg/login_2.gif">
	    <form method="post" name="login" id="loginForm">
	    <input type="hidden" name="" value="" id="">
	    <table width="240" height="106" border="0" align="center" cellpadding="2" cellspacing="0">
			<tr>
		        <td height="50" colspan="2" align="left">&nbsp;</td>
		    </tr>
		    <tr>
				<td width="80" height="30" align="left" style="font-family:微软雅黑">登录名称</td>
				<td><input name="logincode" id="logincode" TYPE="text" style="background:url(<%=basePath%>images/lgimg/login_6.gif) repeat-x; border:solid 1px #27B3FE; height:20px; width:150px;background-color:#FFFFFF" size="16" value=""></td>
			</tr>
			<tr>
				<td width="80" height="30" align="left" style="font-family:微软雅黑">登录密码</td>
				<td><input name="loginkey" id="loginkey" TYPE="password" style="background:url(<%=basePath%>images/lgimg/login_6.gif) repeat-x; border:solid 1px #27B3FE; height:20px;width:150px; background-color:#FFFFFF" value=""></td>
			</tr>
			
			<tr>
				<td width="80" height="30"> 验 证 码 </td>
				<td>
					<input id="vcode_input" name="vcode" type="text" size="4"  style="background:url(<%=basePath%>images/lgimg/login_6.gif) repeat-x; border:solid 1px #27B3FE; height:20px; background-color:#FFFFFF" maxlength="6">
					<img id="code_imge" src="<%=basePath%>portal/getValidCode?type=string&length=4"  onclick="this.src='<%=basePath%>portal/getValidCode?type=string&length=4&'+Math.random();" title="点击切换" width="100" height="23" style="vertical-align: middle;"/>
				</td>
			</tr>
			
			<tr>
				<td height="40" colspan="2" align="center">
					<span style="font-family:微软雅黑;display:none;" id="id_error_span" >
						<img src="<%=basePath%>images/lgimg/tip.gif" width="16" height="16"><font color="red" id="message">${message}</font>
					</span>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="button" onclick="onsubmitFrom()" style="background:url(<%=basePath%>images/lgimg/login_5.gif) no-repeat; cursor: pointer;" value=" 登  录 "> 
					<input type="reset" style="background:url(<%=basePath%>/images/lgimg/login_5.gif) no-repeat; cursor: pointer;" value=" 取  消 ">
				</td>
			</tr>
			<tr>
				<td height="5" colspan="2"></td>
			</tr>
		</table>
		</form>
	    </td>
	    <td width="133" background="<%=basePath%>images/lgimg/login_3.gif">&nbsp;</td>
	</tr>
	<tr>
    	<td height="161" colspan="3" background="<%=basePath%>images/lgimg/login_4.gif"></td>
	</tr>
</table>
</body>
</html>