package com.kh.spring.stomp.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.kh.spring.member.model.vo.Member;
import com.kh.spring.stomp.model.service.StompService;
import com.kh.spring.stomp.model.vo.ChatMember;
import com.kh.spring.stomp.model.vo.ChatRoom;
import com.kh.spring.stomp.model.vo.Msg;
import com.kh.spring.stomp.model.vo.Notice;

import lombok.extern.slf4j.Slf4j;



@Controller
@Slf4j
public class StompController {
		
	@Autowired
	StompService stompService;
	
	/**
	 * 현재 Controller의 모든 사용자 요청에 
	 * 이 @modelAttribute 메소드를 호출해서 view model에 memberId 속성을 추가하도록한다.
	 * 
	 * @param model
	 * @param session
	 * @param memberLoggedIn
	 */
	@ModelAttribute
	public void common(Model model, 
					   HttpSession session, 
					   @SessionAttribute(value="memberLoggedIn", required=false) Member memberLoggedIn) {
		//비회원일 경우, httpSessionId값을 memberId로 사용한다.
		String memberId = Optional.ofNullable(memberLoggedIn)
								  .map(Member::getMemberId)
								  .orElse(session.getId());//HttpSession의 JSESSIONID값을 저장
		model.addAttribute("memberId", memberId);
		log.debug("memberId 속성값 설정되었음. [{}]",memberId);
	}
	
	@GetMapping("/")
	public String index() {
		//@web.xml 의 welcome-file관련 주석 제거할 것. ${CATALINA_HOME}/conf/web.xml, /WEB-INF/web.xml 
		//welcome-file이 아닌 HandlerMapping을 통한 처리
		return "forward:/index.jsp";
	}
	
	
	@GetMapping("/chat")
	public String chat(Model model, 
					  @ModelAttribute("memberId")String memberId){
		
		
		//chatId조회
		//1.memberId로 등록한 chatroom존재여부 검사. 있는 경우 chatId 리턴.
		String chatId = stompService.findChatIdByMemberId(memberId);
		
		//2.로그인을 하지 않았거나, 로그인을 해도 최초접속인 경우 chatId를 발급하고 db에 저장한다.
		if(chatId == null){
			chatId = createChatId(20);//chat_randomToken -> jdbcType=char(20byte)
			
			ChatRoom chatRoom = new ChatRoom(chatId);
			List<ChatMember> list = new ArrayList<>();
			list.add(new ChatMember(memberId, chatRoom));
			list.add(new ChatMember("admin", chatRoom));
			
			//chat_room, chat_member테이블에 데이터 생성
			stompService.createChatRoom(list);
		}
		//chatId가 존재하는 경우, 채팅내역 조회
		else{
			List<Msg> chatList = stompService.findChatListByChatId(chatId);
			model.addAttribute("chatList", chatList);
		}
		
		log.debug("memberId=[{}], chatId=[{}]",memberId, chatId);
		
		model.addAttribute("chatId", chatId);
		
		return "chat/chat";
	}
	
	/**
	 * 인자로 전달될 길이의 임의의 문자열을 생성하는 메소드
	 * 영대소문자/숫자의 혼합.
	 * 
	 * @param len
	 * @return
	 */
	private String createChatId(int len){
		Random rnd = new Random();
		StringBuffer buf = new StringBuffer();
		String prefix = "chat";
		
		do {
			buf.setLength(0);//buf 비우기 
			buf.append(prefix);
			for(int i=0; i<len-prefix.length(); i++){
				//임의의 참거짓에 따라 참=>영대소문자, 거짓=> 숫자
				switch(rnd.nextInt(3)) {
				case 0: buf.append((char)(rnd.nextInt(26)+65)); break;
				case 1: buf.append((char)(rnd.nextInt(26)+97)); break;
				case 2: buf.append((rnd.nextInt(10))); break;
				}
			}
		//중복여부 검사
		} while(stompService.selectOneChatId(buf.toString()) != null);
		log.info("chatId가 생성되었음 [{}]",buf.toString());
		
		return buf.toString();
	}
	
	
	/**
	 * - @MessageMapping 을 통해 메세지를 받고,
	 * - @SendTo 를 통해 메세지 전달. 작성된 주소를 구독하고 있는 client에게 메세지 전송
	 * 
	 * @param fromMessage
	 * @return
	 */
	@MessageMapping("/admin/notice")
	@SendTo("/notice")
	public Notice stomp(Notice notice){
		log.debug("notice={}",notice);
		return notice; 
	}

	@MessageMapping("/admin/notice/{memberId}")
	@SendTo("/notice/{memberId}")
	public Notice notice(Notice notice, 
						@DestinationVariable String memberId){
		log.debug("notice={}",notice);
		log.debug("@DestinationVariable memberId={}",memberId);
		
		return notice;
	}
	
	
	
	
	@MessageMapping("/chat/{chatId}")
	@SendTo(value={"/chat/{chatId}", "/chat/admin/push"})
	public Msg sendEcho(Msg fromMessage, 
						@DestinationVariable String chatId){
		log.debug("fromMessage={}",fromMessage);
		
		//db에 메세지로그
		stompService.insertChatLog(fromMessage);

		return fromMessage; 
	}
	/**
	 * 읽음 여부 확인을 위해 최종 focus된 시각정보를 수집한다.
	 * 
	 * @param fromMessage
	 * @return
	 */
	@MessageMapping("/lastCheck")
	@SendTo(value={"/chat/admin/push"})
	public Msg lastCheck(@RequestBody Msg fromMessage){
		log.debug("lastCheck={}",fromMessage);
		
		//db에 채팅방별 사용자 최종확인 시각을 갱신한다.
		stompService.updateLastCheck(fromMessage);
		
		return fromMessage; 
	}
	
}
