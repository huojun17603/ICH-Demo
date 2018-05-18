package com.ich.demo.service;

import com.ich.core.http.entity.HttpResponse;
import com.ich.core.http.entity.PageView;
import com.ich.demo.pojo.DemoTest;

import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/7/3 0003.
 */
public interface DemoService {

    /**
     * DEMO请求测试
     * @param id DEMO ID
     * @return Demo
     */
    public HttpResponse findDemoById(Long id);

    /**
     * DEMO 新增测试
     * @param demoTest
     * @return
     */
    public HttpResponse addDemo(DemoTest demoTest);

    public HttpResponse editDemo(DemoTest demoTest);

    public HttpResponse deleteDemo(Long id);

    public List<Map<String,Object>> queryDemos(PageView pageView);

    public HttpResponse addDemoExp(DemoTest demoTest);

    HttpResponse addErrorDemo(DemoTest demoTest);

    HttpResponse addErrorDemox(DemoTest demoTest);

    HttpResponse addErrorDemoz(DemoTest demoTest);

}
