package com.ich.admin.controller;

import com.ich.admin.dto.EmployeeMenuDto;
import com.ich.admin.dto.EmployeeWindowDto;
import com.ich.admin.dto.LocalEmployee;
import com.ich.admin.service.AdminLoginService;
import com.ich.admin.service.EmployeeService;
import com.ich.admin.service.LocalEmployeeService;
import com.ich.config.pojo.IConfig;
import com.ich.core.base.JsonUtils;
import com.ich.core.base.ObjectHelper;
import com.ich.core.http.entity.EasyUITreeNode;
import com.ich.core.http.entity.HttpResponse;
import com.ich.core.listener.SystemConfig;
import com.ich.module.annotation.Link;
import com.ich.module.pojo.MenuResource;
import com.ich.module.service.ResourceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("admin")
public class AdminHomeController extends  AdminController{

    @Autowired
    private LocalEmployeeService localEmployeeService;
    @Autowired
    private AdminLoginService adminLoginService;
    @Autowired
    private ResourceService resourceService;

    @RequestMapping("index")
    @Link(name = "首页",code = "admin-home", level = Link.LEVEL_NONE,parent = "ICH-ADMIN")
    public ModelAndView index(HttpServletRequest request){
        LocalEmployee employeeDto = localEmployeeService.findLocalEmployee();
        request.getSession().setAttribute(AdminController.SESSION_ADMIN_NAME,employeeDto.getEmployeeName());
        Map<String,Object> model = new HashMap<String,Object>();
		/* 获取主目录 */
        List<EmployeeMenuDto> employeeMenuDtos = employeeDto.getEmployeeMenuDtos();
        List<EmployeeMenuDto> topMenu = new ArrayList<EmployeeMenuDto>();
        for(EmployeeMenuDto dto : employeeMenuDtos){
            if(dto.getIsRead()&&dto.getType().equals(Link.TYPE_CATALOG)&&dto.getParent().equals("ICH-ADMIN")){
                topMenu.add(dto);
            }
        }
		/* 获取主页窗口 */
        List<EmployeeWindowDto> windows = localEmployeeService.findLocalEmployee().getEmployeeWindowDtos();
        List<EmployeeWindowDto> topWindow = new ArrayList<EmployeeWindowDto>();
        for(EmployeeWindowDto dto : windows){
            if(dto.getIsRead()) topWindow.add(dto);
        }
        model.put("topMenu", topMenu);//配置数据
        model.put("topWindow", topWindow);
        return new ModelAndView("admin/index",model);
    }

    @RequestMapping(value="employeeMenus",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(name = "首页菜单",code = "admin-menus", level = Link.LEVEL_NONE,parent = "ICH-ADMIN")
    public String employeeMenus(String id,String mid,String callback){
        if(ObjectHelper.isEmpty(id)) id = mid;
        List<EmployeeMenuDto> menuList = getTopMenu(id);
        List<EasyUITreeNode> result = new ArrayList<EasyUITreeNode>();
        for(EmployeeMenuDto employeeMenuDto : menuList){
            EasyUITreeNode treeDto = new EasyUITreeNode();
            treeDto.setId(employeeMenuDto.getCode());
            treeDto.setText(employeeMenuDto.getName());
            treeDto.setIconCls(employeeMenuDto.getIcon());
            if(employeeMenuDto.getType().equals(Link.TYPE_CATALOG)){
                treeDto.setState("closed");
            }else{
                List<String> attributes = new ArrayList<String>();
                attributes.add(employeeMenuDto.getUrl());
                treeDto.setAttributes(attributes);
                treeDto.setState("open");
            }
            result.add(treeDto);
        }
        return callback(callback, JsonUtils.objectToJson(result));
    }

    /**
     * 登录用户访问此接口获取其拥有操作权限的链接字符串列表<链接编码>：account-fuzzyList,account-query,account-updateKey,account-vailCode
     * 通过菜单CODE获取
     */
    @RequestMapping(value="employeeGetButtonWithMenu",produces= MediaType.APPLICATION_JSON_VALUE+";charset=utf-8")
    @ResponseBody
    @Link(name = "获取菜单按钮权限列表",code = "admin-menus-btn", level = Link.LEVEL_NONE,parent = "ICH-ADMIN")
    public String employeeGetButtonWithMenu(String MenuCode,String callback){
        Map<String,Object> model = getSuccessMap();
        LocalEmployee dto = localEmployeeService.findLocalEmployee();
        String data = "";
        if(ObjectHelper.isNotEmpty(dto)&&dto.getEmployeeMenuMap().containsKey(MenuCode)){
            EmployeeMenuDto employeeMenuDto = dto.getEmployeeMenuMap().get(MenuCode);
            List<MenuResource> resources = this.resourceService.getChildMenuResourceByCode(MenuCode);
            for(MenuResource resource : resources){
                if(resource.getLevel().equals(Link.LEVEL_AUDIT)&&employeeMenuDto.getIsAudit()) data += resource.getCode() + ",";
                if(resource.getLevel().equals(Link.LEVEL_DETELE)&&employeeMenuDto.getIsDelete()) data += resource.getCode() + ",";
                if(resource.getLevel().equals(Link.LEVEL_EDIT)&&employeeMenuDto.getIsEdit()) data += resource.getCode() + ",";
                if(resource.getLevel().equals(Link.LEVEL_WRITE)&&employeeMenuDto.getIsWrite()) data += resource.getCode() + ",";
                if(resource.getLevel().equals(Link.LEVEL_READ)) data += resource.getCode() + ",";
                if(resource.getLevel().equals(Link.LEVEL_NONE)) data += resource.getCode() + ",";
            }
            if(data.length()>1) data = data.substring(0, data.length()-1);
        }
        model.put(HttpResponse.RETURN_DATA, data);
        return callback(callback, JsonUtils.objectToJson(model));
    }
    /**
     * 登录用户访问此接口可以得知是否拥有参数中链接的权限
     * 通过链接CODE获取
     */
    @RequestMapping("employeeGetButtonWithLink")
    @ResponseBody
    @Link(name = "获取按钮链接权限",code = "admin-link-btn", level = Link.LEVEL_NONE,parent = "ICH-ADMIN")
    public String employeeGetButtonWithLink(String LinkCode,String callback){
        Map<String,Object> model = getSuccessMap();
        model.put(HttpResponse.RETURN_DATA, true);
        LocalEmployee dto = localEmployeeService.findLocalEmployee();
        MenuResource resource = this.resourceService.getMenuResourceByCode(LinkCode);
        if(ObjectHelper.isNotEmpty(dto)&&ObjectHelper.isNotEmpty(resource)&&dto.getEmployeeMenuMap().containsKey(resource.getParent())){
            EmployeeMenuDto employeeMenuDto = dto.getEmployeeMenuMap().get(resource.getParent());
            if(resource.getLevel().equals(Link.LEVEL_AUDIT)&&!employeeMenuDto.getIsAudit()) model.put(HttpResponse.RETURN_DATA, false);
            if(resource.getLevel().equals(Link.LEVEL_DETELE)&&!employeeMenuDto.getIsDelete()) model.put(HttpResponse.RETURN_DATA, false);
            if(resource.getLevel().equals(Link.LEVEL_EDIT)&&!employeeMenuDto.getIsEdit()) model.put(HttpResponse.RETURN_DATA, false);
            if(resource.getLevel().equals(Link.LEVEL_WRITE)&&!employeeMenuDto.getIsWrite()) model.put(HttpResponse.RETURN_DATA, false);
        }else{
            model.put(HttpResponse.RETURN_DATA, false);
        }
        return callback(callback, JsonUtils.objectToJson(model));
    }

    /** 员工修改密码 */
    @RequestMapping("home/editkey")
    @ResponseBody
    @Link(name = "员工-修改密码",code = "admin-home-editkey",level = Link.LEVEL_NONE,parent = "ICH-ADMIN")
    public String editKey(String oldkey,String newkey,String callback){
        HttpResponse result = adminLoginService.editKey(oldkey,newkey);
        return callback(callback, JsonUtils.objectToJson(result));
    }

    /**
     * 根据父id获取菜单
     */
    public List<EmployeeMenuDto> getTopMenu(String menuId){
        List<EmployeeMenuDto> menuDtoList = new ArrayList<EmployeeMenuDto>();
        LocalEmployee employee = localEmployeeService.findLocalEmployee();
        //遍历所有父id为root
        if(ObjectHelper.isNotEmpty(employee)){
            List<EmployeeMenuDto> employeeMenuDtoList = employee.getEmployeeMenuDtos();	//获取所有目录和菜单
            if(ObjectHelper.isNotEmpty(employeeMenuDtoList)){
                for(EmployeeMenuDto employeeMenuDto: employeeMenuDtoList){
                    String type = employeeMenuDto.getParent();
                    if(type.endsWith(menuId)){
                        menuDtoList.add(employeeMenuDto);
                    }
                }
            }
        }
        return menuDtoList;
    }

}
