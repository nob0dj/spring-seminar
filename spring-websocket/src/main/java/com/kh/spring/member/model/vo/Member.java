package com.kh.spring.member.model.vo;

import java.io.Serializable;
import java.sql.Date;
import java.util.Arrays;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * VO Value Object : 데이터베이스 테이블 Member의 각 컬럼값 저장용 객체 : 한 행의 정보를 저장
 * DTO Data Tranfer Object
 * DO Domain Object
 * Entity(Strut에서는 이용어를 사용함)
 * bean(EJB에서 사용): 엔터프라이즈 자바빈즈(Enterprise JavaBeans; EJB)는 기업환경의 시스템을 구현하기 위한 서버측 컴포넌트 모델이다. 즉, EJB는 애플리케이션의 업무 로직을 가지고 있는 서버 애플리케이션이다.
 * 
 * VO 조건
 * 1. 모든 필드는 반드시 private여야함.
 * 2. 기본생성자와 매개변수 있는 생성자필요
 * 3. 모든 필드에 대한 getter/setter 필요
 * 4. 직렬화 처리(네트워크상 데이터처리를 위함)
 * 
 * @author nobodj
 *
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Member implements Serializable{
	/**
	 * 직렬화/역직렬화
	 * 40BYTE의 객체를 파일입출력단위로 직렬화, 수신측에서 역직렬화시 여러객체를 구분할 고유아이디가 필요하다. 
	 * 없다면, 이후 framework작업에서 에러유발
	 */
	private static final long serialVersionUID = 1L;
	
	private String memberId;
	private String password;
	private String memberName;
	private String gender;		//PreparedStatement에 setCharacter메소드 없음.
	private Date birthDay; 
	private String email;
	private String phone;
	private String address;
	private String[] hobby;
	private Date enrollDate;
	private boolean enabled;	//회원 활성화 여부
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
}
