package com.ich.spring.service;

import com.ich.core.http.entity.HttpResponse;

public interface SpringCacheService {

    HttpResponse findById(Long id);

    HttpResponse update(Long id);

    HttpResponse remove(Long id);

}
