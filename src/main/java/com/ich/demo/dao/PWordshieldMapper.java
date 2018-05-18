package com.ich.demo.dao;

import java.util.List;

import com.ich.demo.pojo.PWordshield;
import com.ich.demo.pojo.PWordshieldExample;
import org.apache.ibatis.annotations.Param;

public interface PWordshieldMapper {
    int countByExample(PWordshieldExample example);

    int deleteByExample(PWordshieldExample example);

    int deleteByPrimaryKey(String id);

    int insert(PWordshield record);

    int insertSelective(PWordshield record);

    List<PWordshield> selectByExample(PWordshieldExample example);

    PWordshield selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") PWordshield record, @Param("example") PWordshieldExample example);

    int updateByExample(@Param("record") PWordshield record, @Param("example") PWordshieldExample example);

    int updateByPrimaryKeySelective(PWordshield record);

    int updateByPrimaryKey(PWordshield record);
}