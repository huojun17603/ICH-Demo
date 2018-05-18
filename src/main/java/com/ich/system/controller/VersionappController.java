package com.ich.system.controller;

import com.ich.admin.controller.AdminController;
import com.ich.core.base.JsonUtils;
import com.ich.core.http.entity.HttpEasyUIResponse;
import com.ich.core.http.entity.HttpResponse;
import com.ich.core.http.entity.PageView;
import com.ich.module.annotation.Link;
import com.ich.version.pojo.Versionapp;
import com.ich.version.service.VersionappService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("admin/versionapp")
public class VersionappController extends AdminController {

    @Autowired
    private VersionappService versionappService;

    /** 查询最新版本 */
    @RequestMapping(value="obtain/newest",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String obtainNewest(String equipment,String appname,String callback){
        Versionapp versionapp = versionappService.findByNewest(equipment,appname);
        HttpResponse response = new HttpResponse(HttpResponse.HTTP_OK,HttpResponse.HTTP_MSG_OK,versionapp);
        return callback(callback,response);
    }

    /** 查询历史版本列表 */
    @RequestMapping(value="obtain/history",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String obtainHistory(String equipment,String appname,String callback){
        List<Versionapp> versionapp = versionappService.findByHistory(equipment,appname);
        HttpResponse response = new HttpResponse(HttpResponse.HTTP_OK,HttpResponse.HTTP_MSG_OK,versionapp);
        return callback(callback,response);
    }

    /** 分页查询列表 */
    @RequestMapping(value="list",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-system-versionapp-list", level = Link.LEVEL_READ, name = "版本管理-分页列表", parent = "admin-system-versionapp")
    public String list(PageView view,String equipment,String appname,String callback){
        List<Versionapp> list = versionappService.queryVersion(view,equipment,appname);
        Map<String,Object> model = getSuccessMap();
        model.put(HttpEasyUIResponse.HTTP_DATA_PAGE_TOTAL, view.getRowCount());
        model.put(HttpEasyUIResponse.HTTP_DATA_PAGE_ROWS, list);
        return callback(callback,JsonUtils.objectToJson(model));
    }

    /** 新增或修改，有效状态：待发布；版本号不允许重复 */
    @RequestMapping(value="addOrEdit",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-system-versionapp-add", level = Link.LEVEL_WRITE, name = "版本管理-新增修改", parent = "admin-system-versionapp")
    public String addVersion(Versionapp versionapp,String callback){
        HttpResponse response = versionappService.addOrEdit(versionapp);
        return callback(callback,response);
    }

    /**  发布最新版本 */
    @RequestMapping(value="release",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-system-versionapp-release", level = Link.LEVEL_EDIT, name = "版本管理-版本发布", parent = "admin-system-versionapp")
    public String release(Long id,String callback){
        HttpResponse response = versionappService.editToNewest(id);
        return callback(callback, response);
    }

    /**  删除未发布的版本 */
    @RequestMapping(value="delete",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-system-versionapp-delete", level = Link.LEVEL_EDIT, name = "版本管理-版本删除", parent = "admin-system-versionapp")
    public String delete(Long id,String callback){
        HttpResponse response = versionappService.deleteVersion(id);
        return callback(callback,response);
    }

}
