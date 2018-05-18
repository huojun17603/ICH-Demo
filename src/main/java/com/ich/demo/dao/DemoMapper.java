package com.ich.demo.dao;

import com.ich.demo.pojo.DemoTest;

import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/7/3 0003.
 */
public interface DemoMapper {

    public DemoTest selectById(Long id);

    public Long insertDemo(DemoTest demoTest);

    public List<Map<String,Object>> selectByAdminExample();
}
