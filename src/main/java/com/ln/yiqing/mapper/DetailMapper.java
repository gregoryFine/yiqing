package com.ln.yiqing.mapper;

import java.util.List;
import java.util.Map;

public interface DetailMapper {
	
	//@Select("SELECT * FROM yiqing.yq_detail")
	List<Map<String, Object>> findAll();

}
