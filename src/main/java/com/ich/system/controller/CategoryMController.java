package com.ich.system.controller;

import com.ich.admin.controller.AdminController;
import com.ich.core.base.ObjectHelper;
import com.ich.core.http.entity.EasyUITreeNode;
import com.ich.core.http.entity.HttpResponse;
import com.ich.extend.dto.ICategoryTree;
import com.ich.extend.pojo.ICategory;
import com.ich.extend.service.ICategoryService;
import com.ich.module.annotation.Link;
import com.ich.version.pojo.Versionapp;
import com.ich.version.service.VersionappService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("admin/category")
public class CategoryMController  extends AdminController {

    @Autowired
    private ICategoryService categoryService;

    /** 获取树列表 */
    @RequestMapping(value="obtain/tree",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String obtainTree(Long pid,Integer source,Boolean status,String callback){
        HttpResponse response = new HttpResponse(HttpResponse.HTTP_OK,HttpResponse.HTTP_MSG_OK);
        List<ICategoryTree> list = categoryService.findTreeOfSource(pid,source,status);
        response.setData(list);
        return callback(callback,response);
    }

    /** 获取列表 */
    @RequestMapping(value="obtain/list",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String obtainList(Long pid,Integer source,Boolean status,String callback){
        List<ICategory> list;
        HttpResponse response = new HttpResponse(HttpResponse.HTTP_OK,HttpResponse.HTTP_MSG_OK);
        if(ObjectHelper.isEmpty(pid)||pid==0){
            list = categoryService.findListOfSource(source,status);
        }else{
            list = categoryService.findListOfPid(pid,source,status);
        }
        response.setData(list);
        return callback(callback,response);
    }

    /** 新增修改 */
    @RequestMapping(value="addOrEdit",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-system-category-addOrEdit", level = Link.LEVEL_WRITE, name = "公共类目-新增修改", parent = "admin-system-category")
    public String addOrEdit(ICategory category,String callback){
        HttpResponse response = categoryService.addOrEditCategory(category);
        return callback(callback,response);
    }

    /** 修改状态 */
    @RequestMapping(value="editStatus",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-system-category-editStatus", level = Link.LEVEL_WRITE, name = "公共类目-修改状态", parent = "admin-system-category")
    public String editStatus(Long id,Boolean status,String callback){
        HttpResponse response = categoryService.editCategoryStatus(id,status);
        return callback(callback,response);
    }

    /** 删除 */
    @RequestMapping(value="delete",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-system-category-delete", level = Link.LEVEL_WRITE, name = "公共类目-删除", parent = "admin-system-category")
    public String delete(Long id,String callback){
        HttpResponse response = categoryService.deleteCategory(id);
        return callback(callback,response);
    }

}
