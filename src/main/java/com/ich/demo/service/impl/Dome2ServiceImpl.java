package com.ich.demo.service.impl;

import com.ich.core.http.entity.HttpResponse;
import com.ich.demo.service.DemoService;
import com.ich.demo.service.Dome2Service;
import com.ich.extend.pojo.IFeedback;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class Dome2ServiceImpl implements Dome2Service {

    @Autowired
    private DemoService demoService;

    @Override
    public HttpResponse addBack(String id) {//无事务

        try {
            demoService.addBacks(id);
        }catch (Exception e){
            e.printStackTrace();
        }
        try {
            demoService.addBackx(id);
            IFeedback feedback = demoService.findBack("30");
            System.out.println(feedback.getId());
        }catch (Exception e){
            e.printStackTrace();
        }

        try {
            demoService.addBack(id);
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
}
