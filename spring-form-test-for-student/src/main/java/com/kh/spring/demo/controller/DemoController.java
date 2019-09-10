package com.kh.spring.demo.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/demo")
public class DemoController {
	
	Logger logger = LoggerFactory.getLogger(getClass()); 
	
	
	@GetMapping("/gymMemberForm.do")
	public void gymMemberForm(Model model) {
		
	}
}
