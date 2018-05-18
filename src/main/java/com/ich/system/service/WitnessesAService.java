package com.ich.system.service;

import com.ich.core.http.entity.HttpResponse;
import com.ich.core.http.entity.PageView;

import java.util.List;
import java.util.Map;

public interface WitnessesAService {

    HttpResponse updateWitnessesOfHandle(String wid, String handlermark);

    List<Map<String,Object>> queryWitnesses(PageView view, String wname, Integer status);

    List<Map<String,Object>> queryWitnessesWidList(PageView view, String wid);
}
