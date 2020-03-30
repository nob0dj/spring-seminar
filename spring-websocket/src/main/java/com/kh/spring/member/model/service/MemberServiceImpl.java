package com.kh.spring.member.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.spring.member.model.dao.MemberDAO;
import com.kh.spring.member.model.vo.Member;

@Service("memberService")
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	MemberDAO memberDAO;
	
	@Override
	public int insertMember(Member member) {
		return memberDAO.inserMember(member);
	}

	@Override
	public Member selectOneMember(String memberId) {
		return memberDAO.selectOneMember(memberId);
	}

	@Override
	public int updateMember(Member member) {
		return memberDAO.updateMember(member);
	}

	@Override
	public int checkIdDuplicate(String memberId) {
		return memberDAO.checkIdDuplicate(memberId);
	}

}
