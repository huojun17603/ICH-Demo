package com.ich.system.service;

import com.ich.core.http.entity.HttpResponse;
import com.ich.core.http.entity.PageView;

import java.util.List;
import java.util.Map;

public interface FeedbackAService {

    HttpResponse updateFeedbackOfHandle(String id, String handlermark);

    List<Map<String,Object>> queryFeedback(PageView view, String searchkey);

}
