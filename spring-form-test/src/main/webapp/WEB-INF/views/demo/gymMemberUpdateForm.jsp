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
<%-- <form:form></form:form> --%>
<form:form modelAttribute="gymMember" action="${pageContext.request.contextPath }/demo/gymMemberUpdate.do" method="post">
	<form:hidden path="memberCode"/>
	<table>
		<tr>
			<th>
				<form:label path="memberName">이름<span class="req">*</span></form:label>
			</th>
			<td>
				<form:input path="memberName"/>
				<form:errors path="memberName" cssClass="error"/>
			</td>
		</tr>
		<tr>
			<th>
				<form:label path="phone">전화번호<span class="req">*</span></form:label>
			</th>
			<td>
				<form:input path="phone"/>
				<form:errors path="phone" cssClass="error"/>
			</td>
		</tr>
		<tr>
			<th>
				<form:label path="height">키(cm)</form:label>
			</th>
			<td>
				<form:input path="height"/>
			</td>
		</tr>
		<tr>
			<th>
				<form:label path="weight">몸무게(kg)</form:label>
			</th>
			<td>
				<form:input path="weight"/>
			</td>
		</tr>
		<tr>
			<th>성별</th>
			<td>
				<form:radiobutton path="gender" value="${gender[0]}"/>
				<form:label path="gender" for="gender1">남</form:label>
				<form:radiobutton path="gender" value="${gender[1]}"/>
				<form:label path="gender" for="gender2">여</form:label>
			</td>
		</tr>
		<tr>
			<th>
				<form:label path="joinPath">가입경로</form:label>
			</th>
			<td>
				<form:radiobuttons path="joinPath" items="${joinPath }" cssClass="chk"/>
			</td>
		</tr>
		<tr>
			<th>
				<form:label path="wannaPT">PT신청</form:label>
			</th>
			<td>
				<form:checkbox path="wannaPT"/>
			</td>
		</tr>
		<tr>
			<th>
				<form:label path="interest">관심운동</form:label>
			</th>
			<td>
				<form:checkboxes path="interest" items="${interestList }" cssClass="chk"/>
			</td>
		</tr>
		<tr>
			<th>
				<form:label path="gymInstructor">PT선생님</form:label>
			</th>
			<td>
				<form:radiobuttons path="gymInstructor" items="${gymInstructorList}"  itemLabel="name" itemValue="code" cssClass="chk"/>
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