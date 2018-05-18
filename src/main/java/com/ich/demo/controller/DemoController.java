package com.ich.demo.controller;

import com.ich.core.base.JsonUtils;
import com.ich.core.base.ObjectHelper;
import com.ich.core.file.ExcelUtil;
import com.ich.core.http.controller.CoreController;
import com.ich.core.http.entity.HttpResponse;
import com.ich.core.http.entity.PageView;
import com.ich.demo.pojo.DemoTest;
import com.ich.demo.service.DemoService;
import com.ich.module.annotation.Window;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/7/3 0003.
 * 页面跳转，FORM表单提交，AJAX(JSON/JSONP)
 * 请求日志，系统配置
 * 操作记录，审核什么的应该是权限来管理的
 * 文件上传，图片上传，图片裁剪
 * 导出，导入
 *
 */
@Controller
@RequestMapping("demo")
public class DemoController extends CoreController{

    @Autowired
    private DemoService demoService;

    @RequestMapping("index")
    public ModelAndView index(PageView pageView){
        Map<String,Object> model = new HashMap<String,Object>();
        List<Map<String,Object>> result = demoService.queryDemos(pageView);
        model.put("rows",result);
        return new ModelAndView("demo/index",model);
    }

    /**
     * 错误方案
     */
    @RequestMapping("find")
    @ResponseBody
    public String findDemo(Long id){
        HttpResponse response  = demoService.findDemoById(id);
        return JsonUtils.objectToJson(response);
    }

    /**
     * JSON请求基本解决方案
     * 注意：必有在@RequestMapping中加入produces，这样才会返回一个JSON类型的头信息，浏览器才会自动解析
     * @param id 数据ID
     * @return 返回JSON字符串
     */
    @RequestMapping(value="findJson",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Window(name="窗口1",code="ck1",include = "/",modular = "ICH-ADMIN")
    public String findJSONDemo(Long id){
        HttpResponse response  = demoService.findDemoById(id);
        return JsonUtils.objectToJson(response);
    }

    /**
     * JSONP的跨域查询解决方案，此方案也支持JSON的基本请求，推荐使用
     * @param id 数据ID
     * @param callback JSONP返回函数，这个是必须有的
     * @return 返回必须包含 callback()
     */
    @RequestMapping(value="findJsonp",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Window(name="窗口2",code="ck2",include = "/",modular = "shop")
    public String findJSONPDemo(Long id,String callback){
        HttpResponse response  = demoService.findDemoById(id);
        return callback(callback,JsonUtils.objectToJson(response));
    }

    @RequestMapping("add")
    @ResponseBody
    public String addDemo(DemoTest demoTest){
        HttpResponse response  = demoService.addDemo(demoTest);
        return JsonUtils.objectToJson(response);
    }

    /**
     * JSONP的跨域新增解决方案，此方案也支持JSON的基本请求，推荐使用
     * @param demoTest 数据
     * @param callback JSONP返回函数，这个是必须有的
     * @return 返回必须包含 callback()
     */
    @RequestMapping(value="addJsonp",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String addJSONPDemo(DemoTest demoTest,String callback){
        HttpResponse response  = demoService.addDemo(demoTest);
        return callback(callback,JsonUtils.objectToJson(response));
    }

    /**
     * 不建议Submit提交
     */
    @RequestMapping(value="addSubmit",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    public ModelAndView addSubmit(DemoTest demoTest){
        Map<String,Object> model = new HashMap<String,Object>();
        List<Map<String,Object>> result = demoService.queryDemos(new PageView());
        model.put("rows",result);
        return new ModelAndView("demo/index",model);
    }



    @RequestMapping(value="adderror",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String adderror(DemoTest demoTest,String callback){
        HttpResponse response  = demoService.addErrorDemo(demoTest);
        if(ObjectHelper.isEmpty(callback)){
            return JsonUtils.objectToJson(response);
        }else{
            return callback+"("+JsonUtils.objectToJson(response)+");";
        }
    }

    @RequestMapping(value="adderrorx",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String adderrorx(DemoTest demoTest,String callback){
        HttpResponse response  = demoService.addErrorDemox(demoTest);
        if(ObjectHelper.isEmpty(callback)){
            return JsonUtils.objectToJson(response);
        }else{
            return callback+"("+JsonUtils.objectToJson(response)+");";
        }
    }

    @RequestMapping(value="adderrorz",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    public ModelAndView adderrorz(DemoTest demoTest){
        HttpResponse response  = demoService.addErrorDemoz(demoTest);
        return new ModelAndView("demo/index");
    }

    @RequestMapping(value="export",produces=MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public void export(HttpServletRequest request, HttpServletResponse response, PageView pageView,String callback){
        List<Map<String,Object>> list = demoService.queryDemos(pageView);
        Map<String,String> headMap = new LinkedHashMap<String,String>();
        String title = "用户统计表";
        headMap.put("id", "ID");
        headMap.put("name", "姓名");
        headMap.put("age", "年龄");
        headMap.put("birthday", "生日");
        headMap.put("state", "状态");
        headMap.put("balance", "余额");
        headMap.put("info", "简介");
        ExcelUtil.downloadExcelFile(title,headMap,list,response);
    }

}
