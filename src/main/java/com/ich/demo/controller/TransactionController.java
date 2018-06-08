package com.ich.demo.controller;

import com.ich.core.base.JsonUtils;
import com.ich.core.http.controller.CoreController;
import com.ich.core.http.entity.HttpResponse;
import com.ich.demo.service.DemoService;
import com.ich.demo.service.Dome2Service;
import com.ich.extend.pojo.IFeedback;
import com.ich.module.annotation.Window;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("transaction")
public class TransactionController extends CoreController {

    @Autowired
    private DemoService demoService;
    @Autowired
    private Dome2Service deme2Service;


    //新增后，异常，回滚
    @RequestMapping(value="addBack",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String addBack(String id,String callback){
//        HttpResponse response = demoService.addBacks(id);
        HttpResponse response = deme2Service.addBack(id);
        return callback(callback, JsonUtils.objectToJson(response));
    }

    @RequestMapping(value="editBack",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String editBack(String id,String callback){
        HttpResponse response = demoService.editBack(id);
        return callback(callback, JsonUtils.objectToJson(response));
    }

    @RequestMapping(value="find",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String findJSONPDemo(String id,String callback){
        IFeedback feedback = demoService.findBack(id);
        return callback(callback, JsonUtils.objectToJson(feedback));
    }

}
