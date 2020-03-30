package com.kh.spring.stomp.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.kh.spring.member.model.vo.Member;
import com.kh.spring.stomp.model.service.StompService;
import com.kh.spring.stomp.model.vo.Msg;
import com.kh.spring.stomp.model.vo.Notice;

import lombok.extern.slf4j.Slf4j;



@Controller
@Slf4j
@RequestMapping("/admin")
public class AdminController {
		
	@Autowired
	StompService stompService;
	
	@Autowired
	SimpMessagingTemplate simpleMessageingTemplate;
	
	/**
	 * 관리자 유효성 검사 포함
	 * 
	 * @param model
	 * @param session
	 * @param memberLoggedIn
	 */
	@ModelAttribute
	public void common(Model model, 
					   HttpSession session, 
					   @SessionAttribute(value="memberLoggedIn", required=false) Member memberLoggedIn) {
		//로그인하지 않은 경우, IllegalStateException 예외 던짐.
		String memberId = Optional.ofNullable(memberLoggedIn)//memberLoggedIn은 nullable하다. 로그인 하지 않은 경우 null
								  .map(Member::getMemberId)	//memberId를 가져온다. 메소드 참조
								  .filter(memberId_->"admin".equals(memberId_)) //"admin"여부 검사. false인겨우 emtpy Optional객체 리턴
								  .orElseThrow(()-> new IllegalStateException("관리자만 이용할 수 있습니다."));
		
		model.addAttribute("memberId", memberId);
		log.debug("memberId 속성값 설정되었음. [{}]",memberId);
	}
	
	@GetMapping("/chat/list")
	public String admin(Model model, 
						@ModelAttribute("memberId")String memberId){
		
		//최근 사용자 채팅메세지 목록
		List<Map<String, String>> recentList = stompService.findRecentList();
		log.info("recentList={}",recentList);
		
		model.addAttribute("recentList", recentList);
		
		return "admin/chatList";
		
	}
	
	
	@GetMapping("/chat/{chatId}")
	public String adminChat(@PathVariable("chatId") String chatId, Model model){
		
		List<Msg> chatList = stompService.findChatListByChatId(chatId);
		model.addAttribute("chatList", chatList);
		
		log.info("chatList={}",chatList);
		return "admin/chat";
	}

	@GetMapping("/simpMessagingTemplate/{memberId}")
	@ResponseBody
	public Map<String, ?> simpMessagingTemplate(@PathVariable("memberId") String memberId){
		
		//전송할 notice객체 생성. 어떤 타입도 전송 가능하다.
		Notice notice = new Notice();
		notice.setFrom("admin");
		notice.setTo(memberId);
		notice.setMsg("simpMessagingTemplate을 통해 전송됨");
		notice.setTime(System.currentTimeMillis());
		
		//DI받은 simpleMessageingTemplate객체를 사용해 메세지를 직접 보낸다.
		//void org.springframework.messaging.core.AbstractMessageSendingTemplate.convertAndSend(String destination, Object payload) throws MessagingException
		simpleMessageingTemplate.convertAndSend("/notice/"+memberId, notice);
		
		//ajax 요청에 대한 응답 작성
		Map<String, Object> map = new HashMap<>();
		map.put("msg", "전송완료!");
		return map;
	}
	
	
}
