package com.ich.system.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ich.admin.dto.LocalEmployee;
import com.ich.admin.service.LocalEmployeeService;
import com.ich.admin.service.impl.LocalEmployeeServiceImpl;
import com.ich.base.SourceConst;
import com.ich.core.http.entity.HttpResponse;
import com.ich.core.http.entity.PageView;
import com.ich.extend.dao.IFeedbackMapper;
import com.ich.extend.pojo.IExamine;
import com.ich.extend.service.IExamineService;
import com.ich.system.dao.FeedbackAMapper;
import com.ich.system.service.FeedbackAService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class FeedbackAServiceImpl implements FeedbackAService {

    @Autowired
    private FeedbackAMapper feedbackAMapper;
    @Autowired
    private IFeedbackMapper iFeedbackMapper;
    @Autowired
    private IExamineService examineService;
    @Autowired
    private LocalEmployeeService localEmployeeService;

    @Override
    public HttpResponse updateFeedbackOfHandle(String id, String handlermark) {
        iFeedbackMapper.updateStatus(id,1);
        LocalEmployee localEmployee = localEmployeeService.findLocalEmployee();
        IExamine examine = new IExamine();
        examine.setSource(SourceConst.FEEDBACK_HANDLE);
        examine.setSourceid(id);
        examine.setHandlername(localEmployee.getEmployeeName());
        examine.setHandleresult(1);
        examine.setHandlermark(handlermark);
        examineService.addExamine(examine,true);
        return new HttpResponse(HttpResponse.HTTP_OK,HttpResponse.HTTP_MSG_OK);
    }

    @Override
    public List<Map<String, Object>> queryFeedback(PageView view, String searchkey) {
        PageHelper.startPage(view.getPage(),view.getRows());
        Map<String,Object> example = new HashMap<>();
        example.put("searchkey",searchkey);
        example.put("source",SourceConst.FEEDBACK_HANDLE);
        List<Map<String,Object>> list = feedbackAMapper.selectByExample(example);
        PageInfo<Map<String,Object>> pageInfo = new PageInfo<>(list);
        view.setRowCount(pageInfo.getTotal());
        return list;
    }
}
