package com.kh.spring.stomp.model.vo;

import java.io.Serializable;
import java.util.Date;

import com.kh.spring.member.model.vo.Member;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(callSuper=true)
public class ChatMember extends Member implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long id;
	private ChatRoom chatRoom;
	private long lastCheck;
	private Date regDate;
	private Date expDate;
	private boolean enabled;
	
	public ChatMember(String memberId, ChatRoom chatRoom) {
		this.setMemberId(memberId);
		this.chatRoom = chatRoom;
	}

}
