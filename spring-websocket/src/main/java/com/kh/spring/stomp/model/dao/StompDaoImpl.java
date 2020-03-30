package com.kh.spring.stomp.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.spring.stomp.model.vo.ChatMember;
import com.kh.spring.stomp.model.vo.ChatRoom;
import com.kh.spring.stomp.model.vo.Msg;

@Repository
public class StompDaoImpl implements StompDao {

	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public String findChatIdByMemberId(String memberId) {
		return sqlSession.selectOne("stomp.findChatIdByMemberId", memberId);
	}

	@Override
	public String selectOneChatId(String chatId) {
		return sqlSession.selectOne("stomp.selectOneChatId", chatId);
	}
	
	@Override
	public int insertChatRoom(ChatRoom chatRoom) {
		return sqlSession.insert("stomp.insertChatRoom", chatRoom);
	}
	
	@Override
	public int insertChatMember(ChatMember chatMember) {
		return sqlSession.insert("stomp.insertChatMember", chatMember);
	}

	@Override
	public int updateLastCheck(Msg fromMessage) {
		return sqlSession.update("stomp.updateLastCheck", fromMessage);	
	}

	@Override
	public int insertChatLog(Msg fromMessage) {
		return sqlSession.insert("stomp.insertChatLog", fromMessage);
	}

	@Override
	public int deleteChatRoom(String chatId) {
		return sqlSession.update("stomp.deleteChatRoom", chatId);
	}

	@Override
	public List<Map<String, String>> findRecentList() {
		return sqlSession.selectList("stomp.findRecentList");
	}

	@Override
	public List<Msg> findChatListByChatId(String chatId) {
		return sqlSession.selectList("stomp.findChatListByChatId", chatId);
	}

	

	

	

	
}
