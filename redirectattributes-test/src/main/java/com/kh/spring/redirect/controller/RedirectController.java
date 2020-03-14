package com.kh.spring.redirect.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("redirect")
@Slf4j
public class RedirectController {

	@GetMapping("/form")
	public void form() {
		log.debug("form 페이지 요청");
	}
	
	/**
	 * redirect prefix를 통한 viewName 설정
	 * 
	 * @param email
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@PostMapping("/dml1")
	public String dml1(@RequestParam("email") String email, 
					   Model model,
					   RedirectAttributes redirectAttributes) {
		
		log.debug("email={}",email);
		redirectAttributes.addAttribute("param", "helloworld");
		redirectAttributes.addFlashAttribute("email", email);
		redirectAttributes.addFlashAttribute("msg", "당신의 이메일이 성공적으로 등록되었습니다.");
		
		return "redirect:/redirect/result";
	}

	/**
	 * RedirectView를 사용한 viewName설정
	 * 
	 * @param email
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@PostMapping("/dml2")
	public RedirectView dml2(@RequestParam("email") String email, 
						Model model,
						RedirectAttributes redirectAttributes) {
		log.debug("email={}",email);
		redirectAttributes.addAttribute("param", "helloworld");
		redirectAttributes.addFlashAttribute("email", email);
		redirectAttributes.addFlashAttribute("msg", "당신의 이메일이 성공적으로 등록되었습니다.");
		
		return new RedirectView("/spring/");
	}
	
	/**
	 * redirect된 요청(get)에서 redirectAttribute에 등록된 데이터에 접근 가능하다
	 * - handler메소드 파라미터 : @ModelAttribute사용
	 * - view 페이지: EL로 직접 참조 ${msg}, ${email}
	 * 
	 * @param param
	 * @param msg
	 */
	@GetMapping("/result")
	public void result(@ModelAttribute("param") String param,
					   @ModelAttribute("msg") String msg) {
		
		log.debug("param={}",param);
		log.debug("msg={}",msg);
		
	}
}
