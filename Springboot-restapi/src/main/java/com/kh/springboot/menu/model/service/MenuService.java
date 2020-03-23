package com.kh.springboot.menu.model.service;

import java.util.List;
import java.util.Map;

import com.kh.springboot.menu.model.vo.Menu;

public interface MenuService {

	List<Menu> selectAll();
	
	List<Menu> selectMenuByTypeAndTaste(Map<String, String> param);

	List<Menu> selectMenuByType(Map<String, String> param);

	int insertMenu(Menu menu);

	Menu selectOneMenu(int id);

	int updateMenu(Menu menu);

	int deleteMenu(int id);


	

}
