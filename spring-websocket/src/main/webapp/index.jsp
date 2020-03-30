<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="Hello Spring WebSocket" name="pageTitle"/>
</jsp:include>

<img src="${pageContext.request.contextPath }/resources/images/logo-spring.png" id="center-image" alt="" />

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
