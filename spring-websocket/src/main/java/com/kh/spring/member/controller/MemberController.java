package com.kh.spring.member.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.authentication.encoding.ShaPasswordEncoder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.kh.spring.member.model.exception.MemberException;
import com.kh.spring.member.model.service.MemberService;
import com.kh.spring.member.model.vo.Member;

import lombok.extern.slf4j.Slf4j;

@SessionAttributes(value={"memberLoggedIn"})
@Controller
@Slf4j
public class MemberController {
	
	
	@Autowired
	private MemberService memberService;

	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;
	
	@GetMapping("/member/memberLogin.do")
	public void memberLogin() {
		
	}
	
	
	/**
	 * RedirectAttributes 와 ModelAndView 함께 사용하지 말것.
	 * 
	 * 로그인 성공시, session에 Member타입 저장시 아래 오류유발
	 * WARN : org.springframework.web.servlet.mvc.support.DefaultHandlerExceptionResolver - Resolved [org.springframework.beans.ConversionNotSupportedException: Failed to convert value of type 'com.kh.spring.member.model.vo.Member' to required type 'java.lang.String'; nested exception is java.lang.IllegalStateException: Cannot convert value of type 'com.kh.spring.member.model.vo.Member' to required type 'java.lang.String': no matching editors or conversion strategy found]
	 */
	@PostMapping("/member/memberLogin.do")
	public String memberLogin(Model model, 
							  @RequestParam String memberId, 
							  @RequestParam String password, 
							  RedirectAttributes redirectAttributes, 
							  HttpSession session){
		if(log.isDebugEnabled()) log.debug("로그인요청!");
		String redirectUrl = "/";
		
		try{
			
			//1.업무로직
			//random salt값으로 암호화하는 BCrypt 방식에서의 로그인 체크
			Member member = memberService.selectOneMember(memberId);
			
			
			//log4j용 예외발생
//			if(true) throw new RuntimeException("내가던진 에러!!!");
			
			//2.bcryptPasswordEncoder를 통해  rawPassword(사용자가 입력한 password)와 encryptPassword(member.password)를 비교
			//로그인한 경우, @SessionAttribute를 이용해 session에 member객체 저장
			if(member != null && 
					bcryptPasswordEncoder.matches(password, member.getPassword())) {
				//로그인 성공
				model.addAttribute("memberLoggedIn", member);
				
				//로그인성공한 경우만 로그인권한 요구했던 페이지 이동
				String next = (String)session.getAttribute("next");
				if(next != null) {
					redirectUrl = next;
					session.removeAttribute("next");
				}
			}
			else {
				//로그인 실패
				redirectAttributes.addFlashAttribute("msg", "입력한 아이디 또는 비밀번호가 일치하지 않습니다.");
			}
			
		
		} catch (Exception e){
			//logging파일 출력용
			log.error( "로그인 에러 : ", e);
			//error페이지를 호출하기 위해 다시한번 exception을 던짐
			throw new MemberException("로그인 에러 : "+e.getMessage());
		}
		
		
		
		return "redirect:"+redirectUrl;
		
	}
	
	@RequestMapping("/member/memberLogout.do")
	public String memberLogout(SessionStatus sessionStatus, HttpSession session){
		if(log.isDebugEnabled()) log.debug("로그아웃요청!");
		
		//현재session상태를 끝났음(Complete)으로 마킹
//		System.out.println("sessionSttus.isComplete()="+sessionStatus.isComplete());
		if(!sessionStatus.isComplete())
			sessionStatus.setComplete();

		return "redirect:/";
	}
}