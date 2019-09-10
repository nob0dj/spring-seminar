package com.kh.spring.demo.controller;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.BindingResult;
import org.springframework.validation.BindingResult;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.spring.demo.model.validator.GymMemberValidator;
import com.kh.spring.demo.model.vo.GymInstructor;
import com.kh.spring.demo.model.vo.GymMember;

@Controller
@RequestMapping("/demo")
public class DemoController {
	
	Logger logger = LoggerFactory.getLogger(getClass()); 
	
	/**
	 * DemoController의 모든 요청에서 model속성으로 참조할 수 있도록 @ModelAttribute로 선언함.
	 * 
	 * @param model
	 */
	@ModelAttribute
	public void common(Model model){
		//1.성별 radiobutton
		String[] gender = {"M","F"};
		
		//2.가입경로 radiobuttons
		String[] joinPath = {"인터넷광고", "전단지광고", "지인소개", "기타"};
		
		//3.관심운동: checkboxes
		List<String> interestList = new ArrayList<String>();
		interestList.add("Pilates");
		interestList.add("Yoga");
		interestList.add("Spinning");
		interestList.add("Jazz Dance");
		interestList.add("Swing");
		
		//4.pt샘: label과 checkbox:value가 다른 경우
		List<GymInstructor> gymInstructorList = new ArrayList<GymInstructor>();
		gymInstructorList.add(new GymInstructor("honggd", "홍길동"));
		gymInstructorList.add(new GymInstructor("sinsa", "신사임당"));
		gymInstructorList.add(new GymInstructor("leess", "리순신"));	
		
		model.addAttribute("gender", gender);
		model.addAttribute("joinPath", joinPath);
		model.addAttribute("interestList", interestList);
		model.addAttribute("gymInstructorList", gymInstructorList);
		
	}

	/**
	 * 
	 * 폼에서 사용할 값을 vo객체(@ModelAttribute)에 등록해둔다.
	 * 
	 * @param gymMember
	 * @param model
	 */
	@GetMapping("/gymMemberForm.do")
	public void gymMemberForm(@ModelAttribute GymMember gymMember, Model model) {
//		//1.성별 radiobutton
//		String[] gender = {"M","F"};
//		
//		//2.가입경로 radiobuttons
//		String[] joinPath = {"인터넷광고", "전단지광고", "지인소개", "기타"};
//		
//		//3.관심운동: checkboxes
//		List<String> interestList = new ArrayList<String>();
//		interestList.add("Pilates");
//		interestList.add("Yoga");
//		interestList.add("Spinning");
//		interestList.add("Jazz Dance");
//		interestList.add("Swing");
//		
//		//4.pt샘: label과 checkbox:value가 다른 경우
//		List<GymInstructor> gymInstructorList = new ArrayList<GymInstructor>();
//		gymInstructorList.add(new GymInstructor("honggd", "홍길동"));
//		gymInstructorList.add(new GymInstructor("sinsa", "신사임당"));
//		gymInstructorList.add(new GymInstructor("leess", "리순신"));	
//		
//		model.addAttribute("gender", gender);
//		model.addAttribute("joinPath", joinPath);
//		model.addAttribute("interestList", interestList);
//		model.addAttribute("gymInstructorList", gymInstructorList);
		
	}
	
	
	
	/**
	 * 폼에서 사용할 값을 vo객체(@ModelAttribute)에 등록해둔다.
	 * 
	 * @param gymMember
	 * @param model
	 */
	@GetMapping("/gymMemberUpdateForm.do")
	public void gymMemberUpdateForm(@ModelAttribute("gymMember") GymMember gymMember) {
		
		//vo 사용자정보 표시하기
		gymMember.setMemberName("안중근");
		gymMember.setHeight(188.8);
		gymMember.setWeight(80.0);
		gymMember.setPhone("01012341234");
		gymMember.setGender("M");
		gymMember.setJoinPath("지인소개");
		//pt신청여부: checkbox(checked처리하기)
		gymMember.setWannaPT(true);
		//Yoga, Swing을 checked처리하기
		gymMember.setInterest(new String[] {"Yoga", "Swing"});
		//leess를 checked처리하기
		gymMember.setGymInstructor(new GymInstructor("leess", "리순신"));
		
	}
	
	@PostMapping("/gymMemberInsert.do")
	public String gymMemberInsert(@Valid GymMember gymMember, BindingResult result) {
		logger.debug("회원 등록 요청!");
		logger.debug("gymMember={}",gymMember);
		
		if(result.hasErrors()) {
			return "demo/gymMemberForm";//forward방식 지정.
		}
		
		logger.debug("회원 등록 성공!");
		return "redirect:/demo/gymMemberForm.do";//redirect방식 지정
	}
	
	/**
	 * @InitBinder
	 * WebDataBinder(사용자 요청을 자바빈으로 바인딩함)객체 초기화 목적의 어노테이션
	 */
	@InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.setValidator(new GymMemberValidator());
    }
	
	@PostMapping("/gymMemberUpdate.do")
	public String gymMemberUpdate(@Valid GymMember gymMember, BindingResult result) {
		logger.debug("회원 수정 요청!");
		logger.debug("gymMember={}",gymMember);
		
		if(result.hasErrors()) {
			return "demo/gymMemberUpdateForm";//forward방식 지정.
		}
		
		logger.debug("회원 등록 성공!");
		return "redirect:/demo/gymMemberUpdateForm.do";//redirect방식 지정
	}
}
