package com.ich.spring.controller;

import com.ich.core.base.JsonUtils;
import com.ich.core.http.controller.CoreController;
import com.ich.core.http.entity.HttpResponse;
import com.ich.module.annotation.Window;
import com.ich.spring.service.SpringCacheService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * Spring's Cache abstraction
 * Dependency:spring-context-4.1.+.jar
 * Configure:spring-cache.xml
 */
@Controller
@RequestMapping("spring/cache")
public class SpringCacheController extends CoreController{

    @Autowired
    private SpringCacheService springCacheService;

    /** 获取数据/缓存 **/
    @RequestMapping(value="find",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String find(Long id,String callback){

        HttpResponse response  = springCacheService.findById(id);
        return callback(callback, JsonUtils.objectToJson(response));
    }

    /** 更新缓存 **/
    @RequestMapping(value="update",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String update(Long id,String callback){
        HttpResponse response  = springCacheService.update(id);
        return callback(callback, JsonUtils.objectToJson(response));
    }

    /** 移除缓存 **/
    @RequestMapping(value="remove",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String remove(Long id,String callback){
        HttpResponse response  = springCacheService.remove(id);
        return callback(callback, JsonUtils.objectToJson(response));
    }
}
