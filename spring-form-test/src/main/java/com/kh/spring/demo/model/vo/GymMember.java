package com.kh.spring.demo.model.vo;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


/**
 * 빈 vo객체처리시 spring-form이 null을 대입하게 되는데, 기본형은 이를 처리할 수 없다.
 * 기본형은 wrapper-class로 처리한다.
 * 
 * @author nobodj
 *
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class GymMember {
	private String memberCode;//회원고유번호
	private String memberName;
	private String phone;
	private Double height;
	private Double weight;
	private String gender;	//성별 radio
	private Boolean wannaPT;//pt여부. checkbox 기본값 true
	private String joinPath;//가입경로 radio
	private String[] interest;//관심있는 운동 checkbox
	private GymInstructor gymInstructor;//pt선생님
	
}
