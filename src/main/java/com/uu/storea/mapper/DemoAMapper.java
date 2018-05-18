package com.uu.storea.mapper;

import com.uu.storea.pojo.DemoA;
import com.uu.storea.pojo.DemoAExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DemoAMapper {
    int countByExample(DemoAExample example);

    int deleteByExample(DemoAExample example);

    int deleteByPrimaryKey(@Param("id") String id);

    int insert(DemoA record);

    int insertSelective(DemoA record);

    List<DemoA> selectByExample(DemoAExample example);

    DemoA selectByPrimaryKey(@Param("id") String id);

    int updateByExampleSelective(@Param("record") DemoA record, @Param("example") DemoAExample example);

    int updateByExample(@Param("record") DemoA record, @Param("example") DemoAExample example);

    int updateByPrimaryKeySelective(DemoA record);

    int updateByPrimaryKey(DemoA record);

}