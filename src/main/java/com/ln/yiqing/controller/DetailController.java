package com.ln.yiqing.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ln.yiqing.service.DetailService;
import com.ln.yiqing.util.ReadExcel;

@Controller
@RequestMapping("/detail")
public class DetailController {

	@Autowired
	private DetailService detailService;

	@RequestMapping("/index")
	public String index() {
		return "indexGaoDe";
	}

	@RequestMapping("/indexb")
	public String indexb() {
		return "indexBaiDu";
	}

	@RequestMapping("/findAll")
	@ResponseBody
	public List<Map<String, Object>> findAll() {
		String excelResourcePath = "excel/yiqing.xlsx";
		List<List<String>> a = new ReadExcel().readExcel(excelResourcePath);
		List<List<String>> b = a.subList(1, a.size());
	
		String[] strArr = new String[] { "org_no", "cons_no", "box_id", "asset_no", "tg_id", "cons_name", "sbbm", "oid",
				"jxl_x", "jxl_y", "byq_x", "byq_y", "jxl_x_xz", "jxl_y_xz", "cus_flag" };
		List<Map<String, Object>> returnList = new ArrayList<>();
		for (List<String> list : b) {
			Map<String, Object> returnMap = new HashMap<>();
			for (int i = 0; i < list.size(); i++) {
				returnMap.put(strArr[i], list.get(i));
			}
			returnList.add(returnMap);
		}
		return returnList;
	}

}
