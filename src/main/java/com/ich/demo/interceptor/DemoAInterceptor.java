package com.ich.demo.interceptor;

import com.ich.core.base.ThreadLocalUtil;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.ServletInputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.ServletResponseWrapper;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

public class DemoAInterceptor extends HandlerInterceptorAdapter {

    public static Map<Integer,Long> map = new HashMap<>();

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if(!(handler instanceof HandlerMethod)) return true;
        map.put(ThreadLocalUtil.getID(),new Date().getTime());

        System.out.println(request.getRequestURI());
        String xr = request.getHeader("X-Requested-With");

        System.out.println(request.getAuthType());
        System.out.println(request.getContextPath());
        System.out.println(request.getRequestedSessionId());
        System.out.println(request.getPathInfo());
        System.out.println(request.getQueryString());
        System.out.println(request.getRemoteUser());
        System.out.println(request.getRemoteAddr());
        Enumeration e = request.getHeaderNames();
        while (e.hasMoreElements()){
            String value = (String)e.nextElement();//调用nextElement方法获得元素
            System.out.print(value+":");
            System.out.println(request.getHeader(value));
        }
        if(xr!=null&&"XMLHttpRequest".equalsIgnoreCase(xr)){
            System.out.println("A1-AJAX");
        }else{
            System.out.println("A1-VIEW");
        }
        System.out.println("A1");
        return true;
    }

    @Override
    public void postHandle(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        String xr = request.getHeader("X-Requested-With");
        if(xr!=null&&"XMLHttpRequest".equalsIgnoreCase(xr)){
            System.out.println("A2-AJAX");
        }else{
            System.out.println("A2-VIEW");
        }
        System.out.println("A2");
        long x = new Date().getTime();
        long y = map.get(ThreadLocalUtil.getID());
        System.out.println("ms:"+(x-y));
    }

    @Override
    public void afterCompletion(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, Object handler, Exception ex) throws Exception {
        System.out.println("A3");
        long x = new Date().getTime();
        long y = map.get(ThreadLocalUtil.getID());
        System.out.println("ms:"+(x-y));
    }

}
