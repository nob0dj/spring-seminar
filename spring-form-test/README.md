# Spring-form & Validation
[https://docs.spring.io/spring/docs/4.2.x/spring-framework-reference/html/spring-form-tld.html](https://docs.spring.io/spring/docs/4.2.x/spring-framework-reference/html/spring-form-tld.html)


[https://www.baeldung.com/spring-mvc-form-tags](https://www.baeldung.com/spring-mvc-form-tags)


## 준비
spring-form-test 프로젝트 배포
* [https://github.com/nob0dj/spring-seminar.git](https://github.com/nob0dj/spring-seminar.git)에서 다운로드
* import - Existing Maven Project로 workspace에 추가
* sts에 lombok.jar 설치[eclipse(STS)에 lombok(롬복) 설치](https://countryxide.tistory.com/16)할 것.
* 2.1.3 springboot version 
* jsp사용을 위한 의존라이브러리 javax.servlet.jstl, tomcat-embed-jasper 추가, application.yml view관련 설정추가

@pom.xml

    <!-- #1. view:jsp를 이용하기 위한 dependency -->
    <!-- spring-boot-starter-web도 필요함. -->
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>jstl</artifactId>
    </dependency>
    <dependency>
        <groupId>org.apache.tomcat.embed</groupId>
        <artifactId>tomcat-embed-jasper</artifactId>
        <scope>provided</scope>
    </dependency>

@src/main/resources/application.yml

    #port
    server:
    port: 10090
    
    #contextpath
    servlet:
        context-path: /springboot 
        
    #view:jsp
    spring:
    mvc:
        view:
        prefix: /WEB-INF/views/ 
        suffix: .jsp

    #logging
    logging:
    level:
        com.kh.spring: DEBUG
        
* welcome-file을 사용하기 위한 설정클래스를 추가함.

@com.kh.spring.WelcomFileConfigurator
springboot에서 welcome-file은 web.xml이 아닌 @Configuration을 통해 처리함.
 
    @Configuration
    public class WelcomeFileConfigurator extends WebMvcConfigurerAdapter{
     
        @Override
        public void addViewControllers(ViewControllerRegistry registry ) {
        	//사용자가 / 요청시  자동으로 /index.jsp으로 포워딩해서 처리하도록한다.
            registry.addViewController( "/" ).setViewName( "forward:/index.jsp" );
            registry.setOrder( Ordered.HIGHEST_PRECEDENCE );
        }
    }







## spring-form 기본 테스트
spring-webmvc의존 라이브러리를 추가했다면, spring-form태그를 사용할 수 있다.
아래 의존을 pom.xml에 추가했다면(springboot 의존 키워드 web선택), 부모 pom.xml에서 spring-webmvc의존이 자동 추가된다.

@pom.xml

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>


@/WEB-INF/views/demo/gymMemberForm.jsp
지시어 directive 태그 추가

    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

    ...

    <div id="form-container">
        <form:form></form:form>
    </div>


결과확인

    <form id="command" action="/springboot/demo/gymMemberForm.do" method="post"></form>




@com.kh.spring.demo.controller.DemoController

    /**
	 * 
	 * 폼에서 사용할 값을 vo객체(@ModelAttribute)에 등록해둔다.
	 * 
	 * @param gymMember
	 * @param model
	 */
	@GetMapping("/gymMemberForm.do")
	public void gymMemberForm(@ModelAttribute("gymMember") GymMember gymMember, Model model) {
		
		//1.성별 radiobutton
		String[] gender = {"M","F"};
		
		//2.가입경로 radiobuttons
		String[] joinPath = {"인터넷광고", "전단지광고", "지인소개", "기타"};
		
		//3.관심운동: checkboxes
		List<String> interestList = new ArrayList<String>();
		interestList.add("Pilates");
		interestList.add("Yoga");
		interestList.add("Spinning");
		interestList.add("Jazz Dance");
		interestList.add("Swing");
		
		//4.pt샘: label과 checkbox:value가 다른 경우
		List<GymInstructor> gymInstructorList = new ArrayList<GymInstructor>();
		gymInstructorList.add(new GymInstructor("honggd", "홍길동"));
		gymInstructorList.add(new GymInstructor("sinsa", "신사임당"));
		gymInstructorList.add(new GymInstructor("leess", "리순신"));	
		
		model.addAttribute("gender", gender);
		model.addAttribute("joinPath", joinPath);
		model.addAttribute("interestList", interestList);
		model.addAttribute("gymInstructorList", gymInstructorList);
		
	}

@com.kh.spring.demo.model.vo.GymMember
**기본형이 아닌 참조형으로 필드를 구성한다.**
빈 vo객체처리시 spring-form이 null을 대입하게 되는데, 기본형은 이를 처리할 수 없다.
기본형은 wrapper-class로 처리한다.
    
    /**
    * 빈 vo객체처리시 spring-form이 null을 대입하게 되는데, 기본형은 이를 처리할 수 없다.
    * 기본형은 wrapper-class로 처리한다.
    * 
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


@com.kh.spring.demo.model.vo.GymInstructor

    @Data
    @AllArgsConstructor
    public class GymInstructor {
        private String code;
        private String name;
    }



@/WEB-INF/views/demo/gymMemberForm.jsp
* modelAttribute: 사용할 vo객체. model에서 참조.
* path: vo객체의 field명
* cssClass: 클래스값 지정시 사용(복수개 사용가능). class속성 사용시, cssClass값으로 덮어씌워지므로 주의할것.
* cssStyle: style속성을 직접 기술할 경우 사용.
  
`<form:input>`은 기본적으로 `type=text`임. 그외는 type지정을 직접하면 된다.


    <form:form modelAttribute="gymMember">
        <table>
            <tr>
                <th>
                    <form:label path="memberName">이름<span class="req">*</span></form:label>
                </th>
                <td>
                    <form:input path="memberName"/>
                </td>
            </tr>
            <tr>
                <th>
                    <form:label path="phone">전화번호<span class="req">*</span></form:label>
                </th>
                <td>
                    <form:input path="phone"/>
                </td>
            </tr>
            <tr>
                <th>
                    <form:label path="height">키(cm)</form:label>
                </th>
                <td>
                    <form:input path="height"/>
                </td>
            </tr>
            <tr>
                <th>
                    <form:label path="weight">몸무게(kg)</form:label>
                </th>
                <td>
                    <form:input path="weight"/>
                </td>
            </tr>
        </form>

radiobutton
* 하나의 radio를 표현함. 

        <tr>
            <th>성별</th>
            <td>
                <form:radiobutton path="gender" value="${gender[0]}"/>
                <form:label path="gender" for="gender1">남</form:label>
                <form:radiobutton path="gender" value="${gender[1]}"/>
                <form:label path="gender" for="gender2">여</form:label>
            </td>
        </tr>

radiobuttons
* items속성으로 전달된 반복가능한 객체를 여러개의 radio로 표현.

        <tr>
            <th>
                <form:label path="joinPath">가입경로</form:label>
            </th>
            <td>
                <form:radiobuttons path="joinPath" items="${joinPath }" cssClass="chk"/>
            </td>
        </tr>

checkbox
* 하나의 체크박스(단순 value없고, on그대로 사용하는 경우)를 표현

        <tr>
            <th>
                <form:label path="wannaPT">PT신청</form:label>
            </th>
            <td>
                <form:checkbox path="wannaPT"/>
            </td>
        </tr>

checkboxes
사용자에게 보여질 값과 내부적으로 처리될 값이 다른 경우
* items속성으로 전달된 반복가능한 객체를 여러개의 checkbox로 표현.
* itemLabel: 사용자에게 보여질 값
* itemValue: 내부적으로 처리될 값

        <tr>
            <th>
                <form:label path="gymInstructor">PT선생님</form:label>
            </th>
            <td>
                <form:checkboxes path="gymInstructor" items="${gymInstructorList}"  itemLabel="name" itemValue="code" cssClass="chk"/>
            </td>
        </tr>




## 사용자 데이터 기록하기
임의의 사용자 데이터를 폼에 기록하기.


@com.kh.spring.demo.controller.DemoController

    /**
	 * 폼에서 사용할 값을 vo객체(@ModelAttribute)에 등록해둔다.
	 * 
	 * @param gymMember
	 * @param model
	 */
	@GetMapping("/gymMemberUpdateForm.do")
	public void gymMemberUpdateForm(@ModelAttribute("gymMember") GymMember gymMember) {
		
		//vo 사용자정보 표시하기
		gymMember.setMemberName("안중근");
		gymMember.setHeight(188.8);
		gymMember.setWeight(80.0);
		gymMember.setPhone("01012341234");
		gymMember.setGender("M");
		gymMember.setJoinPath("지인소개");
		//pt신청여부: checkbox(checked처리하기)
		gymMember.setWannaPT(true);
		//Yoga, Swing을 checked처리하기
		gymMember.setInterest(new String[] {"Yoga", "Swing"});
		//leess를 checked처리하기
		gymMember.setGymInstructor(new GymInstructor("leess", "리순신"));
		
	}

기존 form작성관련 속성을 공유하기위하여 별도의 @ModelAttribute메소드를 생성함.

    
	/**
	 * DemoController의 모든 요청에서 model속성으로 참조할 수 있도록 @ModelAttribute로 선언함.
	 * 
	 * @param model
	 */
	@ModelAttribute
	public void common(Model model){
		//1.성별 radiobutton
		String[] gender = {"M","F"};
		
		//2.가입경로 radiobuttons
		String[] joinPath = {"인터넷광고", "전단지광고", "지인소개", "기타"};
		
		//3.관심운동: checkboxes
		List<String> interestList = new ArrayList<String>();
		interestList.add("Pilates");
		interestList.add("Yoga");
		interestList.add("Spinning");
		interestList.add("Jazz Dance");
		interestList.add("Swing");
		
		//4.pt샘: label과 checkbox:value가 다른 경우
		List<GymInstructor> gymInstructorList = new ArrayList<GymInstructor>();
		gymInstructorList.add(new GymInstructor("honggd", "홍길동"));
		gymInstructorList.add(new GymInstructor("sinsa", "신사임당"));
		gymInstructorList.add(new GymInstructor("leess", "리순신"));	
		
		model.addAttribute("gender", gender);
		model.addAttribute("joinPath", joinPath);
		model.addAttribute("interestList", interestList);
		model.addAttribute("gymInstructorList", gymInstructorList);
		
	}


@/WEB-INF/views/demo/gymMemberUpdateForm.jsp
기존 gymMemberForm.jsp와 동일하므로 복사 붙여넣기 후 파일명 변경할 것.

    <div id="form-container">
        <form:form modelAttribute="gymMember" action="${pageContext.request.contextPath }/demo/gymMemberUpdate.do" method="post">
            <table>
                <tr>
                    <th>
                        <form:label path="memberName">이름<span class="req">*</span></form:label>
                    </th>
                    <td>
                        <form:input path="memberName"/>
                        <form:errors path="memberName" cssClass="error"/>
                    </td>
                </tr>
                <tr>
                    <th>
                        <form:label path="phone">전화번호<span class="req">*</span></form:label>
                    </th>
                    <td>
                        <form:input path="phone"/>
                        <form:errors path="phone" cssClass="error"/>
                    </td>
                </tr>
                <tr>
                    <th>
                        <form:label path="height">키(cm)</form:label>
                    </th>
                    <td>
                        <form:input path="height"/>
                    </td>
                </tr>
                <tr>
                    <th>
                        <form:label path="weight">몸무게(kg)</form:label>
                    </th>
                    <td>
                        <form:input path="weight"/>
                    </td>
                </tr>
                <tr>
                    <th>성별</th>
                    <td>
                        <form:radiobutton path="gender" value="${gender[0]}"/>
                        <form:label path="gender" for="gender1">남</form:label>
                        <form:radiobutton path="gender" value="${gender[1]}"/>
                        <form:label path="gender" for="gender2">여</form:label>
                    </td>
                </tr>
                <tr>
                    <th>
                        <form:label path="joinPath">가입경로</form:label>
                    </th>
                    <td>
                        <form:radiobuttons path="joinPath" items="${joinPath }" cssClass="chk"/>
                    </td>
                </tr>
                <tr>
                    <th>
                        <form:label path="wannaPT">PT신청</form:label>
                    </th>
                    <td>
                        <form:checkbox path="wannaPT"/>
                    </td>
                </tr>
                <tr>
                    <th>
                        <form:label path="interest">관심운동</form:label>
                    </th>
                    <td>
                        <form:checkboxes path="interest" items="${interestList }" cssClass="chk"/>
                    </td>
                </tr>
                <tr>
                    <th>
                        <form:label path="gymInstructor">PT선생님</form:label>
                    </th>
                    <td>
                        <form:radiobuttons path="gymInstructor" items="${gymInstructorList}"  itemLabel="name" itemValue="code" cssClass="chk"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center;">
                        <input type="submit" value="제출" />
                    </td>
                </tr>
            </table>
        </form:form>
    </div>





## 유효성검사 및 error
클라이언트단 유효성 검사는 생략하고, 폼을 제출하여, 서버단 유효성 검사를 진행한다.


@pom.xml
org.hibernate.hibernate-validator 나 javax.validation.validation-api 택일하여 의존라이브러리 추가

    <!-- #2. 커맨드객체 유효성검사 @Valid-->
    <!-- <dependency>
        <groupId>org.hibernate</groupId>
        <artifactId>hibernate-validator</artifactId>
        <version>5.3.1.Final</version>
    </dependency> -->
    <dependency>
        <groupId>javax.validation</groupId>
        <artifactId>validation-api</artifactId>
        <version>2.0.1.Final</version>
    </dependency>


@com.kh.spring.SpringFormConfigurator
validator구현클라스에서 필드별 에러코드에 해당하는 message를 바인딩 해주기 위한 빈 등록
    
    @Configuration
    public class SpringFormConfigurator {

        @Bean
        public MessageSource messageSource() {
            ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
            messageSource.setBasenames("messages");
            return messageSource;
        }
    }

xml에 선언적 방식으로 빈을 등록할경우는 다음 코드 사용할 것.

    <bean class="org.springframework.context.support.ResourceBundleMessageSource" id="messageSource">
        <property name="basename" value="messages" />
    </bean>

@com.kh.spring.demo.model.validator.GymMemberValidator
* supports(): command객체가 현재 등록된 GymMember타입이거나 후손클래스인지 검사하여 boolean을 리턴함.    

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
            }

        }

@src/main/resources/messages.properties
프로퍼티파일 특성상 한글은 모두 unicode문자로 변환되어 저장된다. mouse hover하면 원래 글자 확인 가능.
* required.memberName=회원명을 입력하세요.
* requiered.phone=전화번호를 입력하세요.


        #messages.properties
        required.memberName=\uD68C\uC6D0\uBA85\uC744 \uC785\uB825\uD558\uC138\uC694.
        required.phone=\uC804\uD654\uBC88\uD638\uB97C \uC785\uB825\uD574\uC8FC\uC138\uC694.



@com.kh.spring.demo.controller.DemoController
validator구현클래스 등록

    /**
	 * @InitBinder
	 * WebDataBinder(사용자 요청을 자바빈으로 바인딩함)객체 초기화 목적의 어노테이션
	 */
	@InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.setValidator(new GymMemberValidator());
    }

`@Valid` 어노테이션을 사용하면, 스프링컨테이너가 유효성검사 진행후, 결과를 `BindingResult result` 파라미터에 담아준다. 
이를 체크 `result.hasErrors()`하여 분기 처리함.


    @PostMapping("/gymMemberInsert.do")
	public String gymMemberInsert(@Valid GymMember gymMember, BindingResult result) {
		logger.debug("회원 등록 요청!");
		logger.debug("gymMember={}",gymMember);
		
		if(result.hasErrors()) {
			return "demo/gymMemberForm";//forward방식 지정.
		}
		
		logger.debug("회원 등록 성공!");
		return "redirect:/demo/gymMemberForm.do";//redirect방식 지정
	}

