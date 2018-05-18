package com.ich.admin.controller;

import java.util.List;
import java.util.Map;

import com.ich.admin.dto.OrganizationDto;
import com.ich.admin.dto.OrganizationTreeDto;
import com.ich.admin.pojo.Organization;
import com.ich.admin.service.OrganizationService;
import com.ich.core.base.JsonUtils;
import com.ich.core.base.ObjectHelper;
import com.ich.core.http.entity.HttpResponse;
import com.ich.module.annotation.Link;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


/**
 * 组织机构控制层
 * @since  2016-1-26
 * @author 霍俊
 */
@Controller
@RequestMapping("admin")
public class OrganizationController extends AdminController{
	
	@Autowired
	private OrganizationService organizationService;
	
	@RequestMapping(value="organization/list",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "组织机构-列表",code = "admin-organization-list", level = Link.LEVEL_READ,parent = "admin-organization-index")
	public String getOrganizationList(String id,String callback){
		List<OrganizationDto> list = organizationService.getOrganizationList(id);
        return callback(callback, JsonUtils.objectToJson(list));
	}
	
	@RequestMapping(value="organization/tree",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "组织机构-树",code = "admin-organization-tree", level = Link.LEVEL_READ,parent = "admin-organization-index")
	public String getOrganizationTree(String callback){
		List<OrganizationTreeDto>  list = organizationService.getOrganizationTree();
        return callback(callback, JsonUtils.objectToJson(list));
	}
	
	@RequestMapping(value="organization/insert",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "组织机构-新增/修改",code = "admin-organization-insert", level = Link.LEVEL_WRITE,parent = "admin-organization-index")
	public String insertOrganizationType(Organization organization,String callback){
		HttpResponse result = organizationService.insertOrganization(organization);
        return callback(callback, JsonUtils.objectToJson(result));
	}
	
	@RequestMapping(value="organization/delete",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "组织机构-删除",code = "admin-organization-delete", level = Link.LEVEL_DETELE,parent = "admin-organization-index")
	public String deleteOrganizationType(String id,String callback){
        HttpResponse result = organizationService.deleteOrganization(id);
        return callback(callback, JsonUtils.objectToJson(result));
	}
	
}
