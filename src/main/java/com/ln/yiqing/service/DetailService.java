package com.ln.yiqing.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ln.yiqing.mapper.DetailMapper;

@Service
public class DetailService {
	
	@Autowired
	private DetailMapper detailMapper;
	
	public List<Map<String, Object>> findAll(){
		return detailMapper.findAll();
	}

}
