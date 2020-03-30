package com.kh.spring.member.model.service;

import com.kh.spring.member.model.vo.Member;

public interface MemberService {
	//로그인처리를 위한 상수 선언
	public static int LOGIN_OK = 1;
	public static int WRONG_PASSWORD = 0;
	public static int ID_NOT_EXIST = -1;

	int insertMember(Member member);

	Member selectOneMember(String memberId);

	int updateMember(Member member);

	int checkIdDuplicate(String memberId);

}
