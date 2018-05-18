package com.ich.spring.service.impl;

import com.ich.core.http.entity.HttpResponse;
import com.ich.core.http.other.CustomException;
import com.ich.spring.service.SpringRetryService;
import org.springframework.remoting.RemoteAccessException;
import org.springframework.retry.annotation.Backoff;
import org.springframework.retry.annotation.EnableRetry;
import org.springframework.retry.annotation.Recover;
import org.springframework.retry.annotation.Retryable;
import org.springframework.stereotype.Service;

@Service
@EnableRetry
public class SpringRetryServiceImpl implements SpringRetryService {

    private static int renum = 0;

    @Override
    @Retryable(value= {CustomException.class},maxAttempts = 3,backoff = @Backoff(delay = 5000l,multiplier = 1))
    public HttpResponse execute() throws Exception {
        System.out.println("重试测试:"+renum);
        if(renum==0){
            throw new CustomException(HttpResponse.HTTP_ERROR,"重试失败了！");
        }
        return new HttpResponse(HttpResponse.HTTP_OK,HttpResponse.HTTP_MSG_OK);
    }
    //TODO 重试的回调不生效
    @Recover
    public void recover(CustomException e) {
        System.out.println("ssdsdswds");
    }

}
