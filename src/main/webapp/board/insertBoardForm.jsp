<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<!DOCTYPE html>
<html>
<head>
	<!-- Bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class= "container mt-3" style= "width:800px;">
		<div >
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<br>
		<h3>게시글 작성</h3>
		<!-- msg 파라메타값이 있으면 출력 -->
			<%
				if (request.getParameter("msg") != null) {		
			%>		
					<div><%=request.getParameter("msg")%></div>
			<%
				}
			%>
		<form action = "<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
			<table class="table table-bordered">
			
				<tr>
					<th style= "width:90px;">제목</th>
					<td>
						<input type="text"  name = "boardTitle" class="form-control">
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td>
						<textarea name="boardContent" class="form-control" rows="5" cols="50" ></textarea>
					</td>
				</tr>
				<tr>
					<th>글쓴이</th>
					<td><input type = "text" name="boardWriter" class = "form-control"  style= "width:130px;"></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<input type="password" name="boardPw" class="form-control" style= "width:130px;">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button type = "submit">게시물 작성</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>