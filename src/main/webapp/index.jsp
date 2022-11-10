<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>index.jsp</title>
		<!-- 부트스트랩 -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		
		<p class="h1 text-center  rounded-circle" >INDEX</p>
		
		<oi>		
			<li><a href="<%=request.getContextPath()%>/dept/deptList.jsp">
				<p class="h2 text-center rounded-circle">부서관리</p>
				</a>
			</li>	
			<li>	
				<a href="<%=request.getContextPath()%>/emp/empList.jsp">
				<p class="h2 text-center rounded-circle">사원관리</p>
				</a>
			</li>
			<li>	
				<a href="<%=request.getContextPath()%>/board/boardList.jsp">
				<p class="h2 text-center rounded-circle">게시판</p>
				</a>
			</li>			
		</oi>
		<br>
		<div style ="text-align:center;" > 
			<img src="./img/goodee.jpg" class="center">
		</div>
	</body>
</html>