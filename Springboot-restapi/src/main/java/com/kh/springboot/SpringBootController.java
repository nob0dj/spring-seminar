package com.kh.springboot;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class SpringBootController {
	
	@RequestMapping("/")
	@ResponseBody
	public String home(){
		return "hello, springboooooooooooooot!";
	}
	
	/**
	 * 
	 * menu.jsp forwading처리함.
	 *
	 * @param model
	 * @return
	 */
	@RequestMapping("/menu")
	public String menu(Model model){
		//테스트용
		//header로 키값 정의하지 말것. 이미  존재함.
		model.addAttribute("test", "Springboooooooooooooooot");
		return "menu/menu";
	}
	
}
