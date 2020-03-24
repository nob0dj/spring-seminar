package com.kh.springboot.menu.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.springboot.menu.model.service.MenuService;
import com.kh.springboot.menu.model.vo.Menu;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
public class MenuController {
	
	@Autowired
	private MenuService menuService;
	
	
	@GetMapping("/menus")
	public List<Menu> selectAll(){
		return menuService.selectAll();
	}
	
	
	@GetMapping("/menus/{type}")
	public List<Menu> selectMenuByType(@PathVariable("type") String type){
		Map<String,String> param = new HashMap<>();
		param.put("type", type);
		log.debug("param={}", param);
		
		return menuService.selectMenuByType(param);
	}

	
	@GetMapping("/menus/{type}/{taste}")
	public List<Menu> selectMenuByTypeAndTaste(@PathVariable ("type") String type, @PathVariable ("taste") String taste, HttpServletResponse response){
		Map<String,String> param = new HashMap<>();
		param.put("type", type);
		param.put("taste", taste);
		log.debug("param={}", param);
		
		//CORS 허용하기 : 응답헤더에 해당Origin을 작성해서 허용한다.
//		response.setHeader("Access-Control-Allow-Origin", "http://localhost:9090");//protocol+hostname+port
//		response.setHeader("Access-Control-Allow-Origin", "*");//모든 Origin에 대해 허용하기
		
		return menuService.selectMenuByTypeAndTaste(param);
	}
	
	
	@PostMapping("/menu")
	public Map<String,String> insertMenu(@RequestBody Menu menu){
		log.info("menu="+menu.toString());
		String msg  = menuService.insertMenu(menu)>0?"메뉴입력 성공":"메뉴입력 실패";
		
		//리턴타입도 json변환가능한 map 전송함.
		Map<String,String> map = new HashMap<>();
		map.put("msg", msg);
		return map;
	}
	
	
	@GetMapping("/menu/{id}")
	public Menu selectOneMenu(@PathVariable("id") int id){
		log.debug("메뉴 선택 : "+id);
		
		Menu menu = menuService.selectOneMenu(id);
		if(menu==null) menu = new Menu();//null데이터를 json으로 변환불가하므로, 빈객체 전달		
		
		return menu;
	}
	
	
	@PutMapping("/menu")
	public Map<String,String> updateMenu(@RequestBody Menu menu){
		log.info(menu.toString());
		String msg  = menuService.updateMenu(menu)>0?"메뉴수정 성공":"메뉴수정 실패";
		
		//리턴타입도 json변환가능한 map 전송함.
		Map<String,String> map = new HashMap<>();
		map.put("msg", msg);
		return map;
	}
	
	
	@DeleteMapping("/menu/{id}")
	public Map<String,String> deleteMenu(@PathVariable("id") int id){
		log.info("삭제할 메뉴번호 : "+id);	
		
		String msg  = menuService.deleteMenu(id)>0?"메뉴삭제 성공":"메뉴삭제 실패";
		
		//리턴타입도 json변환가능한 map 전송함.
		Map<String,String> map = new HashMap<>();
		map.put("msg", msg);
		return map;
	}
	
	
}
 