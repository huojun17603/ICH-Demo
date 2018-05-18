package com.ich.spring.controller;

import com.ich.core.base.JsonUtils;
import com.ich.core.http.controller.CoreController;
import com.ich.core.http.entity.HttpResponse;
import com.ich.spring.service.SpringRetryService;
import com.uu.storea.pojo.DemoA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("spring/retry")
public class SpringRetryController extends CoreController {

    @Autowired
    SpringRetryService springRetryService;

    /** 重试测试 */
    @RequestMapping(value="execute",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String execute(String callback) throws Exception{
        HttpResponse response = springRetryService.execute();
        return callback(callback, JsonUtils.objectToJson(response));
    }

}
