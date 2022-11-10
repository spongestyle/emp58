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
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<br>
		<h3>게시글 작성</h3>
		<form action = "<%=request.getContextPath()%>/board/insertBoardAction.jsp">
			<table class="table table-bordered">
			
				<tr>
					<th style= "width:80px;">제목</th>
					<td>
						<input type="text" class="form-control" name = "title">
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td>
						<textarea class="form-control" rows="5" cols="50" name="content"></textarea>
					</td>
				</tr>
				<tr>
					<th>글쓴이</th>
					<td><input type = "text" class = "form-control" name="writer"></td>
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