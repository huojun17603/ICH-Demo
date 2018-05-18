package com.ich.spring.service;

import com.ich.core.http.entity.HttpResponse;
import com.uu.storea.pojo.DemoA;
import com.uu.storeb.pojo.DemoB;

import java.util.List;

public interface SpringJTAService {

    List<DemoA> findA();

    List<DemoB> findB();

    HttpResponse addData(String name);
}
