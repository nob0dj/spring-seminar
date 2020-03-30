<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${param.pageTitle}</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>

<!-- bootstrap js: jquery load 이후에 작성할것.-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>

<!-- bootstrap css -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">

<!-- 사용자작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/style.css" />

<!-- WebSocket:sock.js CDN -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.3.0/sockjs.js"></script>

<!-- WebSocket: stomp.js CDN -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.js"></script>


</head>
<body>
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
<script>
const memberId = '${memberId}';
const chatId = '${chatId}';

//웹소켓 선언 및 연결
//1.최초 웹소켓 생성 url: /stomp
let socket = new SockJS('<c:url value="/stomp"/>');
let stompClient = Stomp.over(socket);

stompClient.connect({}, function(frame) {
	console.log('connected stomp over sockjs');
	//사용자 확인
	lastCheck(chatId, memberId);
	
});

/**
 * 각 페이지에서 작성하면, chat.js의 onload함수에서 호출함.
* chat페이지에서 추가적으로 subscripe 한다.
* 웹소켓 connection이 맺어지기 전 요청을 방지하기 위해 stompClient.connected를 체크한다.
* conntionDone 으로 구독요청 완료를 체크해서 1초마다 반복적으로 구독요청한다.
*/
function chatSubscribe(){
	//페이지별로 구독신청 처리
	let conntionDone = false;
	let intervalId = setInterval(()=>{
		if(conntionDone == true)
			clearInterval(intervalId);
		
		if(conntionDone==false && stompClient.connected){
			
			//stomp에서는 구독개념으로 세션을 관리한다. 핸들러 메소드의 @SendTo어노테이션과 상응한다.
			stompClient.subscribe('/chat/'+chatId, function(message) {
				console.log("receive from subscribe /chat/"+chatId+":", message);
				let messsageBody = JSON.parse(message.body);
				$("#data").append("<li class=\"list-group-item\">"+messsageBody.memberId+" : "+messsageBody.msg+ "</li>");
				scrollTop();
			});
			conntionDone = true;
		}	
	},1000);
}


</script>
</body>
</html>