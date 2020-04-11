<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="Hello STOMP" name="pageTitle"/>
</jsp:include>
<section id="chat-container">	
	<!-- 메세지 목록 영역 -->
	<div id="msg-container">
		<ul id="data" class="list-group list-group-flush">
		<c:forEach items="${chatList}" var="m">
			<li class="list-group-item">${m.memberId }: ${m.msg }</li>
		</c:forEach>	
		</ul>
	</div>
	<!-- 메세지 작성 영역 -->	
	<div class="input-group mb-3" >
	  <input type="text" class="form-control" id="message" autofocus>
	  <div class="input-group-append" style="padding: 0px;">
		<button class="btn btn-outline-secondary" type="button" id="sendBtn">Send</button>
	  </div>
	</div>
</section>


<!-- 사용자 chat관련 script -->
<script src="${pageContext.request.contextPath }/resources/js/chat.js"></script>
<script type="text/javascript">
const chatId = '${chatId}';

/**
 * 각 페이지에서 작성하면, chat.js의 onload함수에서 호출함.
* chat페이지에서 추가적으로 subscripe 한다.
* 웹소켓 connection이 맺어지기 전 요청을 방지하기 위해 stompClient.connected를 체크한다.
* connectionDone 으로 구독요청 완료를 체크해서 1초마다 반복적으로 구독요청한다.
*/
function chatSubscribe(){
	//페이지별로 구독신청 처리
	let connectionDone = false;
	let intervalId = setInterval(()=>{
		if(connectionDone == true)
			clearInterval(intervalId);
		
		if(connectionDone==false && stompClient.connected){
			
			//stomp에서는 구독개념으로 세션을 관리한다. 핸들러 메소드의 @SendTo어노테이션과 상응한다.
			stompClient.subscribe('/chat/'+chatId, function(message) {
				console.log("receive from subscribe /chat/"+chatId+":", message);
				let messsageBody = JSON.parse(message.body);
				$("#data").append("<li class=\"list-group-item\">"+messsageBody.memberId+" : "+messsageBody.msg+ "</li>");
				scrollTop();
			});
			connectionDone = true;
		}	
	},1000);
}

</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
