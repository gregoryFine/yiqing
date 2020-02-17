package com.ln.yiqing.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Select;

public interface DetailMapper {
	
	@Select("SELECT * FROM yiqing.yq_detail")
	List<Map<String, Object>> findAll();

}
