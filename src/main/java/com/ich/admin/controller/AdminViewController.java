package com.ich.admin.controller;

import com.ich.core.base.ObjectHelper;
import com.ich.module.annotation.Link;
import com.ich.module.pojo.MenuResource;
import com.ich.module.service.ResourceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@Controller
@RequestMapping("admin")
public class AdminViewController extends AdminController{

    @Autowired
    private ResourceService resourceService;

    @RequestMapping("view/{code}")
    public ModelAndView viewIndex(HttpServletRequest request, @PathVariable String code){
        MenuResource resource = this.resourceService.getMenuResourceByCode(code);
        if(ObjectHelper.isNotEmpty(resource)&&resource.getType().equals(Link.TYPE_MENU)&&ObjectHelper.isNotEmpty(resource.getView())){
            Map<String,?> model = request.getParameterMap();
            String view = resource.getView();
            return new ModelAndView(view,model);
        }
        return new ModelAndView();
    }
}
