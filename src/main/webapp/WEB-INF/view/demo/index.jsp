<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html>
    <head>
        <!-- 无缓存配置 -->
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta charset="{CHARSET}">
        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="cache-control" content="no-cache">
        <meta http-equiv="expires" content="0">
    <script type="text/javascript" src="/script/jquery-1.8.3.min.js"></script>
    <style>
        .ss{dissd}
    </style>
    </head>
    <script type="text/javascript">
    //AJAX 全局配置
    $.ajaxSetup({
        async:true,
        error:function(jqXHR, textStatus, errorThrown){
        var msg = $.parseJSON(jqXHR.responseText).error;
            $.messager.alert('系统错误',msg,'error');
        },
        traditional : true,
        dataType : "json",
        type : "POST"
    });
    </script>
    <script type="text/javascript">


    function addSubmit(){
        //这种方案，导致Date类型的无法正确传入！！！！
        document.getElementById("formid").submit();
    }

    function addDemo(){
        var name = $('#name').val();
        var age = $('#age').val();
        var birthday = new Date($('#birthday').val());//我们需要一个专门的函数来处理时间
        var state = $('#state').val();
        var balance = $('#balance').val();
        var info = $('#info').val();
        $.ajax({
           // url:"http://localhost:8080/demo/addJsonp",
            //dataType : "jsonp",
            url:"/demo/addJsonp",
            data:{name:name,age:age,birthday:birthday,state:state,balance:balance,info:info},
            success:function(result){
                alert("新增数据ID为："+result.data.id);
            }
        });
    }
    function findJSONP(){
        $.ajax({
            url:"http://localhost:8080/demo/findJsonp",
            dataType : "jsonp",
            data:{id:123},
            success:function(result){
            $("#sp1").text(result.data.birthday);
            }
        });
    }
    function findJSON(){
        $.ajax({
            //url:"http://localhost:8080/demo/findJsonp",
            //dataType : "jsonp",
            url:"/demo/findJsonp",
            //dataType : "json",
            data:{id:123},
            success:function(result){
                $("#sp1").text(result.data.birthday);
            }
        });
    }

    function adderror(){
        var name = $('#name').val();
        $.ajax({
            url:"/demo/adderror",
            data:{name:name},
            success:function(result){
                alert(result.msg);
            }
        });
    }
    function adderrorp(){
        var name = $('#name').val();
        $.ajax({
            url:"http://localhost:8080/demo/adderror",
            dataType : "jsonp",
            data:{name:name},
            success:function(result){
            alert(result.msg);
            }
        });
    }
    function adderrorx(){
        var name = $('#name').val();
        $.ajax({
            url:"/demo/adderrorx",
            data:{name:name},
            success:function(result){
                alert(result.msg);
            }
        });
    }
    function adderrorz(){
        window.location.href="/demo/adderrorz";
    }
    function query(){
        var page = $('#page').val();
        var rows = $('#rows').val();
        window.location.href="/demo/index?page="+page+"&rows="+rows;
    }
    function doexport(){
        window.open("/demo/export");
    }
    </script>
<body>
    <div a></div>
    <div>
        <h2>测试用例页面</h2>
    </div>
    <div>
        <div>
            <h2>新增请求：</h2>
            <div>
                <form id="formid" action="/demo/addSubmit">
                    <span>名称：</span><input id="name" name="name" type="text" >
                    <span>年龄：</span><input id="age" name="age" type="text" >
                    <span>生日：</span><input id="birthday" name="" type="text" >
                    <span>状态：</span><input id="state" name="state" type="text" >
                    <span>价值：</span><input id="balance" name="balance" type="text" >
                    <span>简介：</span><input id="info" name="info" type="text" >
                </form>
            </div>
            <button onclick="addDemo()">新增(AJAX)</button>
            <button onclick="addSubmit()">新增(SUBMIT)</button>
            <button onclick="adderror()">错误后事务回滚测试(JSON)</button>
            <button onclick="adderrorp()">错误后事务回滚测试(JSONP)</button>
            <button onclick="adderrorz()">抛出错误(同步)</button>
            <button onclick="adderrorx()">抛出错误(异步)</button>
        </div>
        <div>
            <h2>查询请求：</h2>
            <button onclick="findJSON()">查询(最优AJAX查询方案JSON)</button>
            <button onclick="findJSONP()">查询(最优AJAX查询方案JSONP)</button>
            <div>注：AJAX请求返回的日期格式：<span id="sp1"></span></div>
        </div>
    <div>
    <h2>导出/导入：</h2>
        <button onclick="doexport()">导出(必须有最大限制)</button>
    </div>
    </div>


    <div>
        <h2>页面请求效果：</h2>
        <span>页数：</span><input id="page" type="text" >
        <span>页面大小：</span><input id="rows" type="text" >
        <input type="button" value="确定" onclick="query()">
        <table>
            <tr>
                <td>ID</td>
                <td>名称</td>
                <td>年龄</td>
                <td>状态</td>
                <td>余额</td>
                <td>生日</td>
                <td>生日2</td>
                <td>简介</td>
            </tr>
            <c:forEach items="${rows}" var="item" varStatus="count">
            <tr>
                <td>${item.id}</td>
                <td>${item.name}</td>
                <td>${item.age}</td>
                <td>${item.state?"真":"假"}</td>
                <td>${item.balance}</td>
                <td>${item.birthday}</td>
                <td> <fmt:formatDate value="${item.birthday}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td>${item.info}</td>
             </tr>
            </c:forEach>

        </table>
    </div>
</body>
</html>
