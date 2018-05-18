package com.ich.view.controller;

import com.ich.admin.controller.AdminController;
import com.ich.core.base.JsonUtils;
import com.ich.core.base.TimeUtil;
import com.ich.core.http.entity.HttpEasyUIResponse;
import com.ich.core.http.entity.HttpResponse;
import com.ich.module.annotation.Link;
import com.ich.view.pojo.Adv;
import com.ich.view.pojo.Inform;
import com.ich.view.service.InformService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("inform")
public class InformController extends AdminController {
    
    @Autowired
    private InformService informService;
    /**
     * 公告列表
     */
    @RequestMapping(value="list",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-context-inform-list", level = Link.LEVEL_READ, name = "公告管理-列表", parent = "admin-context-inform-index")
    public String delete(HttpServletRequest request,String callback){
        HttpEasyUIResponse response = new HttpEasyUIResponse(HttpEasyUIResponse.HTTP_OK,HttpEasyUIResponse.HTTP_MSG_OK,null);
        List<Inform> list = informService.findAllInform();
        response.setRows(list);
        response.setTotal(list.size());
        return callback(callback, JsonUtils.objectToJson(response));
    }

    /**
     * 新增公告
     */
    @RequestMapping(value="addOrEdit",produces=MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-context-inform-addOrEdit", level = Link.LEVEL_WRITE, name = "公告管理-新增公告", parent = "admin-context-inform-index")
    public String add(HttpServletRequest request, Inform inform,String etime, String callback){
        inform.setEndtime(TimeUtil.parse(etime));
        HttpResponse result = informService.addOrEditInform(inform);
        return callback(callback, JsonUtils.objectToJson(result));
    }

    /**
     * 取消公告
     */
    @RequestMapping(value="cancel",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-context-inform-cancel", level = Link.LEVEL_DETELE, name = "公告管理-取消公告", parent = "admin-context-inform-index")
    public String cancel(HttpServletRequest request, Long id, String callback){
        HttpResponse response = informService.cancelInform(id);
        return callback(callback,JsonUtils.objectToJson(response));
    }

    /**
     * 删除公告
     */
    @RequestMapping(value="delete",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-context-inform-delete", level = Link.LEVEL_DETELE, name = "公告管理-删除公告", parent = "admin-context-inform-index")
    public String delete(HttpServletRequest request, String ids, String callback){
        HttpResponse response = informService.deleteInforms(ids);
        return callback(callback,JsonUtils.objectToJson(response));
    }
}
