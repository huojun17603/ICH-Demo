package com.ich.system.controller;

import com.ich.admin.controller.AdminController;
import com.ich.core.base.JsonUtils;
import com.ich.core.http.entity.HttpEasyUIResponse;
import com.ich.core.http.entity.HttpResponse;
import com.ich.core.http.entity.PageView;
import com.ich.extend.service.IFeedbackService;
import com.ich.module.annotation.Link;
import com.ich.system.service.FeedbackAService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("admin/feedback")
public class FeedbackMController extends AdminController {

    @Autowired
    private FeedbackAService feedbackAService;

    /** 处理 */
    @RequestMapping(value="handle",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-customer-service-feedback-handle", level = Link.LEVEL_WRITE, name = "反馈-处理", parent = "admin-customer-service-feedback")
    public String handle(String id,String handlermark, String callback){
        HttpResponse response = feedbackAService.updateFeedbackOfHandle(id,handlermark);
        return callback(callback,response);
    }

    /** 反馈列表 */
    @RequestMapping(value="list",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-customer-service-feedback-list", level = Link.LEVEL_WRITE, name = "反馈-列表", parent = "admin-customer-service-feedback")
    public String list(PageView view, String searchkey, String callback){
        Map<String,Object> model = getSuccessMap();
        List<Map<String,Object>> list = feedbackAService.queryFeedback(view,searchkey);
        model.put(HttpEasyUIResponse.HTTP_DATA_PAGE_TOTAL, view.getRowCount());
        model.put(HttpEasyUIResponse.HTTP_DATA_PAGE_ROWS, list);
        return callback(callback, JsonUtils.objectToJson(model));
    }

}
