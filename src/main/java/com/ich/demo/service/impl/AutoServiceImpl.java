package com.ich.demo.service.impl;


import com.ich.demo.service.AutoService;
import org.springframework.stereotype.Service;

@Service
public class AutoServiceImpl implements AutoService {

    //
    //验证同一方法处理超时
    @Override
    public void exe1() {
        System.out.println("exe1:开始执行");
        try {
            System.out.println("exe1:等待10秒");
            Thread.sleep(30000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("exe1:执行完成");
    }

    @Override
    public void exe2() {
        System.out.println("exe2:开始执行");
        System.out.println("exe2:执行完成");
    }

    @Override
    public void exe3() {
        System.out.println("exe3:开始执行");
        System.out.println("exe3:执行完成");
    }

}
