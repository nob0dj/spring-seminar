package com.kh.spring.demo.model.validator;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import com.kh.spring.demo.model.vo.GymMember;

public class GymMemberValidator implements Validator{

	/**
	 * command객체가 현재 등록된 GymMember타입이거나 후손클래스인지 검사하여 boolean을 리턴함.    
	 */
	@Override
	public boolean supports(Class<?> clazz) {
		return GymMember.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {

		GymMember gymMember = (GymMember)target;
		if(gymMember.getMemberName().isEmpty()) {
			//void org.springframework.validation.ValidationUtils.rejectIfEmptyOrWhitespace(Errors errors, String field, String errorCode)
			//messages.properties에서 errorCode를 키값으로 조회, 해당하는 사용자 피드백메세지를 전송
			ValidationUtils.rejectIfEmptyOrWhitespace(errors, "memberName", "required.memberName");
		}
		
		if(gymMember.getPhone().isEmpty())
			ValidationUtils.rejectIfEmptyOrWhitespace(errors, "phone", "required.phone");
	}

}
