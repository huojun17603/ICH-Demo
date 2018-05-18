package com.ich.view.controller;

import com.ich.admin.controller.AdminController;
import com.ich.core.base.JsonUtils;
import com.ich.core.http.entity.HttpEasyUIResponse;
import com.ich.core.http.entity.HttpResponse;
import com.ich.module.annotation.Link;
import com.ich.view.pojo.Adv;
import com.ich.view.service.AdvService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("adv")
public class AdvController extends AdminController {

    @Autowired
    private AdvService advService;

    /**
     * 广告列表
     */
    @RequestMapping(value="list",produces=MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-context-adv-list", level = Link.LEVEL_READ, name = "广告管理-列表", parent = "admin-context-adv-index")
    public String list(HttpServletRequest request,String callback){
        HttpEasyUIResponse response = new HttpEasyUIResponse(HttpEasyUIResponse.HTTP_OK,HttpEasyUIResponse.HTTP_MSG_OK,null);
		List<Adv> list = advService.findAllAdv();
		response.setRows(list);
		response.setTotal(list.size());
        return callback(callback, JsonUtils.objectToJson(response));
    }

    /**
     * 新增广告
     */
    @RequestMapping(value="addOrEdit",produces=MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-context-adv-addOrEdit", level = Link.LEVEL_WRITE, name = "广告管理-新增广告", parent = "admin-context-adv-index")
    public String add(HttpServletRequest request, Adv adv, String callback){
        HttpResponse result = advService.addOrEditAdv(adv);
        return callback(callback, JsonUtils.objectToJson(result));
    }


    /**
     * 删除广告
     */
    @RequestMapping(value="delete",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-context-adv-delete", level = Link.LEVEL_DETELE, name = "广告管理-删除广告", parent = "admin-context-adv-index")
    public String delete(HttpServletRequest request, String ids, String callback){
        HttpResponse response = advService.deleteAdvs(ids);
        return callback(callback,JsonUtils.objectToJson(response));
    }


}
