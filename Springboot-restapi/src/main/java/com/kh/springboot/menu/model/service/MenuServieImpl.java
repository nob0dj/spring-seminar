package com.kh.springboot.menu.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.springboot.menu.model.dao.MenuDAO;
import com.kh.springboot.menu.model.vo.Menu;


@Service
public class MenuServieImpl implements MenuService {
	
	@Autowired
	private MenuDAO menuDAO;
	
	@Override
	public List<Menu> selectAll() {
		return menuDAO.selectAll();
	}

	@Override
	public List<Menu> selectMenuByTypeAndTaste(Map<String, String> param) {
		return menuDAO.selectMenuByTypeAndTaste(param);
	}

	@Override
	public List<Menu> selectMenuByType(Map<String, String> param) {
		return menuDAO.selectMenuByType(param);
	}

	@Override
	public int insertMenu(Menu menu) {
		return menuDAO.insertMenu(menu);
	}

	@Override
	public int updateMenu(Menu menu) {
		return menuDAO.updateMenu(menu);
	}

	@Override
	public int deleteMenu(int id) {
		return menuDAO.deleteMenu(id);
	}

	@Override
	public Menu selectOneMenu(int id) {
		return menuDAO.selectOneMenu(id);
	}


}
