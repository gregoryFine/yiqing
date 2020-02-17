package com.ln.yiqing.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ReadExcel {
	
	@SuppressWarnings("deprecation")
	public List<List<String>> readExcel(String location) {
		
		List<List<String>> listAll = new ArrayList<List<String>>();
		try {
			String filePath = this.getClass().getClassLoader().getResource(location).getPath();
			File excelFile = new File(filePath);
			XSSFWorkbook wb = new XSSFWorkbook(new FileInputStream(excelFile));
			XSSFSheet sheet = wb.getSheetAt(0);
			
			for (Row row : sheet) {
			    List<String> list = new ArrayList<String>();
			      for (Cell cell : row) {
			        switch (cell.getCellType()) {
			            case Cell.CELL_TYPE_STRING://字符串
			                String  categoryName = cell.getRichStringCellValue().getString();
			                list.add(categoryName);
			                break;
			            case Cell.CELL_TYPE_NUMERIC://数值与日期
			                String axis = Double.toString(cell.getNumericCellValue());
			                list.add(axis);
			                break;
			            case Cell.CELL_TYPE_BLANK://空值
			            	list.add("");
			            	break;
			            default:
			        }
			    }
			    listAll.add(list);
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
        return listAll;
		
	}
	
	

}
