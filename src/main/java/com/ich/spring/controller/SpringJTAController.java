package com.ich.spring.controller;

import com.ich.core.base.JsonUtils;
import com.ich.core.http.controller.CoreController;
import com.ich.core.http.entity.HttpResponse;
import com.ich.spring.service.SpringJTAService;
import com.uu.storea.mapper.DemoAMapper;
import com.uu.storea.pojo.DemoA;
import com.uu.storea.pojo.DemoAExample;
import com.uu.storeb.mapper.DemoBMapper;
import com.uu.storeb.pojo.DemoB;
import com.uu.storeb.pojo.DemoBExample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Spring JTA : atomikos
 *
 */
@Controller
@RequestMapping("spring/jta")
public class SpringJTAController extends CoreController {

    @Autowired
    SpringJTAService springJTAService;

    /** 数据库A查询 */
    @RequestMapping(value="findA",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String findA(String callback){
        List<DemoA> list = springJTAService.findA();
        HttpResponse response = new HttpResponse(HttpResponse.HTTP_OK,HttpResponse.HTTP_MSG_OK,list);
        return callback(callback, JsonUtils.objectToJson(response));
    }
    /** 数据库B查询 */
    @RequestMapping(value="findB",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String findB(String callback){
        List<DemoB> list = springJTAService.findB();
        HttpResponse response = new HttpResponse(HttpResponse.HTTP_OK,HttpResponse.HTTP_MSG_OK,list);
        return callback(callback, JsonUtils.objectToJson(response));
    }

    /** 分布式数据库事务处理 */
    @RequestMapping(value="addData",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String addData(String name,String callback){
        HttpResponse response = springJTAService.addData(name);
        return callback(callback, JsonUtils.objectToJson(response));
    }

    /** 分布式数据库异常回滚 */
    @RequestMapping(value="exception",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String exception(String name,String callback){
        name = "ex";
        HttpResponse response = springJTAService.addData(name);
        return callback(callback, JsonUtils.objectToJson(response));
    }

}
