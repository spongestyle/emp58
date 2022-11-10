<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 1. 요청분석
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));		
	}
	
	// 2. 요청처리 후 (필요하다면) 모델데이터를 생성
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	
	final int ROW_PER_PAGE = 10;    // 변수 앞에 final을 앞에 두면 상수. 상수는 항상 대문자. 일반변수로 해도상관없음.
	int beginRow = (currentPage-1) * ROW_PER_PAGE;  // ....Limit beginRow, ROW_PER_PAGE 
	
	// 2-1 
	String cntSql = "SELECT COUNT(*) cnt FROM board";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; // 전체 행의 수
	if(cntRs.next()) {
		cnt = cntRs.getInt ("cnt");
	}
	// 올림(ceil) 5.3->6.0,  5.0 -> 5.0
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE)); //더블은 소수점으로 계산
	
	
	
	// 2-2
	String listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";

	PreparedStatement listStmt = conn.prepareStatement(listSql);
	listStmt.setInt (1, beginRow);
	listStmt.setInt (2, ROW_PER_PAGE);
	ResultSet listRs = listStmt.executeQuery(); //모델 source data
	ArrayList<Board> boardList = new ArrayList<Board>(); // 모델의 new data
	while(listRs.next()) {
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		boardList.add(b);
	}
%>


<!DOCTYPE html>
<html>
<head>
	<!-- Bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<meta charset="UTF-8">
<title>boardList</title>
</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
		<div class= "container mt-3" style= "width:800px;">
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>	
		
		
		<h2>자유 게시판</h1>
		<div ="container mt-3">
			<div>
				<a href = "<%=request.getContextPath()%>/board/insertBoardForm.jsp">게사글 입력</a>
			</div>
			<!--  3-1. 모델 데이터 (ArrayList<Board>) 출력 -->
			<table class ="table table-bordered table-hover">
				<tr  class = "table-info">
					<th style= "width:100px;">번호</th>
					<th>게시글</th>
				</tr>
			
				<%
					for(Board b : boardList) {
				%>		
						<tr >
							<td><%=b.boardNo%></td>
							<!-- 제목을 클릭하면 상세보기로 이동 -->
							<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>">
									<%=b.boardTitle%>
								</a>
							</td>	
						</tr>
				<%		
					}
				
				%>
			
			</table>
			<!--  3.2 페이징 -->
			<div>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1">처음</a>
				
				<%
					if(currentPage >1) {
				%>
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>">이전</a>
				<%
					}
				%>
				
				<span><%=currentPage%></span>
				
				<%
					if(currentPage < lastPage){
				%>		
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>">다음</a>
				<%
					}
				%>
				
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막</a>
			
			
			</div>
		</div>

</body>
</html>