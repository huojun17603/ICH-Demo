<%@ page language="java" import="java.util.*,com.ich.core.listener.SystemConfig" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  	<head>
	    <base href="<%=basePath%>">
	    <title>网站后台管理首页面</title>
		<link rel="stylesheet" type="text/css" href="https://www.cnblogs.com/bundles/blog-common.css?v=ON3Mxdo4-HlSMqbNDBZXhFIcGLon3eZDvU8zBESgwkk1">
 	</head>
  	<body>
	<div id="cnblogs_post_body" class="blogpost-body"><p>网上找了一大堆的例子，没一个跑通的，都是copy转发，哎，整理得好辛苦。。做个笔记，方便正遇到此问题的猿们能够得到帮助。。。。废话不多说，贴代码。。。。。</p>
	<p><img src="https://images2015.cnblogs.com/blog/907280/201605/907280-20160503164900513-772646688.png" alt=""></p>
	<p>项目结构说明：</p>
	<p>1.dao层的admin、website包中包含的Mapper.xml文件分别操作不同的数据库</p>
	<p>2.举例：192.168.1.1下有个mysql数据库叫 odao_admin</p>
	<p>　　　　192.168.1.2下有个sqlserver数据库叫 odao_mobile</p>
	<p>　　　　详情见下方的jdbc.properties文件</p>
	<p><strong>1:Pom.xml</strong></p>
	<p>&nbsp;</p>
	<div class="cnblogs_code"><div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div>
	<pre><span style="color: #0000ff;">&lt;</span><span style="color: #800000;">project </span><span style="color: #ff0000;">xmlns</span><span style="color: #0000ff;">="http://maven.apache.org/POM/4.0.0"</span><span style="color: #ff0000;"> xmlns:xsi</span><span style="color: #0000ff;">="http://www.w3.org/2001/XMLSchema-instance"</span><span style="color: #ff0000;"> xsi:schemaLocation</span><span style="color: #0000ff;">="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">modelVersion</span><span style="color: #0000ff;">&gt;</span>4.0.0<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">modelVersion</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>com.odao.official<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>odao-official<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>0.0.1-SNAPSHOT<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">packaging</span><span style="color: #0000ff;">&gt;</span>war<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">packaging</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">name</span><span style="color: #0000ff;">&gt;</span>odao-official website<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">name</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">url</span><span style="color: #0000ff;">&gt;</span>http://maven.apache.org<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">url</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">properties</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">project.build.sourceEncoding</span><span style="color: #0000ff;">&gt;</span>UTF-8<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">project.build.sourceEncoding</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">spring.version</span><span style="color: #0000ff;">&gt;</span>4.1.6.RELEASE<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">spring.version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">jackson.version</span><span style="color: #0000ff;">&gt;</span>2.5.0<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">jackson.version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">properties</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependencies</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> junit  </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>junit<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>junit<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>4.12<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">scope</span><span style="color: #0000ff;">&gt;</span>test<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">scope</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> activemq  </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.apache.activemq<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>activemq-all<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>5.9.0<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.apache.activemq<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>activemq-pool<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>5.9.0<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>javax.mail<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>mail<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>1.4.7<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> spring  </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.springframework<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>spring-core<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${spring.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.springframework<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>spring-beans<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${spring.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.springframework<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>spring-context<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${spring.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.springframework<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>spring-tx<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${spring.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.springframework<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>spring-web<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${spring.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.springframework<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>spring-webmvc<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${spring.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.springframework<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>spring-jdbc<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${spring.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.springframework<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>spring-test<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${spring.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">scope</span><span style="color: #0000ff;">&gt;</span>test<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">scope</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.springframework<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>spring-aop<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${spring.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.springframework<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>spring-aspects<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${spring.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.springframework<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>spring-context-support<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${spring.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.springframework<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>spring-jms<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${spring.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.apache.xbean<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>xbean-spring<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>4.2<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> mybatis 包 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.mybatis<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>mybatis<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>3.2.8<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;">mybatis spring 插件 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.mybatis<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>mybatis-spring<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>1.2.2<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> 数据源 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>com.alibaba<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>druid<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>1.0.12<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>c3p0<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>c3p0<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>0.9.1.2<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.aspectj<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>aspectjweaver<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>1.8.4<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> log4j </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>log4j<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>log4j<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>1.2.17<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> servlet
	&lt;dependency&gt;
	&lt;groupId&gt;javax.servlet&lt;/groupId&gt;
	&lt;artifactId&gt;servlet-api&lt;/artifactId&gt;
	&lt;version&gt;3.0-alpha-1&lt;/version&gt;
	&lt;/dependency&gt;   </span><span style="color: #008000;">--&gt;</span> <br>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>javax.servlet<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>jstl<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>1.2<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> json </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>com.alibaba<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>fastjson<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>1.2.3<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>org.codehaus.jackson<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>jackson-mapper-asl<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>1.9.13<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>com.fasterxml.jackson.core<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>jackson-annotations<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${jackson.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>com.fasterxml.jackson.core<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>jackson-core<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${jackson.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>com.fasterxml.jackson.core<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>jackson-databind<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>${jackson.version}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> 文件上传 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>commons-io<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>commons-io<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>2.4<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>commons-fileupload<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>commons-fileupload<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>1.2.2<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> ORM映射持久化 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>javax.persistence<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>persistence-api<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>1.0.2<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> sqlserver驱动 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>com.hynnet<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>sqljdbc4-chs<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>4.0.2206.100<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> mysql驱动 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>mysql<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>mysql-connector-java<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>5.1.34<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> atomikos </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>com.atomikos<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>transactions-jdbc<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>3.7.0<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>javax.transaction<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>jta<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>1.1<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>


	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> cglib </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>cglib<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">groupId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>cglib-nodep<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">artifactId</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>3.2.2<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">version</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependency</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">dependencies</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">project</span><span style="color: #0000ff;">&gt;</span></pre>
	<div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div></div>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p><strong>2:web.xml:</strong></p>
	<div class="cnblogs_code"><div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div>
	<pre><span style="color: #0000ff;">&lt;?</span><span style="color: #ff00ff;">xml version="1.0" encoding="UTF-8"</span><span style="color: #0000ff;">?&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">web-app </span><span style="color: #ff0000;">xmlns:xsi</span><span style="color: #0000ff;">="http://www.w3.org/2001/XMLSchema-instance"</span><span style="color: #ff0000;">
	xmlns</span><span style="color: #0000ff;">="http://java.sun.com/xml/ns/javaee"</span><span style="color: #ff0000;"> xmlns:web</span><span style="color: #0000ff;">="http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"</span><span style="color: #ff0000;">
	xsi:schemaLocation</span><span style="color: #0000ff;">="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"</span><span style="color: #ff0000;">
	id</span><span style="color: #0000ff;">="WebApp_ID"</span><span style="color: #ff0000;"> version</span><span style="color: #0000ff;">="2.5"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">welcome-file-list</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">welcome-file</span><span style="color: #0000ff;">&gt;</span>index.jsp<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">welcome-file</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">welcome-file-list</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">display-name</span><span style="color: #0000ff;">&gt;</span>odao-official<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">display-name</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> Spring Application Context Listener &amp; spring-mybaits
	</span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">context-param</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param-name</span><span style="color: #0000ff;">&gt;</span>contextConfigLocation<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param-name</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param-value</span><span style="color: #0000ff;">&gt;</span>classpath:spring-mybatis.xml<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param-value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">context-param</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">listener</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">listener-class</span><span style="color: #0000ff;">&gt;</span>org.springframework.web.context.ContextLoaderListener<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">listener-class</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">listener</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> Spring MVC Config </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">servlet</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">servlet-name</span><span style="color: #0000ff;">&gt;</span>SpringMVC<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">servlet-name</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">servlet-class</span><span style="color: #0000ff;">&gt;</span>org.springframework.web.servlet.DispatcherServlet<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">servlet-class</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">init-param</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param-name</span><span style="color: #0000ff;">&gt;</span>contextConfigLocation<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param-name</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param-value</span><span style="color: #0000ff;">&gt;</span>classpath:spring-mvc.xml<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param-value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">init-param</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">load-on-startup</span><span style="color: #0000ff;">&gt;</span>1<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">load-on-startup</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">servlet</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">servlet-mapping</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">servlet-name</span><span style="color: #0000ff;">&gt;</span>SpringMVC<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">servlet-name</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> Filter all resources </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">url-pattern</span><span style="color: #0000ff;">&gt;</span>/<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">url-pattern</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">servlet-mapping</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> Log4J </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">context-param</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param-name</span><span style="color: #0000ff;">&gt;</span>log4jConfigLocation<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param-name</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param-value</span><span style="color: #0000ff;">&gt;</span>classpath:log4j.properties<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param-value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">context-param</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> Spring Log4J config </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">listener</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">listener-class</span><span style="color: #0000ff;">&gt;</span>org.springframework.web.util.Log4jConfigListener<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">listener-class</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">listener</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> Spring 编码过滤器  </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">filter</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">filter-name</span><span style="color: #0000ff;">&gt;</span>characterEncoding<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">filter-name</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">filter-class</span><span style="color: #0000ff;">&gt;</span>org.springframework.web.filter.CharacterEncodingFilter<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">filter-class</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">init-param</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param-name</span><span style="color: #0000ff;">&gt;</span>encoding<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param-name</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param-value</span><span style="color: #0000ff;">&gt;</span>utf-8<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param-value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">init-param</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">init-param</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param-name</span><span style="color: #0000ff;">&gt;</span>forceEncoding<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param-name</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">param-value</span><span style="color: #0000ff;">&gt;</span>true<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">param-value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">init-param</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">filter</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">filter-mapping</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">filter-name</span><span style="color: #0000ff;">&gt;</span>characterEncoding<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">filter-name</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">url-pattern</span><span style="color: #0000ff;">&gt;</span>/*<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">url-pattern</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">filter-mapping</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">web-app</span><span style="color: #0000ff;">&gt;</span>  </pre>
	<div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div></div>
	<p><strong>3:spring-mybatis.xml:</strong></p>
	<div class="cnblogs_code"><div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div>
	<pre><span style="color: #0000ff;">&lt;?</span><span style="color: #ff00ff;">xml version="1.0" encoding="UTF-8"</span><span style="color: #0000ff;">?&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">beans </span><span style="color: #ff0000;">xmlns</span><span style="color: #0000ff;">="http://www.springframework.org/schema/beans"</span><span style="color: #ff0000;">
	xmlns:context</span><span style="color: #0000ff;">="http://www.springframework.org/schema/context"</span><span style="color: #ff0000;">
	xmlns:xsi</span><span style="color: #0000ff;">="http://www.w3.org/2001/XMLSchema-instance"</span><span style="color: #ff0000;">
	xmlns:aop</span><span style="color: #0000ff;">="http://www.springframework.org/schema/aop"</span><span style="color: #ff0000;">
	xmlns:mvc</span><span style="color: #0000ff;">="http://www.springframework.org/schema/mvc"</span><span style="color: #ff0000;">
	xmlns:jee</span><span style="color: #0000ff;">="http://www.springframework.org/schema/jee"</span><span style="color: #ff0000;">
	xmlns:tx</span><span style="color: #0000ff;">="http://www.springframework.org/schema/tx"</span><span style="color: #ff0000;">
	xsi:schemaLocation</span><span style="color: #0000ff;">="
	http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
	http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd
	http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop.xsd
	http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc.xsd
	http://www.springframework.org/schema/jee http://www.springframework.org/schema/jee/spring-jee.xsd
	http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx.xsd"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;">引入配置属性文件 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">context:property-placeholder </span><span style="color: #ff0000;">location</span><span style="color: #0000ff;">="classpath:jdbc.properties"</span> <span style="color: #0000ff;">/&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> 自动扫描 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">context:component-scan </span><span style="color: #ff0000;">base-package</span><span style="color: #0000ff;">="com.odao"</span> <span style="color: #0000ff;">/&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> 配置连接odao_mobile库的数据源 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">id</span><span style="color: #0000ff;">="odaoMobile"</span><span style="color: #ff0000;"> class</span><span style="color: #0000ff;">="com.atomikos.jdbc.nonxa.AtomikosNonXADataSourceBean"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> value只要两个数据源不同就行，随便取名 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="uniqueResourceName"</span><span style="color: #ff0000;"> value</span><span style="color: #0000ff;">="odaoMobileDB"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="driverClassName"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>${odaoMobile.jdbc.driver}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="url"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>${odaoMobile.jdbc.url}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="user"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>${odaoMobile.jdbc.username}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="password"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>${odaoMobile.jdbc.password}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">bean</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> 配置连接odao_admin库的数据源 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">id</span><span style="color: #0000ff;">="odaoAdmin"</span><span style="color: #ff0000;"> class</span><span style="color: #0000ff;">="com.atomikos.jdbc.nonxa.AtomikosNonXADataSourceBean"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> value只要两个数据源不同就行，随便取名 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="uniqueResourceName"</span><span style="color: #ff0000;"> value</span><span style="color: #0000ff;">="odaoAdminDB"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="driverClassName"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>${odaoAdmin.jdbc.driver}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="url"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>${odaoAdmin.jdbc.url}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="user"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>${odaoAdmin.jdbc.username}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="password"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>${odaoAdmin.jdbc.password}<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">bean</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">id</span><span style="color: #0000ff;">="webSiteSqlSessionFactory"</span><span style="color: #ff0000;"> class</span><span style="color: #0000ff;">="org.mybatis.spring.SqlSessionFactoryBean"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="dataSource"</span><span style="color: #ff0000;"> ref</span><span style="color: #0000ff;">="odaoMobile"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="mapperLocations"</span><span style="color: #ff0000;"> value</span><span style="color: #0000ff;">="classpath:com/odao/dao/website/**/impl/*Mapper.xml"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">bean</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">class</span><span style="color: #0000ff;">="org.mybatis.spring.mapper.MapperScannerConfigurer"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="basePackage"</span><span style="color: #ff0000;"> value</span><span style="color: #0000ff;">="com.odao.dao.website"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="sqlSessionFactoryBeanName"</span><span style="color: #ff0000;"> value</span><span style="color: #0000ff;">="webSiteSqlSessionFactory"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">bean</span><span style="color: #0000ff;">&gt;</span>


	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">id</span><span style="color: #0000ff;">="adminSqlSessionFactory"</span><span style="color: #ff0000;"> class</span><span style="color: #0000ff;">="org.mybatis.spring.SqlSessionFactoryBean"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="dataSource"</span><span style="color: #ff0000;"> ref</span><span style="color: #0000ff;">="odaoAdmin"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="mapperLocations"</span><span style="color: #ff0000;"> value</span><span style="color: #0000ff;">="classpath:com/odao/dao/admin/**/impl/*Mapper.xml"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">bean</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">class</span><span style="color: #0000ff;">="org.mybatis.spring.mapper.MapperScannerConfigurer"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="basePackage"</span><span style="color: #ff0000;"> value</span><span style="color: #0000ff;">="com.odao.dao.admin"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="sqlSessionFactoryBeanName"</span><span style="color: #ff0000;"> value</span><span style="color: #0000ff;">="adminSqlSessionFactory"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">bean</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">id</span><span style="color: #0000ff;">="atomikosTransactionManager"</span><span style="color: #ff0000;"> class</span><span style="color: #0000ff;">="com.atomikos.icatch.jta.UserTransactionManager"</span><span style="color: #ff0000;">
	init-method</span><span style="color: #0000ff;">="init"</span><span style="color: #ff0000;"> destroy-method</span><span style="color: #0000ff;">="close"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="forceShutdown"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>true<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">bean</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">id</span><span style="color: #0000ff;">="atomikosUserTransaction"</span><span style="color: #ff0000;"> class</span><span style="color: #0000ff;">="com.atomikos.icatch.jta.UserTransactionImp"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="transactionTimeout"</span><span style="color: #ff0000;"> value</span><span style="color: #0000ff;">="300"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">bean</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">id</span><span style="color: #0000ff;">="transactionManager"</span><span style="color: #ff0000;"> class</span><span style="color: #0000ff;">="org.springframework.transaction.jta.JtaTransactionManager"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="transactionManager"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">ref </span><span style="color: #ff0000;">bean</span><span style="color: #0000ff;">="atomikosTransactionManager"</span><span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="userTransaction"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">ref </span><span style="color: #ff0000;">bean</span><span style="color: #0000ff;">="atomikosUserTransaction"</span><span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> 必须设置，否则程序出现异常 JtaTransactionManager does not support custom isolation levels by default </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="allowCustomIsolationLevels"</span><span style="color: #ff0000;"> value</span><span style="color: #0000ff;">="true"</span><span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">bean</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">aop:config </span><span style="color: #ff0000;">proxy-target-class</span><span style="color: #0000ff;">="true"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">aop:advisor </span><span style="color: #ff0000;">pointcut</span><span style="color: #0000ff;">="execution(* *com.odao.service..*(..))"</span><span style="color: #ff0000;"> advice-ref</span><span style="color: #0000ff;">="txAdvice"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">aop:config</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">tx:advice </span><span style="color: #ff0000;">id</span><span style="color: #0000ff;">="txAdvice"</span><span style="color: #ff0000;"> transaction-manager</span><span style="color: #0000ff;">="transactionManager"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">tx:attributes</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">tx:method </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="insert*"</span><span style="color: #ff0000;">  propagation</span><span style="color: #0000ff;">="REQUIRED"</span><span style="color: #ff0000;">  read-only</span><span style="color: #0000ff;">="true"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">tx:method </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="add*"</span><span style="color: #ff0000;"> propagation</span><span style="color: #0000ff;">="REQUIRED"</span><span style="color: #ff0000;"> rollback-for</span><span style="color: #0000ff;">="java.lang.Exception"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">tx:method </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="save*"</span><span style="color: #ff0000;">  propagation</span><span style="color: #0000ff;">="REQUIRED"</span><span style="color: #ff0000;">  read-only</span><span style="color: #0000ff;">="true"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">tx:method </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="delete*"</span><span style="color: #ff0000;">  propagation</span><span style="color: #0000ff;">="REQUIRED"</span><span style="color: #ff0000;">  read-only</span><span style="color: #0000ff;">="true"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">tx:method </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="del*"</span><span style="color: #ff0000;">  propagation</span><span style="color: #0000ff;">="REQUIRED"</span><span style="color: #ff0000;">  read-only</span><span style="color: #0000ff;">="true"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">tx:method </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="update*"</span><span style="color: #ff0000;">  propagation</span><span style="color: #0000ff;">="REQUIRED"</span><span style="color: #ff0000;">  read-only</span><span style="color: #0000ff;">="true"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">tx:attributes</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">tx:advice</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">beans</span><span style="color: #0000ff;">&gt;</span></pre>
	<div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div></div>
	<p><span style="color: #ff0000;">注意：上面配置的basePackage属性指定的不同的Mapper文件</span></p>
	<p><strong>4:spring-mvc.xml:</strong></p>
	<div class="cnblogs_code"><div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div>
	<pre><span style="color: #0000ff;">&lt;?</span><span style="color: #ff00ff;">xml version="1.0" encoding="UTF-8"</span><span style="color: #0000ff;">?&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">beans </span><span style="color: #ff0000;">xmlns</span><span style="color: #0000ff;">="http://www.springframework.org/schema/beans"</span><span style="color: #ff0000;">
	xmlns:mvc</span><span style="color: #0000ff;">="http://www.springframework.org/schema/mvc"</span><span style="color: #ff0000;"> xmlns:xsi</span><span style="color: #0000ff;">="http://www.w3.org/2001/XMLSchema-instance"</span><span style="color: #ff0000;">
	xmlns:p</span><span style="color: #0000ff;">="http://www.springframework.org/schema/p"</span><span style="color: #ff0000;"> xmlns:context</span><span style="color: #0000ff;">="http://www.springframework.org/schema/context"</span><span style="color: #ff0000;">
	xsi:schemaLocation</span><span style="color: #0000ff;">="http://www.springframework.org/schema/beans
	http://www.springframework.org/schema/beans/spring-beans-4.1.xsd
	http://www.springframework.org/schema/context
	http://www.springframework.org/schema/context/spring-context-4.1.xsd
	http://www.springframework.org/schema/mvc
	http://www.springframework.org/schema/mvc/spring-mvc-4.1.xsd"</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> 自动扫描该包，使SpringMVC认为包下用了@controller注解的类是控制器 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">context:component-scan </span><span style="color: #ff0000;">base-package</span><span style="color: #0000ff;">="com.odao.controller"</span> <span style="color: #0000ff;">/&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> 避免IE执行AJAX时,返回JSON出现下载文件  </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">id</span><span style="color: #0000ff;">="mappingJacksonHttpMessageConverter"</span><span style="color: #ff0000;"> class</span><span style="color: #0000ff;">="org.springframework.http.converter.json.MappingJackson2HttpMessageConverter"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="supportedMediaTypes"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">list</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>text/html;charset=UTF-8<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">list</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">bean</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> 启动Spring MVC的注解功能，完成请求和注解POJO的映射 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">class</span><span style="color: #0000ff;">="org.springframework.web.servlet.mvc.annotation.AnnotationMethodHandlerAdapter"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="messageConverters"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">list</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> json转换器 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">ref </span><span style="color: #ff0000;">bean</span><span style="color: #0000ff;">="mappingJacksonHttpMessageConverter"</span> <span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">list</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">bean</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> 定义跳转的文件的前后缀 ，视图模式配置</span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">id</span><span style="color: #0000ff;">="viewResolver"</span><span style="color: #ff0000;"> class</span><span style="color: #0000ff;">="org.springframework.web.servlet.view.UrlBasedViewResolver"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="viewClass"</span><span style="color: #ff0000;"> value</span><span style="color: #0000ff;">="org.springframework.web.servlet.view.JstlView"</span><span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="prefix"</span><span style="color: #ff0000;"> value</span><span style="color: #0000ff;">="/WEB-INF/jsp/"</span><span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="suffix"</span><span style="color: #ff0000;"> value</span><span style="color: #0000ff;">=".jsp"</span><span style="color: #0000ff;">/&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">bean</span><span style="color: #0000ff;">&gt;</span>

	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> 配置多文件上传 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">bean </span><span style="color: #ff0000;">id</span><span style="color: #0000ff;">="multipartResolver"</span><span style="color: #ff0000;"> class</span><span style="color: #0000ff;">="org.springframework.web.multipart.commons.CommonsMultipartResolver"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="defaultEncoding"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>UTF-8<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="maxUploadSize"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #008000;">&lt;!--</span><span style="color: #008000;"> 上传文件大小限制为31M，31*1024*1024 </span><span style="color: #008000;">--&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>32505856<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">property </span><span style="color: #ff0000;">name</span><span style="color: #0000ff;">="maxInMemorySize"</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>4096<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">value</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">property</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">bean</span><span style="color: #0000ff;">&gt;</span>
	<span style="color: #0000ff;">&lt;/</span><span style="color: #800000;">beans</span><span style="color: #0000ff;">&gt;</span>  </pre>
	<div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div></div>
	<p><strong>5. jdbc.properties:</strong></p>
	<div class="cnblogs_code"><div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div>
	<pre>#mysql数据库链接<br>odaoAdmin.jdbc.driver=<span style="color: #000000;">com.mysql.jdbc.Driver
	odaoAdmin.jdbc.url</span>=jdbc:mysql:<span style="color: #008000;">//</span><span style="color: #008000;">192.168.1.1:3306/odao_admin?useUnicode=true&amp;characterEncoding=utf8</span>
	odaoAdmin.jdbc.username=<span style="color: #000000;">odao
	odaoAdmin.jdbc.password</span>=<span style="color: #000000;">whattime
	<br></span></pre>
	<pre>#sqlserver数据库链接<span style="color: #000000;">
	odaoMobile.jdbc.driver</span>=<span style="color: #000000;">com.microsoft.sqlserver.jdbc.SQLServerDriver
	odaoMobile.jdbc.url</span>=jdbc:sqlserver:<span style="color: #008000;">//</span><span style="color: #008000;">192.168.1.2:1433;DatabaseName=odao_mobile</span>
	odaoMobile.jdbc.username=<span style="color: #000000;">sa
	odaoMobile.jdbc.password</span>=<span style="color: #000000;">odao<br></span></pre>
	<pre><span style="color: #000000;">validationQuery=SELECT 1</span></pre>
	<pre></pre>
	<div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div></div>
	<p><strong>6.jta.properties:</strong></p>
	<div class="cnblogs_code">
	<pre>com.atomikos.icatch.service=<span style="color: #000000;">com.atomikos.icatch.standalone.UserTransactionServiceFactory
	com.atomikos.icatch.console_file_name </span>=<span style="color: #000000;"> tm.out
	com.atomikos.icatch.log_base_name </span>=<span style="color: #000000;"> tmlog
	com.atomikos.icatch.tm_unique_name </span>=<span style="color: #000000;"> com.atomikos.spring.jdbc.tm
	com.atomikos.icatch.console_log_level </span>=INFO</pre>
	</div>
	<p><span style="color: #ff0000;">注意：jta.properties 文件在你复制的时候可能有空格，记得删掉</span></p>
	<p><strong><span style="color: #000000;">7:log4j.properties:</span></strong></p>
	<div class="cnblogs_code"><div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div>
	<pre><span style="color: #000000;">### set log levels ###
	log4j.rootLogger </span>=<span style="color: #000000;"> Debug , C , D , E

	### console ###
	log4j.appender.C </span>=<span style="color: #000000;"> org.apache.log4j.ConsoleAppender
	log4j.appender.C.Target </span>=<span style="color: #000000;"> System.out
	log4j.appender.C.layout </span>=<span style="color: #000000;"> org.apache.log4j.PatternLayout
	log4j.appender.C.layout.ConversionPattern </span>= [springmvc_mybatis_demo][%p] [%-d{yyyy-MM-dd HH\:mm\:ss}] %C.%M(%L) | %m%<span style="color: #000000;">n

	### log file ###
	log4j.appender.D </span>=<span style="color: #000000;"> org.apache.log4j.DailyRollingFileAppender
	log4j.appender.D.File </span>= ../logs/springmvc-mybatis-<span style="color: #000000;">demo.log
	log4j.appender.D.Append </span>= <span style="color: #0000ff;">true</span><span style="color: #000000;">
	log4j.appender.D.Threshold </span>=<span style="color: #000000;"> INFO
	log4j.appender.D.layout </span>=<span style="color: #000000;"> org.apache.log4j.PatternLayout
	log4j.appender.D.layout.ConversionPattern </span>= [springmvc_mybatis_demo][%p] [%-d{yyyy-MM-dd HH\:mm\:ss}] %C.%M(%L) | %m%<span style="color: #000000;">n

	### exception ###
	log4j.appender.E </span>=<span style="color: #000000;"> org.apache.log4j.DailyRollingFileAppender
	log4j.appender.E.File </span>= ../logs/springmvc-mybatis-<span style="color: #000000;">demo_error.log
	log4j.appender.E.Append </span>= <span style="color: #0000ff;">true</span><span style="color: #000000;">
	log4j.appender.E.Threshold </span>=<span style="color: #000000;"> ERROR
	log4j.appender.E.layout </span>=<span style="color: #000000;"> org.apache.log4j.PatternLayout
	log4j.appender.E.layout.ConversionPattern </span>=[sspringmvc_mybatis_demo][%p] [%-d{yyyy-MM-dd HH\:mm\:ss}] %C.%M(%L) | %m%n  </pre>
	<div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div></div>
	<p><strong>8. 控制层 UserInfoController.java :</strong></p>
	<div class="cnblogs_code"><div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div>
	<pre><span style="color: #0000ff;">package</span><span style="color: #000000;"> com.odao.controller.user;

	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> java.util.List;
	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> javax.servlet.http.HttpServletRequest;
	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> javax.servlet.http.HttpServletResponse;
	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> org.springframework.beans.factory.annotation.Autowired;
	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> org.springframework.stereotype.Controller;
	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> org.springframework.web.bind.annotation.RequestMapping;
	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> org.springframework.web.bind.annotation.ResponseBody;
	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> org.springframework.web.servlet.ModelAndView;
	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> com.odao.entity.UserInfo;
	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> com.odao.service.website.UserService;

	@Controller
	@RequestMapping(</span>"/user/"<span style="color: #000000;">)
	</span><span style="color: #0000ff;">public</span> <span style="color: #0000ff;">class</span><span style="color: #000000;"> UserInfoController {

	@Autowired
	</span><span style="color: #0000ff;">private</span><span style="color: #000000;"> UserService userService;

	@RequestMapping(</span>"userInfoList.do"<span style="color: #000000;">)
	</span><span style="color: #0000ff;">public</span><span style="color: #000000;"> ModelAndView getUserInfoList(HttpServletRequest request, HttpServletResponse response){
	ModelAndView modelAndView </span>= <span style="color: #0000ff;">new</span> ModelAndView("user/userInfoList"<span style="color: #000000;">);
	List</span>&lt;UserInfo&gt; userInfoList =<span style="color: #000000;"> userService.selectAll();
	List</span>&lt;UserInfo&gt; userInfo =<span style="color: #000000;"> userService.selectUser();
	modelAndView.addObject(</span>"userName",userInfoList.get(0).getTest_id()+"===="+userInfo.get(0<span style="color: #000000;">).getTest_name());
	</span><span style="color: #0000ff;">return</span><span style="color: #000000;"> modelAndView;
	}

	@ResponseBody
	@RequestMapping(</span>"updateUserInfo.do"<span style="color: #000000;">)
	</span><span style="color: #0000ff;">public</span><span style="color: #000000;"> ModelAndView updateUserInfo(HttpServletRequest request, HttpServletResponse response){
	ModelAndView modelAndView </span>= <span style="color: #0000ff;">new</span> ModelAndView("user/userInfoList"<span style="color: #000000;">);
	UserInfo user </span>= <span style="color: #0000ff;">new</span><span style="color: #000000;"> UserInfo();
	user.setTest_id(</span>1<span style="color: #000000;">);
	user.setTest_name(</span>"嗯~有耐心看到这里的都帅"<span style="color: #000000;">);;
	userService.saveUser(user);
	</span><span style="color: #0000ff;">return</span><span style="color: #000000;"> modelAndView;
	}
	}</span></pre>
	<div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div></div>
	<p><strong>9.业务逻辑层：UserService.java:</strong></p>
	<div class="cnblogs_code"><div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div>
	<pre><span style="color: #0000ff;">package</span><span style="color: #000000;"> com.odao.service.website;

	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> java.util.List;
	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> org.springframework.beans.factory.annotation.Autowired;
	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> org.springframework.stereotype.Service;
	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> com.odao.dao.admin.user.AdminUserInfoDao;
	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> com.odao.dao.website.user.WebSiteUserInfoDao;
	</span><span style="color: #0000ff;">import</span><span style="color: #000000;"> com.odao.entity.UserInfo;

	@Service
	</span><span style="color: #0000ff;">public</span> <span style="color: #0000ff;">class</span><span style="color: #000000;"> UserService  {

	@Autowired
	</span><span style="color: #0000ff;">private</span><span style="color: #000000;"> WebSiteUserInfoDao websiteUserInfoDao;

	@Autowired
	</span><span style="color: #0000ff;">private</span><span style="color: #000000;"> AdminUserInfoDao adminUserInfoDao;

	</span><span style="color: #0000ff;">public</span> List&lt;UserInfo&gt;<span style="color: #000000;"> selectAll() {
	</span><span style="color: #0000ff;">return</span><span style="color: #000000;"> websiteUserInfoDao.selectAll();
	}

	</span><span style="color: #0000ff;">public</span> List&lt;UserInfo&gt;<span style="color: #000000;"> selectUser() {
	</span><span style="color: #0000ff;">return</span><span style="color: #000000;"> adminUserInfoDao.selectUser();
	}
	<br>
	</span><span style="color: #0000ff;">public</span> <span style="color: #0000ff;">void</span><span style="color: #000000;"> saveUser(UserInfo userInfo){
	websiteUserInfoDao.saveUser(userInfo);<br>　　　　 //测试操作不同数据库时，事物回滚的一致性(要么都成功，要么都失败)<br>　　　　 if(1==1){<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throw new NullPointerException();<br>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}
	adminUserInfoDao.saveUser(userInfo);
	}

	}</span></pre>
	<div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a href="javascript:void(0);" onclick="copyCnblogsCode(this)" title="复制代码"><img src="//common.cnblogs.com/images/copycode.gif" alt="复制代码"></a></span></div></div>
	<p>整个项目大致就这样，entity跟dao就不贴了，你们看方法也能猜到，图片上的transaction-context.xml文件内容我给弄到了spring-mybatis.xml里面，就是一些关于分布式事物的</p>
	<p>码字不容易，转载请注明出处，谢谢。。。。。</p></div>
	</body>
</html>
