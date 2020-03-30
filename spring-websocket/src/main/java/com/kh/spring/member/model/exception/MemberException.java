package com.kh.spring.member.model.exception;

public class MemberException extends RuntimeException {
	
	public MemberException() {}

	public MemberException(String message) {
		super(message);
	}

}
