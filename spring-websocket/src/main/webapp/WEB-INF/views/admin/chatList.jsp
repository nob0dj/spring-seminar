<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="채팅방 관리페이지" name="pageTitle"/>
</jsp:include>
<style>
table.table th, table.table td {text-align: center;}
</style>
<table class="table">
  <thead>
    <tr>
      <th scope="col">#</th>
      <th scope="col">회원아이디</th>
      <th scope="col">메세지</th>
      <th scope="col">안읽은 메세지수</th>
    </tr>
  </thead>
  <tbody>
  <c:forEach items="${recentList }" var="m" varStatus="vs">
    <tr chatNo='<c:out value="${m.CHAT_ID}.${m.MEMBER_ID}"/>' /><%-- el의 문자열 더하기 연산대신 jstl out태그 사용 --%>
      <th scope="row">${vs.count}</th>
      <td><a href="javascript:goChat('${m.CHAT_ID}')">${m.MEMBER_ID }</a></td>
      <td>${m.MSG }</td>
      <td><span class="badge badge-light">${m.CNT }</span></td>
    </tr>
  </c:forEach>
  </tbody>
</table>
<script>
$(()=>{
	subscribeByPage();
});

/**
 * 페이지별 구독신청 내역을 처리한다.
 * 사용자가 새 메세지를 작성하거나, 관리자가 메세지를 확인한 경우, 알림을 받는다.
 * 
 */
function subscribeByPage(){
	//페이지별로 구독신청 처리
	let conntionDone = false;
	let intervalId = setInterval(()=>{
		if(conntionDone == true)
			clearInterval(intervalId);
		
		if(conntionDone==false && stompClient.connected){
			
			// subscribe message
	        stompClient.subscribe('/chat/admin/push', function(message) {
	            console.log("receive from /chat/admin/push :", message);
	            //새로운 메세지가 있을때 목록 갱신을 위해서 reload함.
	            location.reload();

	        });
			conntionDone = true;
		}	
	},1000);
}

function goChat(chatId){
	open("${pageContext.request.contextPath}/admin/chat/"+chatId, chatId, "width=500, height=500", false);
}
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>