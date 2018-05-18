package com.ich.system.dao;

import java.util.List;
import java.util.Map;

public interface FeedbackAMapper {

    List<Map<String,Object>> selectByExample(Map<String, Object> example);

}
