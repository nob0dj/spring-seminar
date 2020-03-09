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
<script src="${pageContext.request.contextPath }/resources/js/jquery-3.2.1.min.js"></script>
<!-- 부트스트랩관련 라이브러리 -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>
<!-- 사용자작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/style.css" />
</head>
<body>
<div id="container">
	<header>
		<div id="header-container">
			<h2>${param.pageTitle}</h2>
		</div>
		<!-- https://getbootstrap.com/docs/4.0/components/navbar/ -->
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<a class="navbar-brand" href="#">
				<img src="${pageContext.request.contextPath }/resources/images/logo-spring.png" alt="스프링로고" width="50px" />
			</a>
		  	<!-- 반응형으로 width 줄어들경우, collapse버튼관련 -->
			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
		  	</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav mr-auto">
			      <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}">Home</a></li>
			      <li class="nav-item">
			      	<a class="nav-link" href="https://github.com/nob0dj/spring-seminar/tree/master/spring-form-test" title="github소스보기">
			      		<img src="https://d.pr/i/ngKs9j+" width="16" alt="github이미지" />
			      	</a>
			      </li>		
			      <!-- 데모메뉴 DropDown변경 -->
				  <!--https://getbootstrap.com/docs/4.1/components/navbar/#supported-content-->
				  <li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					 Demo
					</a>
				    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
						<a class="dropdown-item" href="${pageContext.request.contextPath}/demo/gymMemberForm.do">GymMember 등록</a>
						<a class="dropdown-item" href="${pageContext.request.contextPath}/demo/gymMemberUpdateForm.do">GymMember 수정</a>
					</div>
				  </li>
			    </ul>
			 </div>
		</nav>
	</header>
	<section id="content">