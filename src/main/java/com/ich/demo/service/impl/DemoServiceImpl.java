package com.ich.demo.service.impl;

import com.alibaba.druid.pool.DruidDataSource;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ich.core.base.ObjectHelper;
import com.ich.core.http.entity.HttpResponse;
import com.ich.core.http.entity.PageView;
import com.ich.core.http.other.CustomException;
import com.ich.demo.dao.DemoMapper;
import com.ich.demo.pojo.DemoTest;
import com.ich.demo.pojo.PWordshield;
import com.ich.demo.service.DemoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/7/3 0003.
 */
@Service
public class DemoServiceImpl implements DemoService {

    @Autowired
    private DemoMapper demoMapper;

    @Override
    public HttpResponse findDemoById(Long id) {
        DemoTest demoTest = demoMapper.selectById(id);
        return new HttpResponse(HttpResponse.HTTP_OK,"OK",demoTest);
    }

    @Override
    public HttpResponse addDemo(DemoTest demoTest) {
        demoMapper.insertDemo(demoTest);
        return new HttpResponse(HttpResponse.HTTP_OK,"OK",demoTest);
    }

    @Override
    public HttpResponse editDemo(DemoTest demoTest) {
        return null;
    }

    @Override
    public HttpResponse deleteDemo(Long id) {
        return null;
    }

    @Override
    public List<Map<String, Object>> queryDemos(PageView pageView) {
        PageHelper.startPage(pageView.getPage(),pageView.getRows());
        List<Map<String, Object>> result = demoMapper.selectByAdminExample();
        PageInfo<Map<String, Object>> pageInfo = new PageInfo<>(result);
        pageView.setRowCount(pageInfo.getTotal());
        return result;
    }

    @Override
    public HttpResponse addDemoExp(DemoTest demoTest) {
        PWordshield wordshield = new PWordshield();
        return null;
    }

    @Override
    public HttpResponse addErrorDemo(DemoTest demoTest) {
        demoMapper.insertDemo(demoTest);
        demoMapper.insertDemo(demoTest);
        if(ObjectHelper.isEmpty(demoTest.getBirthday())){
            throw new CustomException(HttpResponse.HTTP_ERROR,"事务已回滚！！");
        }
        return new HttpResponse(HttpResponse.HTTP_OK,"OK",demoTest);
    }

    @Override
    public HttpResponse addErrorDemox(DemoTest demoTest) {
        if(ObjectHelper.isEmpty(demoTest.getBirthday())){
            throw new RuntimeException();
        }
        return new HttpResponse(HttpResponse.HTTP_OK,"OK",demoTest);
    }

    @Override
    public HttpResponse addErrorDemoz(DemoTest demoTest) {
        if(ObjectHelper.isEmpty(demoTest.getBirthday())){
            throw new RuntimeException();
        }
        return new HttpResponse(HttpResponse.HTTP_OK,"OK",demoTest);
    }

}
