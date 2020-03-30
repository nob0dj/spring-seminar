package com.kh.spring.stomp.conf;

import java.util.Map;
import java.util.Optional;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.server.support.DefaultHandshakeHandler;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

import com.kh.spring.member.model.vo.Member;

@Configuration
@EnableWebSocketMessageBroker
//public class StompConfigurer extends AbstractWebSocketMessageBrokerConfigurer{//deprecated
public class StompConfigurer implements WebSocketMessageBrokerConfigurer {
	
	@Autowired
	private ServletContext servletContext;//contextPath를 가져오기용.
	
	/**
	 * stomp로 접속한 경우의 connectEndPoint설정: client단의 `Stomp.over(socket)`에 대응함.
	 * 
	 * 내부적으로 SockJS를 통해, websocket, xhr-streaming, xhr-polling 중에 가장 적합한 transport를 찾음.
	 */
	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		registry.addEndpoint("/stomp")
				.withSockJS()
				.setInterceptors(new HttpSessionHandshakeInterceptor());//HttpSession에 접근하기 위한 인터셉터 지정 
	}
		

	
	/**
	 * message-
	 */
	@Override
	public void configureMessageBroker(MessageBrokerRegistry registry) {
		//핸들러메소드의 @SendTo 에 대응함. 여기서 등록된 url을 subscribe하는 client에게 전송.
		registry.enableSimpleBroker("/notice", "/chat", "/lastCheck");
		
		//prefix로 contextPath를 달고 @Controller의 핸들러메소드@MessageMapping 를 찾는다.
		registry.setApplicationDestinationPrefixes(servletContext.getContextPath());//contextPath
	}
	
}
