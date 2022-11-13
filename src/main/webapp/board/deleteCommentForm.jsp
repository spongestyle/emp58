<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	//1
	// 게시글 번호 방어코드
	if(request.getParameter("boardNo") == null){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	// 댓글 번호
	if(request.getParameter("commentNo") == null){
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+Integer.parseInt(request.getParameter("boardNo")));
		return;
	}
			
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String msg = request.getParameter("msg");	// 비밀번호 불일치 -> msg 보여주기

	// 2 - 요청 처리 불필요


%>
<!DOCTYPE html>
<html>
<head>
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
		   <form method="post" action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp">
	   		<table class="table">
	   			<tr>
					<td colspan="2">
						<input type="hidden" name="boardNo" value=<%=boardNo%>>
					</td>
				</tr>
				<tr>
					<td>댓글 번호</td>
					<td>
						<input type="text" name="commentNo" value=<%=commentNo%> readonly="readonly">
					</td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<!-- 비밀번호는 넘어오면 안 되므로 value값 주지 않음 -->
						<input type="password" name="commentPw" class="box">
					</td>
				</tr>
				<tr class="text-center">
					<td colspan="2">
						<button type="submit" class="btn btn-outline-primary">삭제</button>
					</td>
				</tr>
	   		</table>
	   </form>


</body>
</html>