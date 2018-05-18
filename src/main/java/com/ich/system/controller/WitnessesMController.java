package com.ich.system.controller;

import com.ich.admin.controller.AdminController;
import com.ich.admin.dto.LocalEmployee;
import com.ich.admin.pojo.Employee;
import com.ich.admin.service.impl.LocalEmployeeServiceImpl;
import com.ich.base.SourceConst;
import com.ich.core.base.IDUtils;
import com.ich.core.base.JsonUtils;
import com.ich.core.http.entity.HttpEasyUIResponse;
import com.ich.core.http.entity.HttpResponse;
import com.ich.core.http.entity.PageView;
import com.ich.extend.dao.IWitnessesMapper;
import com.ich.extend.pojo.ICategory;
import com.ich.extend.pojo.IExamine;
import com.ich.extend.pojo.IWitnesses;
import com.ich.extend.service.IExamineService;
import com.ich.extend.service.IWitnessesService;
import com.ich.module.annotation.Link;
import com.ich.system.service.WitnessesAService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("admin/witnesses")
public class WitnessesMController extends AdminController{

    @Autowired
    //Jar中的业务无法满足时，通过扩展自定义的Service层完成扩展
    private WitnessesAService witnessesAService;

    /** 处理举报 */
    @RequestMapping(value="handle",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-customer-service-witnesses-handle", level = Link.LEVEL_WRITE, name = "举报-处理", parent = "admin-customer-service-witnesses")
    public String handle(String wid,String handlermark, String callback){
        HttpResponse response = witnessesAService.updateWitnessesOfHandle(wid,handlermark);
        return callback(callback,response);
    }

    /** 举报列表 */
    @RequestMapping(value="list",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-customer-service-witnesses-list", level = Link.LEVEL_WRITE, name = "举报-主列表", parent = "admin-customer-service-witnesses")
    public String list(PageView view, String wname, Integer status, String callback){
        Map<String,Object> model = getSuccessMap();
        List<Map<String,Object>> list = witnessesAService.queryWitnesses(view,wname,status);
        model.put(HttpEasyUIResponse.HTTP_DATA_PAGE_TOTAL, view.getRowCount());
        model.put(HttpEasyUIResponse.HTTP_DATA_PAGE_ROWS, list);
        return callback(callback, JsonUtils.objectToJson(model));
    }

    /** 举报明细 */
    @RequestMapping(value="dlist",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-customer-service-witnesses-dlist", level = Link.LEVEL_WRITE, name = "举报-明细列表", parent = "admin-customer-service-witnesses")
    public String dlist(PageView view, String wid, String callback){
        Map<String,Object> model = getSuccessMap();
        List<Map<String,Object>> list = witnessesAService.queryWitnessesWidList(view,wid);
        model.put(HttpEasyUIResponse.HTTP_DATA_PAGE_TOTAL, view.getRowCount());
        model.put(HttpEasyUIResponse.HTTP_DATA_PAGE_ROWS, list);
        return callback(callback, JsonUtils.objectToJson(model));
    }
}
