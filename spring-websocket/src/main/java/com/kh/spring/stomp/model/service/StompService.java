package com.kh.spring.stomp.model.service;

import java.util.List;
import java.util.Map;

import com.kh.spring.stomp.model.vo.ChatMember;
import com.kh.spring.stomp.model.vo.Msg;

public interface StompService {

	String findChatIdByMemberId(String memberId);

	String selectOneChatId(String string);
	
	int createChatRoom(List<ChatMember> list);

	int insertChatLog(Msg fromMessage);

	int deleteChatRoom(String chatId);

	int updateLastCheck(Msg fromMessage);

	
	//관리자용
	List<Map<String, String>> findRecentList();

	List<Msg> findChatListByChatId(String chatId);


}
