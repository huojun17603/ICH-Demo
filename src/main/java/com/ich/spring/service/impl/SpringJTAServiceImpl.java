package com.ich.spring.service.impl;

import com.ich.core.base.IDUtils;
import com.ich.core.http.entity.HttpResponse;
import com.ich.core.http.other.CustomException;
import com.ich.spring.service.SpringJTAService;
import com.uu.storea.mapper.DemoAMapper;
import com.uu.storea.pojo.DemoA;
import com.uu.storea.pojo.DemoAExample;
import com.uu.storeb.mapper.DemoBMapper;
import com.uu.storeb.pojo.DemoB;
import com.uu.storeb.pojo.DemoBExample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class SpringJTAServiceImpl implements SpringJTAService {

    @Autowired
    DemoAMapper demoAMapper;
    @Autowired
    DemoBMapper demoBMapper;

    @Override
    public List<DemoA> findA() {
        return demoAMapper.selectByExample(new DemoAExample());
    }

    @Override
    public List<DemoB> findB() {
        return demoBMapper.selectByExample(new DemoBExample());
    }

    @Override
    public HttpResponse addData(String name) {
        String id = IDUtils.createUUId();
        DemoA demoA = new DemoA();
        demoA.setId(id);
        demoA.setAge(10);
        demoA.setName(name+"A");
        demoA.setCreatetime(new Date());
        demoA.setInfo("AAAAAAAAAAAAAAAAA");
        DemoB demoB = new DemoB();
        demoB.setId(id);
        demoB.setAge(10);
        demoB.setName(name+"B");
        demoB.setCreatetime(new Date());
        demoB.setInfo("BBBBBBBBBBBBBBBB");
        demoAMapper.insertSelective(demoA);
        if(name.equals("ex")){
            throw new CustomException(HttpResponse.HTTP_ERROR,HttpResponse.HTTP_MSG_ERROR);
        }
        demoBMapper.insertSelective(demoB);
        return new HttpResponse(HttpResponse.HTTP_OK,HttpResponse.HTTP_MSG_OK);
    }

}
