package com.ich.view.controller;

import com.ich.admin.controller.AdminController;
import com.ich.core.base.JsonUtils;
import com.ich.core.base.ObjectHelper;
import com.ich.core.http.entity.HttpResponse;
import com.ich.module.annotation.Link;
import com.ich.view.dto.NoticeClassTree;
import com.ich.view.pojo.NoticeClass;
import com.ich.view.pojo.ViewPostion;
import com.ich.view.pojo.ViewTag;
import com.ich.view.service.NoticeClassService;
import com.ich.view.service.ViewPostionService;
import com.ich.view.service.ViewTagService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("noteclass")
public class NoteClassController extends AdminController{

    @Autowired
    private NoticeClassService noticeClassService;
    @Autowired
    private ViewPostionService postionService;
    @Autowired
    private ViewTagService tagService;

    @RequestMapping(value="tree",produces=MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(name = "文章分类-树",code = "admin-context-noteclass-tree",
            level = Link.LEVEL_READ, parent = "admin-context-noteclass-index")
    public String tree(HttpServletRequest request,Long id,String callback){
        List<NoticeClassTree> list = noticeClassService.findClassTreeByPid(id);
        return callback(callback, JsonUtils.objectToJson(list));
    }

    @RequestMapping(value="saveOrUpdate",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(name = "文章分类-新增修改",code = "admin-context-noteclass-saveOrUpdate",
            level = Link.LEVEL_WRITE,  parent = "admin-context-noteclass-index")
    public String add(NoticeClass noticeClass, String callback){
        if(ObjectHelper.isEmpty(noticeClass.getId())){
            HttpResponse result = this.noticeClassService.addClass(noticeClass);
            return callback(callback,JsonUtils.objectToJson(result));
        }else{
            HttpResponse result = this.noticeClassService.updateClass(noticeClass);
            return callback(callback,JsonUtils.objectToJson(result));
        }
    }

    @RequestMapping(value="delete",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(name = "文章分类-删除",code = "admin-context-noteclass-delete",
            level = Link.LEVEL_DETELE,  parent = "admin-context-noteclass-index")
    public String delete(Long id,String callback){
        HttpResponse result = this.noticeClassService.deleteClass(id);
        return callback(callback,JsonUtils.objectToJson(result));
    }
    /**
     * 读取文章标签列表
     */
    @RequestMapping(value="tags",produces=MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-context-noteclass-tags", level = Link.LEVEL_READ,
            name = "读取文章标签列表", parent = "admin-context-noteclass-index")
    public String taglist(HttpServletRequest request, String callback){
        List<ViewTag> list = tagService.findAll();
        return callback(callback, JsonUtils.objectToJson(list));
    }

    /**
     * 读取文章位置列表
     */
    @RequestMapping(value="postions",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-context-noteclass-postions", level = Link.LEVEL_READ,
            name = "读取文章位置列表", parent = "admin-context-noteclass-index")
    public String deleteAdvertisement(HttpServletRequest request,Integer classes,String callback){
        List<ViewPostion> list = postionService.findByClasses(classes);
        return callback(callback, JsonUtils.objectToJson(list));
    }
}
