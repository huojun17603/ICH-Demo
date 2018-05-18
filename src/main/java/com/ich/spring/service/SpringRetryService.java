package com.ich.spring.service;

import com.ich.core.http.entity.HttpResponse;

public interface SpringRetryService {

    public HttpResponse execute() throws Exception;

}
