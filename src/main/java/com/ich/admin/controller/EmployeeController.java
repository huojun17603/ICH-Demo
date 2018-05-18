package com.ich.admin.controller;

import java.util.List;
import java.util.Map;

import com.ich.admin.dto.EmployeeQueryDto;
import com.ich.admin.pojo.Employee;
import com.ich.admin.service.EmployeeService;
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
public class EmployeeController extends AdminController{
	
	@Autowired
	private EmployeeService employeeService;
	
	@RequestMapping(value="employee/query",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "员工管理-分页列表",code = "admin-employee-query",
		level = Link.LEVEL_READ,parent = "admin-employee-index")
	public String query(PageView pageView, EmployeeQueryDto employeeQueryDto,String callback){
		HttpEasyUIResponse response = new HttpEasyUIResponse(HttpEasyUIResponse.HTTP_OK,HttpEasyUIResponse.HTTP_MSG_OK,null);
		List<EmployeeQueryDto> list = employeeService.queryEmployeeList(pageView,employeeQueryDto);
		response.setRows(list);
		response.setTotal(pageView.getRowCount());
		return callback(callback, response);
	}
	
	@RequestMapping(value="employee/list",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "员工管理-模糊查询列表",code = "admin-employee-list",
		level = Link.LEVEL_READ,parent = "admin-employee-index")
	public String list(PageView pageView,EmployeeQueryDto employeeQueryDto,String callback){
		List<EmployeeQueryDto> list = employeeService.queryEmployeeList(pageView,employeeQueryDto);
		return callback(callback, JsonUtils.objectToJson(list));
	}

	
	@RequestMapping(value="employee/quick",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "员工管理-快速注册",code = "admin-employee-quick",
		level = Link.LEVEL_WRITE,parent = "admin-employee-index")
	public String quick(Employee employee,String callback){
		HttpResponse result = this.employeeService.insertQuick(employee);
		return callback(callback, result);
	}

	@RequestMapping(value="employee/update",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "员工管理-修改信息",code = "admin-employee-update",
			level = Link.LEVEL_WRITE,parent = "admin-employee-index")
	public String update(Employee employee,String callback){
		HttpResponse result = this.employeeService.updateBase(employee);
		return callback(callback, JsonUtils.objectToJson(result));
	}

	@RequestMapping(value="employee/disable",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "员工管理-禁用",code = "admin-employee-disable",
		level = Link.LEVEL_DETELE,parent = "admin-employee-index")
	public String disable(String id,String callback){
		HttpResponse result = this.employeeService.updateEmployeeStatus(id, Employee.STATUS_DISABLE);
		return callback(callback, result);
	}
	
	@RequestMapping(value="employee/able",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "员工管理-启用",code = "admin-employee-able",
		level = Link.LEVEL_DETELE,parent = "admin-employee-index")
	public String able(String id,String callback){
		HttpResponse result = this.employeeService.updateEmployeeStatus(id, Employee.STATUS_ABLE);
		return callback(callback, result);
	}

	@RequestMapping(value="employee/restkey",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
	@ResponseBody
	@Link(name = "员工管理-重置密码",code = "admin-employee-restkey",
			level = Link.LEVEL_DETELE,parent = "admin-employee-index")
	public String restkey(String id,String callback){
		HttpResponse result = this.employeeService.updateRestkey(id);
		return callback(callback, result);
	}

}
