package com.kh.spring;

import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * springboot에서 welcome-file은 web.xml이 아닌 @Configuration을 통해 처리함.
 * 
 * 
 * @author nobodj
 *
 */
@Configuration
//public class WelcomeFileConfigurator extends WebMvcConfigurerAdapter{
public class WelcomeFileConfigurator implements WebMvcConfigurer{
 
    @Override
    public void addViewControllers(ViewControllerRegistry registry ) {
    	//사용자가 / 요청시  자동으로 /index.jsp으로 포워딩해서 처리하도록한다.
        registry.addViewController( "/" ).setViewName( "forward:/index.jsp" );
        registry.setOrder( Ordered.HIGHEST_PRECEDENCE );
    }
}


