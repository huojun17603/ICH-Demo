package com.ich.demo.interceptor;

import com.ich.core.base.ThreadLocalUtil;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.Enumeration;

public class DemoBInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {


        System.out.println(request.getRequestURI());
        String xr = request.getHeader("X-Requested-With");
        Enumeration e = request.getHeaderNames();
        while (e.hasMoreElements()){
            String value = (String)e.nextElement();//调用nextElement方法获得元素
            System.out.print(value);
        }
        if(xr!=null&&"XMLHttpRequest".equalsIgnoreCase(xr)){
            System.out.println("B1-AJAX");
        }else{
            System.out.println("B1-VIEW");
        }
        System.out.println("B1");
        return true;
    }

    @Override
    public void postHandle(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        String xr = request.getHeader("X-Requested-With");
        if(xr!=null&&"XMLHttpRequest".equalsIgnoreCase(xr)){
            System.out.println("B2-AJAX");
        }else{
            System.out.println("B2-VIEW");
        }
        System.out.println("B2");
        long x = new Date().getTime();
        long y = DemoAInterceptor.map.get(ThreadLocalUtil.getID());
        System.out.println("ms:"+(x-y));
    }

    @Override
    public void afterCompletion(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, Object handler, Exception ex) throws Exception {
        System.out.println("B3");
        long x = new Date().getTime();
        long y = DemoAInterceptor.map.get(ThreadLocalUtil.getID());
        System.out.println("ms:"+(x-y));
    }
}
