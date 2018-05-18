package com.ich.system.service.impl;


import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ich.admin.dto.LocalEmployee;
import com.ich.admin.service.LocalEmployeeService;
import com.ich.admin.service.impl.LocalEmployeeServiceImpl;
import com.ich.base.SourceConst;
import com.ich.core.http.entity.HttpResponse;
import com.ich.core.http.entity.PageView;
import com.ich.extend.dao.IWitnessesMapper;
import com.ich.extend.pojo.IExamine;
import com.ich.extend.pojo.IWitnesses;
import com.ich.extend.service.IExamineService;
import com.ich.extend.service.IWitnessesService;
import com.ich.system.dao.IWitnessesAMapper;
import com.ich.system.service.WitnessesAService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class WitnessesAServiceImpl implements WitnessesAService {

    @Autowired
    private IWitnessesService witnessesService;
    @Autowired
    private IWitnessesMapper witnessesMapper;
    @Autowired
    private IWitnessesAMapper witnessesAMapper;
    @Autowired
    private IExamineService examineService;
    @Autowired
    private LocalEmployeeService localEmployeeService;

    @Override
    public HttpResponse updateWitnessesOfHandle(String wid, String handlermark) {
        //注意：因批量处理的原因在添加处理信息时，会比较麻烦，待更简单的方案
        List<IWitnesses> list = witnessesMapper.selectWitnessesWidList(wid);
        HttpResponse response = witnessesService.updateWitnessesOfHandle(wid);
        if(response.getStatus()==HttpResponse.HTTP_OK){
            String sourceids = "";
            for(IWitnesses witnesses : list){
                sourceids += witnesses.getId() + ",";
            }
            sourceids = sourceids.substring(0,sourceids.length()-1);
            LocalEmployee localEmployee = localEmployeeService.findLocalEmployee();
            IExamine examine = new IExamine();
            examine.setSource(SourceConst.WITNESSES_HANDLE);
            examine.setHandlername(localEmployee.getEmployeeName());
            examine.setHandleresult(1);
            examine.setHandlermark(handlermark);
            examineService.addExamines(examine,sourceids,true);
        }
        return response;
    }

    @Override
    public List<Map<String, Object>> queryWitnesses(PageView view,String wname, Integer status) {
        PageHelper.startPage(view.getPage(),view.getRows());
        Map<String,Object> example = new HashMap<>();
        example.put("status",status);
        example.put("wname",wname);
        example.put("source",SourceConst.WITNESSES_HANDLE);
        List<Map<String,Object>> list = witnessesAMapper.selectByExample(example);
        PageInfo<Map<String,Object>> pageInfo = new PageInfo<>(list);
        view.setRowCount(pageInfo.getTotal());
        return list;
    }

    @Override
    public List<Map<String, Object>> queryWitnessesWidList(PageView view, String wid) {
        PageHelper.startPage(view.getPage(),view.getRows());
        Map<String,Object> example = new HashMap<>();
        example.put("wid",wid);
        example.put("status",0);//只看未处理的
        example.put("source",SourceConst.WITNESSES_HANDLE);
        List<Map<String,Object>> list = witnessesAMapper.selectByExample(example);
        PageInfo<Map<String,Object>> pageInfo = new PageInfo<>(list);
        view.setRowCount(pageInfo.getTotal());
        return list;
    }
}
