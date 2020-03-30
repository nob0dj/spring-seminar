package com.kh.spring.member.model.dao;

import com.kh.spring.member.model.vo.Member;

public interface MemberDAO {

	int inserMember(Member member);

	Member selectOneMember(String userId);

	int updateMember(Member member);

	int checkIdDuplicate(String userId);

}
