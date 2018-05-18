package com.ich.admin.controller;

import java.util.List;
import java.util.Map;

import com.ich.admin.dto.EmployeeQueryDto;
import com.ich.admin.dto.PositionDto;
import com.ich.admin.dto.PositionMenuResourceTree;
import com.ich.admin.dto.PositionWindowResourceDto;
import com.ich.admin.pojo.Position;
import com.ich.admin.pojo.PositionMenuResource;
import com.ich.admin.pojo.PositionWindowResource;
import com.ich.admin.service.PositionService;
import com.ich.core.base.JsonUtils;
import com.ich.core.base.ObjectHelper;
import com.ich.core.http.entity.HttpEasyUIResponse;
import com.ich.core.http.entity.HttpResponse;
import com.ich.core.http.entity.PageView;
import com.ich.module.annotation.Link;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("admin")
public class PositionController extends AdminController{
	
	@Autowired
	private PositionService positionService;
	
	@RequestMapping(value="position/query",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "职位权限-分页列表",code = "admin-position-query",
		level = Link.LEVEL_READ,parent = "admin-position-index")
	public String  positionQuery(PageView pageView, String orgId,String callback){
		HttpEasyUIResponse result = new HttpEasyUIResponse(HttpEasyUIResponse.HTTP_OK,HttpEasyUIResponse.HTTP_MSG_OK,null);
		List<PositionDto> list = this.positionService.queryPositionListByOrgId(pageView,orgId);
		result.setRows(list);
		result.setTotal(pageView.getRowCount());
		return callback(callback, JsonUtils.objectToJson(result));
	}
	
	@RequestMapping(value="position/list",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "职位权限-列表",code = "admin-position-list",
		level = Link.LEVEL_READ,parent = "admin-position-index")
	public String positionList(String orgId,String callback){
		List<PositionDto> list = this.positionService.getPositionListByOrgId(orgId);
		return callback(callback, JsonUtils.objectToJson(list));
	}
	
	@RequestMapping(value="position/insert",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "职位权限-新增/修改",code = "admin-position-insert",
		level = Link.LEVEL_READ,parent = "admin-position-index")
	public String positionInsert(Position position,String callback){
		HttpResponse result = this.positionService.insertPosition(position);
		return callback(callback, JsonUtils.objectToJson(result));
	}
	
	@RequestMapping(value="position/delete",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "职位权限-删除",code = "admin-position-delete",
		level = Link.LEVEL_READ,parent = "admin-position-index")
	public String positionDelete(String id,String callback){
		HttpResponse result = this.positionService.deletePosition(id);
		return callback(callback, JsonUtils.objectToJson(result));
	}
	
	@RequestMapping(value="position/getMenuPermission",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "职位权限-菜单权限-树列表",code = "admin-position-getMenuPermission",
		level = Link.LEVEL_READ,parent = "admin-position-index")
	public String getMenuPermission(String id,String callback){
		List<PositionMenuResourceTree> list = this.positionService.getPositionMenuResourceTree(id);
		return callback(callback, JsonUtils.objectToJson(list));
	}
	
	@RequestMapping(value="position/saveMenuPermission",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "职位权限-菜单权限-保存",code = "admin-position-saveMenuPermission",
		level = Link.LEVEL_WRITE,parent = "admin-position-index")
	public String getMenuPermission(PositionMenuResource positionMenuResource,String callback){
		HttpResponse result = this.positionService.saveOrUpdatePositionMenuResource(positionMenuResource);
		return callback(callback, JsonUtils.objectToJson(result));
	}
	
	
	@RequestMapping(value="position/getWindowPermission",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "职位权限-窗口权限-列表",code = "admin-position-getWindowPermission",
		level = Link.LEVEL_READ,parent = "admin-position-index")
	public String getWindowPermission(String id,String callback){
		List<PositionWindowResourceDto> list = this.positionService.getWindowPermissionList(id);
		return callback(callback, JsonUtils.objectToJson(list));
	}
	
	@RequestMapping(value="position/saveWindowPermission",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "职位权限-窗口权限-保存",code = "admin-position-saveWindowPermission",
		level = Link.LEVEL_WRITE,parent = "admin-position-index")
	public String saveWindowPermission(PositionWindowResource positionWindowResource,String callback){
		HttpResponse result = this.positionService.saveOrUpdatePositionWindowResource(positionWindowResource);
		return callback(callback, JsonUtils.objectToJson(result));
	}
	
}
