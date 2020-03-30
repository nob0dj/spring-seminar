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

<%--RedirectAttributues를 이용한 사용자알림메세지 출력 --%>
<c:if test="${not empty msg }">
<script> 
	$(()=>{		
		alert("${msg}");
	});
</script>
</c:if>

<script>
//사용자 구분을 위한 memberId 상수 선언
const memberId = '${memberId}';


//웹소켓 선언 및 연결
//1.최초 웹소켓 생성 url: /stomp
let socket = new SockJS('/spring-ws/stomp');
let stompClient = Stomp.over(socket);

let sessionId;
stompClient.connect({}, function(frame) {
	console.log('connected stomp over sockjs');
	console.log(frame);

	//(미사용)websocket sessionId 값 추출하기
	let url = stompClient.ws._transport.url;
	url = url.replace("ws://"+location.host+"/spring-ws/stomp/","");
	url = url.replace(/^\d+\//,"");
	url = url.replace("/websocket","");
	sessionId = url;

	//2. stomp에서는 구독개념으로 세션을 관리한다. 핸들러 메소드의 @SendTo어노테이션과 상응한다.
	//전체공지
	stompClient.subscribe('/notice', function(message) {
		console.log("receive from subscribe /notice :", message);

		//notice 뱃지 보임 처리
		$("#noticeLink").fadeIn(500);
		//전역변수 notice에 보관
		notice = JSON.parse(message.body);
	});


	//3. 개인공지 구독신청
	stompClient.subscribe('/notice/'+memberId, function(message) {
		console.log("receive from subscribe /notice/"+memberId+" :", message);

		//notice 뱃지 보임 처리
		$("#noticeLink").fadeIn(500);
		//전역변수 notice에 보관
		notice = JSON.parse(message.body);
	});

});

let notice;
function displayNotice(){

	if(notice !== undefined){
		$("#noticeLink").hide();

		let d = new Date(notice.time);
		let dateStr = (d.getMonth()+1)+"/"+d.getDate()+" "+d.getHours()+":"+d.getMinutes();
		let modal = $("#noticeModalCenter");
		modal.modal().find(".modal-body").text(notice.msg);
		modal.find(".modal-title sub").text(dateStr);

		//notice초기화
		notice = undefined;
	}
}
</script>
</head>
<body>
<div id="container">
	<header>
		<div id="header-container">
			<h2>${param.pageTitle}</h2>
		</div>
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<a class="navbar-brand" href="#">
				<img src="${pageContext.request.contextPath }/resources/images/logo-spring.png" alt="" width="50px" />
			</a>
			
			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
		  	</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav mr-auto">
			      <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}">Home</a></li>
				  <!-- 관리자가 아닌 경우 -->
			      <c:if test="${memberLoggedIn==null || \"admin\" ne memberLoggedIn.memberId}">
			      <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/chat">관리자와 채팅하기</a></li>
				  </c:if>
				  <!-- 관리자인 경우 -->
				  <c:if test="${\"admin\" eq memberLoggedIn.memberId}">
				  <!-- 데모메뉴 DropDown변경 -->
				  <!--https://getbootstrap.com/docs/4.1/components/navbar/#supported-content-->
				  <li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					Admin
					</a>
				    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
			      		<button type="button" class="dropdown-item" data-toggle="modal" data-target="#adminNoticeModal" data-send-to="everybody">실시간 공지</button>
			      		<button type="button" class="dropdown-item" onclick="location.href='${pageContext.request.contextPath}/admin/chat/list'">관리자 채팅목록</button>
			      		<button type="button" class="dropdown-item" onclick="simpMessagingTemplateTest();">SimpMessagingTemplate</button>
					</div>
				  </li>
				  </c:if>
			    </ul>
			    
			    <!-- DM 알림 -->
			    <a href="javascript:displayDM();" id="dmLink" style="display:none;" class="badge badge-info">DM</a>

			    <!-- 공지알림 -->
			    <a href="javascript:displayNotice();" id="noticeLink" style="display:none;" class="badge badge-danger">Notice</a>
				&nbsp;
				
				
				
				<!-- 로그인 분기 처리  -->
				<c:if test="${memberLoggedIn==null}">
			        <!-- 로그인,회원가입 버튼 -->
			        <button class="btn btn-outline-success my-2 my-sm-0" type="button" onclick="location.href='${pageContext.request.contextPath}/member/memberLogin.do'">로그인</button>
			        &nbsp;
			        <button class="btn btn-outline-success my-2 my-sm-0" type="button" onclick="alert('회원가입불가!');">회원가입</button>
			    </c:if>
			    <c:if test="${memberLoggedIn!=null}">
			        <span><a href="#">${memberLoggedIn.memberName}</a> 님, 안녕하세요</span>
			        &nbsp;
			        <button class="btn btn-outline-success my-2 my-sm-0" type="button" onclick="location.href='${pageContext.request.contextPath}/member/memberLogout.do'">로그아웃</button>
			    </c:if>    
			</div>
		</nav>
	</header>
	
	<!-- 관리자인 경우 -->
    <c:if test="${\"admin\" eq memberLoggedIn.memberId}">
    <div class="modal fade" id="adminNoticeModal" tabindex="-1" role="dialog" aria-labelledby="#adminNoticeModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="adminNoticeModalLabel">Notice</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	        <form>
	          <div class="form-group">
	            <label for="send-to-name" class="col-form-label">받는이 :</label>
	            <input type="text" class="form-control" id="send-to-name">
	          </div>
	          <div class="form-group">
	            <label for="message-text" class="col-form-label">메세지 :</label>
	            <textarea class="form-control" id="message-text"></textarea>
	          </div>
	        </form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	        <button type="button" class="btn btn-primary" id="adminNoticeSendBtn">전송</button>
	      </div>
	    </div>
	  </div>
	</div>
	<script>
	/**
	 * modal#adminNoticeModal show.bs.modal 이벤트 핸들러
	 */
	$('#adminNoticeModal').on('show.bs.modal', e => {
	  var $button = $(e.relatedTarget) // 모달 호출한 button 태그를 가리킴
	  var sendTo = $button.data('send-to') // data-whatever 속성값 가져오기
	  var modal = $(e.target);
	  modal.find('.modal-body input').val(sendTo);
	  /*
	   * EnterKey EventHandler 
	   * shift+enter는 개행, enter only는 전송!
	   */
	  modal.find('textarea').on('keydown',e => {
		  if(e.keyCode==13 && e.shiftKey==false)
		  	$("#adminNoticeSendBtn").trigger('click');
	  });
	});

	/**
	 * 공지 전송
	 */
	$("#adminNoticeSendBtn").on("click", e => {
	  let data = {
		from: memberId,
		to: $("#send-to-name").val(),
		msg: $("#message-text").val(),
		time: Date.now(),
		type: "NOTICE"
	  } 

	  //#send-to-name 값에 따른 url분기
	  let url = '<c:url value="/admin/notice"/>';
	  if(data.to != "everybody")
	  	url += '/' + $("#send-to-name").val();
	  

	  //전역변수 stompClient를 통해 lastCheck 메세지 전송
	  stompClient.send(url, {}, JSON.stringify(data));

	  //modal 창 닫기 및 폼 초기화
	  $("#adminNoticeModal").modal('hide')
	  						.find("form")[0].reset();
	  
	});

	function simpMessagingTemplateTest(){
		let sendTo = prompt("사용자의 아이디를 입력하세요.");

		$.ajax({
			url: "${pageContext.request.contextPath}/admin/simpMessagingTemplate/"+sendTo,
			success: data => {
				console.log(data);
				alert(data.msg);
			},
			error : (x,s,e) => {
				console.log(x,s,e);
			}
		});
		
	}

	</script>
    </c:if>
    
    
	<!-- 전체/개인공지 확인용 modal -->
	<div class="modal fade" id="noticeModalCenter" tabindex="-1" role="dialog" aria-labelledby="noticeModalCenterTitle" aria-hidden="true">
	  <div class="modal-dialog modal-dialog-centered" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="noticeModalCenterTitle">Notice&nbsp;&nbsp;<sub></sub></h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body"></div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">확인</button>
	      </div>
	    </div>
	  </div>
	</div>  
	
	
	<section id="content">
