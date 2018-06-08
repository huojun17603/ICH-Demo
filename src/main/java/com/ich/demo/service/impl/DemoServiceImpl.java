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
import com.ich.extend.dao.IFeedbackMapper;
import com.ich.extend.pojo.IFeedback;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/7/3 0003.
 */
@Service
public class DemoServiceImpl implements DemoService {

    @Autowired
    private DemoMapper demoMapper;
    @Autowired
    private IFeedbackMapper feedbackMapper;

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

    @Override
    public HttpResponse addBack(String id) {
        IFeedback feedback = new IFeedback();
        feedback.setId(id);
        feedback.setStatus(0);
        feedbackMapper.insert(feedback);
        IFeedback feedback2 = feedbackMapper.selectById(id);
        System.out.println(feedback2.getId());
        try {
            System.out.println("线程停止");
            Thread.sleep(10000);
            System.out.println("线程开始");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        if(ObjectHelper.isEmpty(feedback.getUsername())){
            throw new CustomException(HttpResponse.HTTP_ERROR,"事务已回滚！！");
        }
        return new HttpResponse(HttpResponse.HTTP_OK,"OK");
    }

    @Override
    public HttpResponse addBackx(String id) {
        IFeedback feedback = new IFeedback();
        feedback.setId("30");
        feedback.setStatus(0);
        feedbackMapper.insert(feedback);
        if(ObjectHelper.isEmpty(feedback.getUsername())){
            throw new CustomException(HttpResponse.HTTP_ERROR,"事务已回滚！！");
        }
        return null;
    }

    @Override
    public HttpResponse addBacks(String id) {
        IFeedback feedback = new IFeedback();
        feedback.setId("20");
        feedback.setStatus(0);
        feedbackMapper.insert(feedback);
        if(ObjectHelper.isEmpty(feedback.getUsername())){
            throw new CustomException(HttpResponse.HTTP_ERROR,"事务已回滚！！");
        }
        return null;
    }

    @Override
    public HttpResponse editBack(String id) {
        int result = feedbackMapper.updateStatus(id,1);
        if(result==1){
            throw new CustomException(HttpResponse.HTTP_ERROR,"事务已回滚！！");
        }
        return new HttpResponse(HttpResponse.HTTP_OK,"OK");
    }

    @Override
    public IFeedback findBack(String id) {
        IFeedback feedback = feedbackMapper.selectById(id);
        return feedback;
    }

    @Override

    public HttpResponse tryBack(String id) {//无事务
        try {
            ((DemoService) AopContext.currentProxy()).addBack(id);
        }catch (Exception e){
            e.printStackTrace();
        }
//        addBacks(id);
        return null;
    }


}
