package com.ich.spring.service.impl;

import com.ich.core.base.TimeUtil;
import com.ich.core.http.entity.HttpResponse;
import com.ich.spring.service.SpringCacheService;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
@CacheConfig(cacheNames = "cache")
public class SpringCacheServiceImpl implements SpringCacheService {


    @Override
    @Cacheable(key="#id")
    public HttpResponse findById(Long id) {
        System.out.println(TimeUtil.format(new Date())+":获取数据");
        return new HttpResponse(HttpResponse.HTTP_OK,HttpResponse.HTTP_MSG_OK,id);
    }

    @Override
    @CachePut(key="#id")
    public HttpResponse update(Long id) {
        System.out.println(TimeUtil.format(new Date())+":缓存更新");
        return new HttpResponse(HttpResponse.HTTP_OK,HttpResponse.HTTP_MSG_OK,id);
    }

    @Override
    @CacheEvict(allEntries=true)
    public HttpResponse remove(Long id) {
        System.out.println(TimeUtil.format(new Date())+":缓存清除");
        return new HttpResponse(HttpResponse.HTTP_OK,HttpResponse.HTTP_MSG_OK,id);
    }
}
