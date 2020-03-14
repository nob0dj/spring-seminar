<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!-- header.jsp로 전달하는 헤더텍스트 한글 깨짐 대비 -->
<fmt:requestEncoding value="UTF-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="Hello Springframework" name="pageTitle"/>
</jsp:include>

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
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>