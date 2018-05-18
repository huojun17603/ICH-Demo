package com.ich.system.controller;



import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ich.admin.controller.AdminController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ich.config.pojo.IConfig;
import com.ich.config.service.IConfigService;
import com.ich.core.base.JsonUtils;
import com.ich.core.base.ObjectHelper;
import com.ich.core.http.entity.HttpResponse;
import com.ich.module.annotation.Link;


@Controller
@RequestMapping("admin/config")
public class ConfigController extends AdminController {
	
	@Autowired
	private IConfigService iConfigService;
	
	/** 获取系统配置参数【单个】 */
	@RequestMapping(value="obtain",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String obtain(String ikey,String callback){
		String ivalue = iConfigService.getParams(ikey);
		HttpResponse response = new HttpResponse(HttpResponse.HTTP_OK,HttpResponse.HTTP_MSG_OK,ivalue);
        return callback(callback,response);
    }

	/** 获取系统配置参数【多个】 */
	@RequestMapping(value="obtains",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    public String obtains(String ikeys,String callback){
		String ikey_array[] = ikeys.split(",");
		Map<String,String> result = new HashMap<String,String>();
		for(String ikey : ikey_array){
			String ivalue = iConfigService.getParams(ikey);
			result.put(ikey, ivalue);
		}
		HttpResponse response = new HttpResponse(HttpResponse.HTTP_OK,HttpResponse.HTTP_MSG_OK,result);
        return callback(callback,response);
    }

	/** 动态参数列表 */
	@RequestMapping(value="list",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-system-config-list", level = Link.LEVEL_READ, name = "系统参数-列表", parent = "admin-system-config  ")
    public String list(String ikey,String ivalue,String searchkey,String callback){
		List<IConfig> response = iConfigService.findAllList();
		if(ObjectHelper.isNotEmpty(searchkey)){
			List<IConfig> result = new ArrayList<>();
			for(IConfig iConfig : response){
				if(iConfig.getDocs().indexOf(searchkey)!=-1) result.add(iConfig);
			}
			return callback(callback,JsonUtils.objectToJson(result));
		}
        return callback(callback,JsonUtils.objectToJson(response));
    }
	
	/** 修改动态参数 */
	@RequestMapping(value="edit",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(code = "admin-system-config-edit", level = Link.LEVEL_EDIT, name = "系统参数-修改", parent = "admin-system-config")
    public String edit(String ikey,String ivalue,String callback){
		HttpResponse response = iConfigService.setParams(ikey, ivalue);
        return callback(callback,response);
    }
	
	

}
