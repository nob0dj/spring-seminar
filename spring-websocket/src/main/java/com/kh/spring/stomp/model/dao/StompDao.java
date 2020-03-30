package com.kh.spring.stomp.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.spring.stomp.model.vo.ChatMember;
import com.kh.spring.stomp.model.vo.ChatRoom;
import com.kh.spring.stomp.model.vo.Msg;

public interface StompDao {

	String findChatIdByMemberId(String memberId);

	String selectOneChatId(String chatId);

	int insertChatRoom(ChatRoom chatRoom);
	
	int insertChatMember(ChatMember chatMember);

	int insertChatLog(Msg fromMessage);

	int deleteChatRoom(String chatId);

	int updateLastCheck(Msg fromMessage);

	//관리자용
	List<Map<String, String>> findRecentList();

	List<Msg> findChatListByChatId(String chatId);



}
