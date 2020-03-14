# RedirectAttributes 사용하기

> Handler에서 DML요청을 처리한 뒤에는 redirect를 통해 사용자 url을 변경해야한다.  새로고침, 또는 뒤로가기시 중복 submit을 방지하기 위함이다. 
redirect시 특정 데이터를 같이 전달하고 싶은 경우, RedirectAttributes를 사용할 수 있다.

[](https://github.com/nob0dj/spring-seminar/tree/master/redirectattributes-test)

# 준비

springboot project 생성 : `lombok` , `spring web` , `spring boot devtools` 키워드 선택

[](https://start.spring.io/starter.zip?name=spring-redirectattributes-test&groupId=com.kh&artifactId=spring-redirectattributes-test&version=0.0.1-SNAPSHOT&description=Demo+project+for+Spring+Boot&packageName=com.kh.spring&type=maven-project&packaging=jar&javaVersion=1.8&language=java&bootVersion=2.1.3.RELEASE&dependencies=devtools&dependencies=lombok&dependencies=web)

## project setup

jsp 관련 추가 설정 있음.

    <!-- @pom.xml --> 
    
    <!-- #1. view:jsp를 이용하기 위한 dependency 추가-->
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>jstl</artifactId>
    </dependency>
    <dependency>
        <groupId>org.apache.tomcat.embed</groupId>
        <artifactId>tomcat-embed-jasper</artifactId>
        <scope>provided</scope>
    </dependency>

    # @src/main/resources/application.yml
    
    #port
    server:
      port: 10090
      
    #contextpath
      servlet:
        context-path: /spring 
    
    #1.1 jsp configuration
    spring:
      mvc:
        view:
          prefix: /WEB-INF/views/
          suffix: .jsp
    
    #logging
    logging:
      level:
        com.kh.spring: DEBUG

`src/main/webapp` 폴더 이하에 view단 folder/file 세팅

    src/main/webapp/
    					resources/
    						css/
    							style.css
    						images/
    							logo-spring.png
    					WEB-INF/
    						views/
    							common/
    								header.jsp
    								footer.jsp
    							redirect/
    					index.jsp

index.jsp를 welcome-file로 처리하기 위한 class추가

    // @com.kh.spring.WelcomeFileconfigurator
    
    import org.springframework.context.annotation.Configuration;
    import org.springframework.core.Ordered;
    import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
    import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
    
    /**
     * springboot에서 welcome-file은 web.xml이 아닌 @Configuration을 통해 처리함.
     * 
     * WebMvcConfigurerAdapter 클래스 상속은  deprecated!
     * 
     */
    @Configuration
    //public class WelcomeFileConfigurator {
    public class WelcomeFileConfigurator implements WebMvcConfigurer{
     
        @Override
        public void addViewControllers(ViewControllerRegistry registry ) {
    	    	//사용자가 / 요청시  자동으로 /index.jsp으로 포워딩해서 처리하도록한다.
            registry.addViewController( "/" ).setViewName( "forward:/index.jsp" );
            registry.setOrder( Ordered.HIGHEST_PRECEDENCE );
        }
    }

## @Test

[http://localhost:10090/spring](http://localhost:10090/spring) 브라우져 연결 테스트

## form페이지

    // @com.kh.spring.redirect.controller.RedirectController
    
    @Controller
    @RequestMapping("redirect")
    @Slf4j
    public class RedirectController {
    
    	@GetMapping("/form")
    	public void form() {
    		log.debug("form 페이지 요청");
    	}
    }

    <!-- @/WEB-INF/views/redirect/form.jsp -->
    
    <style>
    .form-container {
    	padding-left: 10px;
    	padding-right: 10px;
    }
    .redirect-form {
    	display: inline-block;
    	width: 45%;
    }
    </style>
    <div class="form-container">
      <div class="redirect-form">
    	<form action="dml1" method="post">
    	  <fieldset>
    	    <legend>DML1 폼</legend>
    		  <div class="form-group">
    		    <label for="exampleInputEmail1">Email address</label>
    		    <input type="email" class="form-control" name="email" placeholder="Enter email">
    		  </div>
    		  <button type="submit" class="btn btn-primary">Submit</button>
    	  </fieldset>
    	</form>
      </div>
      <div class="redirect-form">
    	<form action="dml2" method="post">
    	  <fieldset>
    	    <legend>DML2 폼</legend>
    		  <div class="form-group">
    		    <label for="exampleInputEmail1">Email address</label>
    		    <input type="email" class="form-control" name="email" placeholder="Enter email">
    		  </div>
    		  <button type="submit" class="btn btn-primary">Submit</button>
    	  </fieldset>
    	</form>
      </div>
    </div>

# DML요청1

`redirect:` 접두어를 사용해 redirect처리함.

1. `redirectAttributes.addAttribute`  redirect url에 paramter로 추가됨.
2. `redirectAttributes.addFlashAttribute` redirect 시 이용할 수 있도록 session에 추가됨.
```
// @com.kh.spring.redirect.controller.RedirectController

@PostMapping("/dml1")
  public String dml1(@RequestParam("email") String email, Model model, RedirectAttributes redirectAttributes) {
    
    log.debug("email={}",email);
    redirectAttributes.addAttribute("param", "helloworld");
    redirectAttributes.addFlashAttribute("email", email);
    redirectAttributes.addFlashAttribute("msg", "당신의 이메일이 성공적으로 등록되었습니다.");
    
    return "redirect:/redirect/result";
  }
```

redirect url의 파라미터 확인하기

    <!-- @/WEB-INF/views/redirect/result.jsp -->
    
    <div class="card">
      <div class="card-header">
    	<h1>Form 요청 결과 페이지</h1>
      </div>
      <div class="card-body">
        <h5 class="card-title">${email }</h5>
        <p class="card-text">${msg }</p>
        <a href="${pageContext.request.contextPath }" class="btn btn-primary">인덱스페이지 돌아가기</a>
      </div>
    </div>

![https://d.pr/i/AWAhAJ+](https://d.pr/i/AWAhAJ+)

# DML요청2

RedirectView를 이용해서 처리함.

RedirectView의 url 은 context-path를 포함하지 않으므로 context-path부터 작성할 것

    @PostMapping("/dml2")
    	public RedirectView dml2(@RequestParam("email") String email, Model model, RedirectAttributes redirectAttributes) {
    		log.debug("email={}",email);
    		redirectAttributes.addAttribute("param", "helloworld");
    		redirectAttributes.addFlashAttribute("email", email);
    		redirectAttributes.addFlashAttribute("msg", "당신의 이메일이 성공적으로 등록되었습니다.");
    		
    		return new RedirectView("/spring/");
    	}

    <!-- @/WEB-INF/views/common/header.jsp -->
    
    <%--RedirectAttributues를 이용한 사용자알림메세지 출력 --%>
    <c:if test="${not empty msg }">
    <script> 
    	$(()=>{		
    		alert("${msg}");
    	});
    </script>
    </c:if>

![https://d.pr/i/DFbynD+](https://d.pr/i/DFbynD+)

# #isuues

## index페이지로 redirect할 경우, flashAttribute 사용못하는 문제

springboot프로젝트에서는 index.jsp가 forwarding방식으로 처리되므로 문제가 되지 않지만, legacy project에서 welcome-file로 index.jsp를 가게 되면 session에 저장된 flashAttributes 에 대한 처리가 누락되게 된다.

### 해결법

1. welcome-file을 통해 index.jsp 로 처리되지 않고,  fowarding방식으로 처리되도록 한다. welcome-file은  `@RequestMapping`보다 우선순위가 높으므로 주석 처리함
    1. `/WEB-INF/web.xml` 에 welcome-file-list 주석처리
    2. 서버디렉토리(catalina.home)의 `config/web.xml` 의 welcome-file-list 주석처리
2. `@RequestMapping` 생성

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String home() {
    	return "forward:/index.jsp";
    }

# See Also

[A Guide To Spring Redirects | Baeldung](https://www.baeldung.com/spring-redirect-and-forward)

[Spring MVC - RedirectAttributes Example](https://www.logicbig.com/tutorials/spring-framework/spring-web-mvc/redirect-attributes.html)