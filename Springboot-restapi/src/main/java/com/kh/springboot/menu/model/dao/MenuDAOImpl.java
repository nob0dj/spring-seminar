package com.kh.springboot.menu.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.springboot.menu.model.vo.Menu;

@Repository
public class MenuDAOImpl implements MenuDAO {

	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public List<Menu> selectAll() {
		return sqlSession.selectList("menu.selectAll");
	}

	@Override
	public List<Menu> selectMenuByTypeAndTaste(Map<String, String> param) {
		return sqlSession.selectList("menu.selectMenuByTypeAndTaste", param);
	}

	@Override
	public List<Menu> selectMenuByType(Map<String, String> param) {
		return sqlSession.selectList("menu.selectMenuByType", param);
	}

	@Override
	public int insertMenu(Menu menu) {
		return sqlSession.insert("menu.insertMenu", menu);
	}

	@Override
	public int updateMenu(Menu menu) {
		return sqlSession.update("menu.updateMenu", menu);
	}

	@Override
	public int deleteMenu(int id) {
		return sqlSession.delete("menu.deleteMenu", id);
	}

	@Override
	public Menu selectOneMenu(int id) {
		return sqlSession.selectOne("menu.selectOneMenu", id);
	}

}
