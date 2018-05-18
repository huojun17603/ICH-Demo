package com.ich.view.controller;

import com.ich.admin.controller.AdminController;
import com.ich.core.base.JsonUtils;
import com.ich.core.base.ObjectHelper;
import com.ich.core.http.entity.HttpEasyUIResponse;
import com.ich.core.http.entity.HttpResponse;
import com.ich.core.http.entity.PageView;
import com.ich.module.annotation.Link;
import com.ich.view.pojo.Adv;
import com.ich.view.pojo.Notice;
import com.ich.view.pojo.NoticeClass;
import com.ich.view.service.NoticeClassService;
import com.ich.view.service.NoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("notice")
public class NoteController extends AdminController {

    @Autowired
    private NoticeService noticeService;

    @RequestMapping(value="query",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-context-notice-query", level = Link.LEVEL_READ, name = "文章管理-查询列表", parent = "admin-context-notice-index")
    public String query(HttpServletRequest request, PageView view, Long classid, String keyword,String postion,String author,String searchkey, String callback){
        HttpEasyUIResponse response = new HttpEasyUIResponse(HttpEasyUIResponse.HTTP_OK,HttpEasyUIResponse.HTTP_MSG_OK,null);
        List<Notice> list = noticeService.queryByAdminCondition(view,classid,keyword,postion,author,searchkey);
        response.setRows(list);
        response.setTotal(view.getRowCount());
        return callback(callback, JsonUtils.objectToJson(response));
    }

    @RequestMapping(value="detail",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-context-notice-detail", level = Link.LEVEL_READ, name = "文章管理-查询列表", parent = "admin-context-notice-index")
    public String detail(HttpServletRequest request, Long id ,  String callback){
        Notice notice = noticeService.findById(id);
        return callback(callback, JsonUtils.objectToJson(getSuccessMap(notice)));
    }

    @RequestMapping(value="addOrEdit",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-context-notice-addOrEdit", level = Link.LEVEL_WRITE, name = "文章管理-新增修改", parent = "admin-context-notice-index")
    public String addOrEdit(Notice notice, String callback){
        HttpResponse result = this.noticeService.addOrEditNotice(notice);
        return callback(callback,JsonUtils.objectToJson(result));
    }

    @RequestMapping(value="editstatus",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-context-notice-editstatus", level = Link.LEVEL_EDIT, name = "文章管理-修改状态", parent = "admin-context-notice-index")
    public String editstatus(Long id , Integer status ,String callback){
        HttpResponse result = this.noticeService.editNoticeStatus(id,status);
        return callback(callback,JsonUtils.objectToJson(result));
    }

    @RequestMapping(value="delete",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-context-notice-delete", level = Link.LEVEL_DETELE, name = "文章管理-删除", parent = "admin-context-notice-index")
    public String delete(Long id ,String callback){
        HttpResponse result = this.noticeService.deleteNotice(id);
        return callback(callback,JsonUtils.objectToJson(result));
    }
}
