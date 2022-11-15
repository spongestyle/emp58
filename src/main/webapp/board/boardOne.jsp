<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>


<%
	
	//1
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	// 댓글 페이징에 사용할 현재 페이지
	int currentPage = 1;
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	
	//2 - 1 게시글 하나
	
	// 접속연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	
	String boardSql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	Board board = null;
	if(boardRs.next()) {
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = boardRs.getString("boardTitle");
		board.boardContent = boardRs.getString("boardContent");
		board.boardWriter = boardRs.getString("boardWriter");
		board.createdate = boardRs.getString("createdate");
	}

	// 2- 2 댓글 목록
	// 이슈) 댓글도 페이징이 필요하다 지금은 안할것.
	// LIMIT ?, ?
			
			
	int rowPerPage = 5;
	int beginRow = (currentPage -1 ) * rowPerPage;
	
	String commentSql = "SELECT comment_no commentNo, comment_content commentContent, createdate FROM comment WHERE board_no = ? ORDER BY comment_no DESC LIMIT ?, ?";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, beginRow);
	commentStmt.setInt(3, rowPerPage);

	
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()) {
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		c.createdate = commentRs.getString("createdate");
		commentList.add(c);
	}
	// 2-3 댓글 전체의 수 --> lastPage
	int lastPage = 0;	
	
%>
<!DOCTYPE html>
<html>
<head>
	<!-- Bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
	th.green { background: rgba(0, 128, 0, 0.1); }
	
	td.green { background: rgba(0, 128, 0, 0.1); }
	
	body { background: rgb(238, 238, 255); }

	table { background-color : white;}
	
	</style>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
		<!-- 메뉴 partial jsp 구성 -->
	<div  class= "container mt-3" style= "width:800px;">
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
	
		
		<h1 class = "text-center mb-3">게시글 상세보기</h1>
		<table class = "table table-bordered table-hover w-100 rounded">
			<tr>
				<th style= "width:100px"; class = "green">NO</th>
				<th><%=board.boardNo%></th>
			</tr>
			<tr>
				<th class = "green">제목</th>
				<th><%=board.boardTitle%></th>
			</tr>
			<tr>
				<td class = "green" >내용</td>
				<td><%=board.boardContent%></td>
			</tr>
			<tr>
				<td class = "green">글쓴이</td>
				<td><%=board.boardWriter%></td>
			</tr>
			<tr>
				<td class = "green">게시날짜</td>
				<td><%=board.createdate%></td>
			</tr>
		</table>
			<a href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>">&#9986;수정</a>
			<a href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=boardNo%>">&#10060;삭제</a>
		<br>
		
		
		
		<!-- 댓글 목록 -->
	
		
		
		<div>
			<h4 class="text-center mb-3">댓글목록</h4>
			<div class= "container mt-3" style= "width:800px;">
				<%
					for(Comment c : commentList) {
				%>
				<table  class= "table table table-bordered table-hover w-100 rounded">
					<tr>
						<td  class = "green"style= "width:60px;"><div><%=c.commentNo%></div></td>
					 	<td><div><%=c.commentContent%></div></td>
					 	<td  style= "width:80px;">
					 		<div><a href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?commentNo=<%=c.commentNo%>&boardNo=<%=boardNo%>">
								&#10060;삭제</a>
							</div>
						</td>
						<td style= "width:120px;"><div><%=c.createdate %></div></td>				 	
					</tr>
				</table>
				<%		
					}
				%>
		
			
			</div>			
		</div>
		
		<!-- 댓글 페이징 -->
		<%
			if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>">
					이전
				</a>
		<%		
			}
		
			// 다음 <-- 마지막페이지 <-- 전체행의 수 
			if(currentPage < lastPage) {
		%>
		<span><%=currentPage%></span>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>">
					다음
				</a>
		<%	
			}
		%>
		
	
	<!-- 댓글입력 폼 -->
	<div class= "container mt-3" style= "width:800px;">
		<h4 class = "text-center mb-3">댓글입력</h4>
	
		<form action = "<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
			<input type = "hidden" name = "boardNo" value = "<%=board.boardNo%>">
			<table  class ="table table-bordered" >
				<tr>
					<td>내용</td>
					<td><textarea rows="3" cols="80" name = "commentContent"></textarea></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<input type = "password" name = "commentPw">
					</td>
				</tr>
			</table>
			<button type = "submit">&#9989;댓글입력</button>
		</form>
	</div>
	
	
	
</body>
</html>