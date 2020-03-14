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
<style>
.form-container {
	padding-left: 10px;
	padding-right: 10px;
}
.redirect-form {
	display: inline-block;
	width: 45%;
}
</style>
<div class="form-container">
  <div class="redirect-form">
	<form action="dml1" method="post">
	  <fieldset>
	    <legend>DML1 폼</legend>
		  <div class="form-group">
		    <label for="exampleInputEmail1">Email address</label>
		    <input type="email" class="form-control" name="email" placeholder="Enter email">
		  </div>
		  <button type="submit" class="btn btn-primary">Submit</button>
	  </fieldset>
	</form>
  </div>
  <div class="redirect-form">
	<form action="dml2" method="post">
	  <fieldset>
	    <legend>DML2 폼</legend>
		  <div class="form-group">
		    <label for="exampleInputEmail1">Email address</label>
		    <input type="email" class="form-control" name="email" placeholder="Enter email">
		  </div>
		  <button type="submit" class="btn btn-primary">Submit</button>
	  </fieldset>
	</form>
  </div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>