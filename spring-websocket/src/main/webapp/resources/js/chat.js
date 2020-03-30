//jQuery Load 이후 실행할것!

///////////////////////////// ONLOAD START///////////////////////////// 
$(function() {
	//chat관련 구독신청 : /chat/chatId
	chatSubscribe();
	
	//메세지 전송 관련
	$("#sendBtn").click(function() {
		sendMessage();
	});
	$("#message").keydown(function(key) {
		if (key.keyCode == 13) {// 엔터
			sendMessage();
		}
	});
	
	//채팅로그 최하단 보기
	scrollTop();
	
	//lastCheck 마지막 확인검사용
	//window focus이벤트핸들러 등록
	$(window).on("focus", function() {
		lastCheck();
	});
	
});
///////////////////////////// ONLOAD END/////////////////////////////

///////////////////////////// FUNCTION START/////////////////////////////


/**
 * 지정한 url로 stomp 메세지 전송
 * @returns
 */
function sendMessage() {

	let data = {
		chatId : chatId,
		memberId : memberId,
		msg : $("#message").val(),
		time : Date.now(),
		type: "MESSAGE"
	}
	
	//전역변수 stompClient를 통해 메세지 전송 
	stompClient.send(`/spring-ws/chat/${chatId}`, {}, JSON.stringify(data));

	//message창 초기화
	$('#message').val('');
}


/**
 * 스크롤 처리
 */
function scrollTop(){
	//스크롤처리
 	$('#msg-container').scrollTop($("#msg-container").prop('scrollHeight'));
}


/**
 *
 * 윈도우가 활성화 되었을때, chatroom테이블의 lastcheck(number)컬럼을 갱신한다.
 * 안읽은 메세지 읽음 처리
 * 
 */
function lastCheck() {
	
	let data = {
		chatId : chatId,
		memberId : memberId,
		time : Date.now(),
		type: "LASTCHECK"
	}
	
	//전역변수 stompClient를 통해 lastCheck 메세지 전송
	stompClient.send('/spring-ws/lastCheck', {}, JSON.stringify(data));
}

///////////////////////////// FUNCTION END/////////////////////////////