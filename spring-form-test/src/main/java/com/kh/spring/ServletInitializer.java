package com.kh.spring;

import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * war배포를 위해 SpringBootSerletInitializer를 상속한 클래스를 생성함
 * 
 * <br>
 * <a href="https://hue9010.github.io/spring/springboot-war/">JAR -> WAR로 배포파일 변경하기</a>
 */
public class ServletInitializer extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(SpringFormTestApplication.class);
    }

}