<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="GymMember등록" name="pageTitle"/>
</jsp:include>
<style>
#form-container{
	text-align: center;
}
#form-container form{
	width: 500px;
	margin: 0 auto;
}
th{
	text-align: right;
}
td{
	text-align: left;
	padding-left: 20px;
}
span.req{
	color: red;
}
label{
	margin-right: 5px;
}
.error{
	color: red;
}
</style>
<div id="form-container">
<form:form modelAttribute="gymMember">
	<table>
		<tr>
			<th>
				<label for="memberName">이름<span class="req">*</span></label>
			</th>
			<td>
				<input id="memberName" name="memberName" type="text" value=""/>
			</td>
		</tr>
		<tr>
			<td colspan="2" style="text-align: center;">
				<input type="submit" value="제출" />
			</td>
		</tr>
	</table>
</form:form>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>