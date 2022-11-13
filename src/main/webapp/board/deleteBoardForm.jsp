<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>

<%
	//한글넣기
	request.setCharacterEncoding ("UTF-8");
	//1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String msg = request.getParameter("msg"); // 수정실패 리다이렉시에는 null값이 아니고 메세지 有
	



%>
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
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	 <h1>게시글 삭제</h1>
	<%
		if(msg != null) {
	%>
			<div><%=msg%></div>
	<%      
		}
	%>
	<form action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp" method="post">
		<input type="hidden" name="boardNo" value="<%=boardNo%>">
			삭제할 비밀번호 :
		<input type="password" name="boardPw">
		<button type="submit">삭제</button>
	</form>






</body>
</html>