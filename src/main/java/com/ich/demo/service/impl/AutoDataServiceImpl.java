package com.ich.demo.service.impl;

import com.ich.core.http.controller.CoreController;
import com.ich.demo.dao.DemoMapper;
import com.ich.demo.pojo.DemoTest;
import com.ich.demo.service.AutoDataService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Date;

@Service
public class AutoDataServiceImpl implements AutoDataService {

    protected final Logger logger = Logger.getLogger(AutoDataServiceImpl.class);

    @Autowired
    private DemoMapper demoMapper;

    @Override
    public void autoAddData(){
        logger.info("开始加载数据！");
        long t1 = new Date().getTime();
        for (int i=0;i<100;i++){
            DemoTest demoTest = new DemoTest();
            demoTest.setName("X"+i);
            demoTest.setAge(i);
            demoTest.setBirthday(new Date());
            demoTest.setBalance(new BigDecimal(0.01).multiply(new BigDecimal(i)));
            demoTest.setInfo("---------------------------------------");
            demoMapper.insertDemo(demoTest);
        }
        long t2 = new Date().getTime();
        logger.info("数据加载完成！耗时："+(t2-t1)+"毫秒！");
    }

}
