<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="${test }" name="pageTitle"/>
</jsp:include>
<style>
div#menu-container{text-align:center;}
div.menu-test{width:50%; margin:0 auto; text-align:center;}
div.result{width:70%; margin:0 auto;}
</style>
<script>
function displayResultTable(data){
	var html = "<table class=table>";
    html+="<tr><th>메뉴번호</th><th>음식점</th><th>메뉴</th><th>가격</th><th>맛</th></tr>";
    for(var i in data){
        html += "<tr><td>"+data[i].id+"</td>";
        html += "<td>"+data[i].restaurant+"</td>";
        html += "<td>"+data[i].name+"</td>";
        html += "<td>"+data[i].price+"</td>";
        html += "<td>"+data[i].taste+"</td></tr>";
    }
    html+="</table>";
	return html;
}

</script>
<div id="menu-container">
	<!-- 1.GET menus-->
	<div class="menu-test">
		<h4>전체메뉴조회(GET)</h4>
		<input type="button" class="btn btn-block btn-outline-success btn-send" id="btn-menus" value="전송" />
	</div>
	<div class="result" id="menus-result"></div>
	<script>
	$(function(){
		$("#btn-menus").on("click",function(){
			$.ajax({
	            url  : "${pageContext.request.contextPath}/menus",
	            dataType: "json",
	            type : "GET",
	            success : function(data){
	                console.log(data);
	                let html = displayResultTable(data);
	                $("#menus-result").html(html);
	            },
	            error : function(jqxhr, textStatus, errorThrown){
	                console.log("ajax 처리 실패 : ",jqxhr,textStatus,errorThrown);
	            }

	        });
		});
	});
	</script>
	
	<!-- 2.GET menu/kr 타입별 조회 -->
	<div class="menu-test">
		<h4>메뉴 타입별 조회(GET)</h4>
		<select class="form-control" id="typeSelector">
		  <option value="" disabled selected>음식타입선택</option>
	      <option value="kr">한식</option>
	      <option value="ch">중식</option>
	      <option value="jp">일식</option>
	    </select>
	</div>
	<div class="result" id="type-result"></div>
	
	<script>
	$(function(){
		$("#typeSelector").on("change",function(){
			var type = $(this).val();
			//var type = $("option:selected",this).val();
			console.log(type);

			$.ajax({
	            url  : "${pageContext.request.contextPath}/menus/"+type,
	            dataType: "json",
	            type : "get",
	            success : function(data){
	                console.log(data);
	                let html = displayResultTable(data);
	                $("#type-result").html(html);
	                
	            },
	            error : function(jqxhr, textStatus, errorThrown){
	                console.log("ajax 처리 실패 : ",jqxhr,textStatus,errorThrown);
	            }

	        });
		});
	});
	</script>

	<!-- 3.GET menus/type/taste -->
	<div class="menu-test">
		<h4>메뉴 타입/맛별 조회(GET)</h4>
		<form id="menuTypeTasteFrm">
			<div class="form-check form-check-inline">
				<input type="radio" class="form-check-input" name="type" id="get-no-type" value="all" checked>
				<label for="get-no-type" class="form-check-label">모두</label>&nbsp;
				<input type="radio" class="form-check-input" name="type" id="get-kr" value="kr">
				<label for="get-kr" class="form-check-label">한식</label>&nbsp;
				<input type="radio" class="form-check-input" name="type" id="get-ch" value="ch">
				<label for="get-ch" class="form-check-label">중식</label>&nbsp;
				<input type="radio" class="form-check-input" name="type" id="get-jp" value="jp">
				<label for="get-jp" class="form-check-label">일식</label>&nbsp;
			</div>
			<br />
			<div class="form-check form-check-inline">
				<input type="radio" class="form-check-input" name="taste" id="get-no-taste" value="all" checked>
				<label for="get-no-taste" class="form-check-label">모두</label>&nbsp;
				<input type="radio" class="form-check-input" name="taste" id="get-hot" value="hot" checked>
				<label for="get-hot" class="form-check-label">매운맛</label>&nbsp;
				<input type="radio" class="form-check-input" name="taste" id="get-mild" value="mild">
				<label for="get-mild" class="form-check-label">순한맛</label>
			</div>
			<br />
			<input type="button" class="btn btn-block btn-outline-success btn-send" value="전송" >
		</form>
	</div>
	<div class="result" id="menuTypeTaste-result"></div>
	<script>
	$(function(){
		$("#menuTypeTasteFrm .btn-send").on("click",function(){
			var type = $("#menuTypeTasteFrm [name=type]:checked").val();
			var taste = $("#menuTypeTasteFrm [name=taste]:checked").val();
			
			$.ajax({
	            url  : "${pageContext.request.contextPath}/menus/"+type+"/"+taste,
	            dataType: "json",
	            type : "get",
	            success : function(data){
	                console.log(data);
	                let html = displayResultTable(data);
	                $("#menuTypeTaste-result").html(html);
	                
	            },
	            error : function(jqxhr, textStatus, errorThrown){
	                console.log("ajax 처리 실패 : ",jqxhr,textStatus,errorThrown);
	            }
	        });
		});
	});
	</script>
	
	<!-- 2.POST -->
	<div class="menu-test">
		<h4>메뉴 등록하기(POST)</h4>
		<form id="menuEnrollFrm">
			<input type="text" name="restaurant" placeholder="음식점" class="form-control" />
			<br />
			<input type="text" name="name" placeholder="메뉴" class="form-control" />
			<br />
			<input type="number" name="price" placeholder="가격" class="form-control" />
			<br />
			<div class="form-check form-check-inline">
				<input type="radio" class="form-check-input" name="type" id="post-kr" value="kr" checked>
				<label for="post-kr" class="form-check-label">한식</label>&nbsp;
				<input type="radio" class="form-check-input" name="type" id="post-ch" value="ch">
				<label for="post-ch" class="form-check-label">중식</label>&nbsp;
				<input type="radio" class="form-check-input" name="type" id="post-jp" value="jp">
				<label for="post-jp" class="form-check-label">일식</label>&nbsp;
			</div>
			<br />
			<div class="form-check form-check-inline">
				<input type="radio" class="form-check-input" name="taste" id="post-hot" value="hot" checked>
				<label for="hot_" class="form-check-label">매운맛</label>&nbsp;
				<input type="radio" class="form-check-input" name="taste" id="post-mild" value="mild">
				<label for="mild_" class="form-check-label">순한맛</label>
			</div>
			<br />
			<input type="button" class="btn btn-block btn-outline-success btn-send" value="등록" >
		</form>
	</div>

	<script>
	$(function(){
		$("#menuEnrollFrm .btn-send").on("click",function(){
			//파라미터를 post방식으로 전송 -> message body에 씀
			//json문자열로 처리해야 컨트롤러에서 @RequestBody가 처리함(HttpMessageConverter에 의해 커맨트객체 매핑)
			//ajax요청 필수속성  => contentType: 'application/json; charset=utf-8' 
			var param = {};
			param.restaurant = $("#menuEnrollFrm [name=restaurant]").val();
			param.name = $("#menuEnrollFrm [name=name]").val();
			param.price = $("#menuEnrollFrm [name=price]").val();
			param.type = $("#menuEnrollFrm [name=type]:checked").val();
			param.taste = $("#menuEnrollFrm [name=taste]:checked").val();
			
			var jsonStr = JSON.stringify(param);
			console.log(jsonStr);
			
			$.ajax({
	            url  : "${pageContext.request.contextPath}/menu",
	            data : jsonStr,
	            dataType: "json",
	            contentType: 'application/json; charset=utf-8',
	            type : "post",
	            success : function(data){
	                alert(data.msg);
	            },
	            error : function(jqxhr, textStatus, errorThrown){
	                console.log("ajax 처리 실패 : ",jqxhr,textStatus,errorThrown);
	            },
	            complete : () => {
	                //jquery로 폼 리셋하기
	                $("#menuEnrollFrm")[0].reset();
		        }
	        });
		});
	});
	</script>
	
	
	<!-- #3.PUT -->
	<div class="menu-test">
		<h4>메뉴 수정하기(PUT)</h4>
		<p>메뉴번호를 사용해 해당메뉴정보를 수정함.</p>
		<form id="menuSearchFrm">
			<input type="text" name="id" placeholder="메뉴번호" class="form-control" /><br />
			<input type="button" class="btn btn-block btn-outline-primary btn-send" value="검색" >
		</form>
		<script>
		//@실습문제 : `/menu/메뉴번호`로 검색후에 #menuUpdateFrm에 값대입할 것.
		//- hidden필드(id)
		$("#menuSearchFrm .btn-send").on("click",function(){
				var id = $("#menuSearchFrm [name=id]").val()
				
				$.ajax({
		            url  : "${pageContext.request.contextPath}/menu/"+id,
		            dataType: "json",
		            type : "get",
		            success : function(data){
		                console.log(data);
		                
		                //리턴데이터가 null인 경우, json으로 변환불가. 빈 Menu객체를 전달함.
		                if(data.id==0) 
			                alert("해당하는 정보가 없습니다.");
		                else{
			                var frm = $("#menuUpdateFrm");			                
			                frm.find("[name=id]").val(data.id);
			                frm.find("[name=restaurant]").val(data.restaurant);
			                frm.find("[name=name]").val(data.name);
			                frm.find("[name=price]").val(data.price);
			                frm.find("[name=type][value="+data.type+"]").prop("checked",true);
			                frm.find("[name=taste][value="+data.taste+"]").prop("checked",true);		                	
		                }
		            },
		            error : function(jqxhr, textStatus, errorThrown){
		                console.log("ajax 처리 실패 : ",jqxhr,textStatus,errorThrown);
		            }
	
		        });
		});
		</script>
		<hr />
		<form id="menuUpdateFrm">
			<!-- where조건절에 사용할 id를 담아둠 -->
			<input type="hidden" name="id" />
			<input type="text" name="restaurant" placeholder="음식점" class="form-control" />
			<br />
			<input type="text" name="name" placeholder="메뉴" class="form-control" />
			<br />
			<input type="number" name="price" placeholder="가격" step="1000" class="form-control" />
			<br />
			<div class="form-check form-check-inline">
				<input type="radio" class="form-check-input" name="type" id="put-kr" value="kr" checked>
				<label for="put-kr" class="form-check-label">한식</label>&nbsp;
				<input type="radio" class="form-check-input" name="type" id="put-ch" value="ch">
				<label for="put-ch" class="form-check-label">중식</label>&nbsp;
				<input type="radio" class="form-check-input" name="type" id="put-jp" value="jp">
				<label for="put-jp" class="form-check-label">일식</label>&nbsp;
			</div>
			<br />
			<div class="form-check form-check-inline">
				<input type="radio" class="form-check-input" name="taste" id="put-hot" value="hot" checked>
				<label for="put-hot" class="form-check-label">매운맛</label>&nbsp;
				<input type="radio" class="form-check-input" name="taste" id="put-mild" value="mild">
				<label for="put-mild" class="form-check-label">순한맛</label>
			</div>
			<br />
			<input type="button" class="btn btn-block btn-outline-success btn-send" value="수정" >
		</form>
		
		<script>
		$(function(){
			$("#menuUpdateFrm .btn-send").on("click",function(){
				//파라미터를 put방식으로 전송 -> message body에 씀
				//json문자열로 처리해야 컨트롤러에서 @RequestBody가 처리함(HttpMessageConverter에 의해 커맨트객체 매핑)
				//ajax요청 필수속성  => contentType: 'application/json; charset=utf-8' 
				var param = {};				
				param.id = $("#menuUpdateFrm [name=id]").val();
				param.restaurant = $("#menuUpdateFrm [name=restaurant]").val();
				param.name = $("#menuUpdateFrm [name=name]").val();
				param.price = $("#menuUpdateFrm [name=price]").val();
				param.type = $("#menuUpdateFrm [name=type]:checked").val();
				param.taste = $("#menuUpdateFrm [name=taste]:checked").val();
				
				var jsonStr = JSON.stringify(param);
				console.log(jsonStr);
				
				//data에 쓴 파라미터를 GET방식에서는 jquery가 자동으로 url단으로 올려서 처리, PUT/DELETE에서는 messageBody에 써짐.
				$.ajax({
		            url  : "${pageContext.request.contextPath}/menu/",
		            data : jsonStr,//messageBody에 작성되고, @RequestBody에 의해 json데이터 처리됨(직렬화된 형태 허용안함.)
		            dataType: "json",
		            contentType: 'application/json; charset=utf-8',
		            type : "PUT",
		            success : function(data){
		                alert(data.msg);
		            },
		            error : function(jqxhr, textStatus, errorThrown){
		                console.log("ajax 처리 실패 : ",jqxhr,textStatus,errorThrown);
		            },
		            complete : () => {
		                //jquery로 폼 리셋하기
		                $("#menuUpdateFrm")[0].reset();
		                $("#menuSearchFrm")[0].reset();
			        }
		        });
			});
		});
		</script>
	</div>
	
	
	<!-- #4.DELETE -->
	<div class="menu-test">
		<h4>메뉴 삭제하기(DELETE)</h4>
		<p>메뉴번호를 사용해 해당메뉴정보를 삭제함.</p>
		<form id="menuDeleteFrm">
			<input type="text" name="id" placeholder="메뉴번호" class="form-control" /><br />
			<input type="button" class="btn btn-block btn-outline-danger btn-send" value="삭제" >
		</form>
		<script>
		$(function(){
			$("#menuDeleteFrm .btn-send").on("click",function(){
				if(!confirm("정말 삭제하시겠습니까?"))
					return;
				var id = $("#menuDeleteFrm [name=id]").val();
				
				$.ajax({
					//#issues
					//jquery에서 data속성에 쓴 파라미터를 PUT/DELETE에서는 messageBody에 써진다.
					//DELETE메소드에서는 messageBody의 파라미터가 무시되므로, 전달할 데이터는 pathVariable로 사용할 것.
		            url  : "${pageContext.request.contextPath}/menu/"+id,
		            dataType: "json",
		            type : "delete",
		            success : function(data){
		            	alert(data.msg);
		            },
		            error : function(jqxhr, textStatus, errorThrown){
		                console.log("ajax 처리 실패 : ",jqxhr,textStatus,errorThrown);
		            },
		            complete : () => {
		                //jquery로 폼 리셋하기
		            	$("#menuDeleteFrm")[0].reset();
			        }
	
		        });
			});
		});
		
		</script>
	</div>

</div><!-- end of #menu-container -->
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
