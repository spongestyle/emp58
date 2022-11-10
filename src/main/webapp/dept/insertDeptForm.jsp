<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
	<!-- Bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<body>
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<form action = "<%=request.getContextPath()%>/dept/insertDeptAction.jsp">
		<div class= "container mt-3" style= "width:600px;">
			
			<table class = "table">
				<h2>부서 추가</h2>
					<!-- msg 파라메타값이 있으면 출력 -->
					<%
						if (request.getParameter("msg") != null) {		
					%>		
							<div><%=request.getParameter("msg")%></div>
					<%
						}
					%>
				
							
					<tr>
						<td>부서번호</td>
						<td>
							<input type="text" name="deptNo" value="">
						</td>				
					</tr>
					<tr>
						<td>부서이름</td>
						<td>
							<input type="text" name="deptName" value="">
						</td>				
					</tr>
					<tr>
						<td colspan="2">
						<button type = "submit">add</button>
						</td>
					</tr>				
			</table>
		</div>
	</form>
</body>
</html>