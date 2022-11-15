<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%
	// 1. 요청분석
	
	int currentPage = 1; //현재 페이지
	
	if(request.getParameter("currentPage") != null) { //안전장치
		currentPage = Integer.parseInt(request.getParameter("currentPage"));		
	}
	
	
	// 한글
	request.setCharacterEncoding("UTF-8"); //항상 맨위에 해주자.
	String word = request.getParameter("word"); //검색
	
	// 2. 요청처리 후 (필요하다면) 모델데이터를 생성
	// 한페이지당 행 개수는 10;으로 지정
	final int ROW_PER_PAGE = 10;    // 변수 앞에 final을 앞에 두면 상수. 상수는 항상 대문자. 일반변수로 해도상관없음.
	int beginRow = (currentPage-1) * ROW_PER_PAGE;  // ....Limit beginRow, ROW_PER_PAGE 
	
	// 접속연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	

	
	// 2-1  검색페이지 구하기
	
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(word == null) {
		cntSql ="SELECT COUNT (*) cnt FROM board";
		cntStmt = conn.prepareStatement(cntSql);
	} else { //word 가 들어간 페이지 개수
		cntSql = "SELECT COUNT (*) cnt FROM board WHERE board_title LIKE ? ORDER BY board_no DESC";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%" + word + "%");
		
	}
	ResultSet cntRs = cntStmt.executeQuery();
	
	int cnt = 0; // 전체 행의 수
	if(cntRs.next()) {
		cnt = cntRs.getInt ("cnt");
	}
	
	// 마지막 페이지 올림 ceil 5.3->6.0   5.0 -> 5.0
	int lastPage=(int)Math.ceil((double)cnt/(double)ROW_PER_PAGE);
	
	
	// 2-2 페이지 불러오기
	String listSql = null;
	PreparedStatement listStmt = null;
	if (word == null){
		listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no DESC LIMIT ?,?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, ROW_PER_PAGE);
	} else { // word를 포함하는 게시글 출력
		listSql = "SELECT board_no boardNo, board_title boardTitle FROM board WHERE board_title LIKE ? ORDER BY board_no DESC LIMIT ?,?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%" + word + "%");
		listStmt.setInt(2, beginRow);
		listStmt.setInt(3, ROW_PER_PAGE);
	}
	
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
	<style>
		th.green { background: rgba(0, 128, 0, 0.1); }
		
		td.green { background: rgba(0, 128, 0, 0.1); }
		
		body { background: rgb(238, 238, 255); }
	
		table { background-color : white;}
		
	</style>
<meta charset="UTF-8">
<title>boardList</title>
</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
		<div class= "container mt-3" style= "width:800px;">
			<div>
				<jsp:include page="/inc/menu.jsp"></jsp:include>
			</div>	

		
			<h2>자유 게시판</h2>
			<div class ="container mt-3">
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
								<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>&word=<%=word%>">
										<%=b.boardTitle%>
									</a>
								</td>	
							</tr>
					<%		
						}
					
					%>
				
				</table>
				<!--  3.2 페이징 -->
				<div class= "container mt-3" style= "width:800px;">
					<%
						if (word == null ){
					%>
							
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
					<%
						} else { // ("word") 를 검색하고 나서 페이징
					
					%>
							<a href = "<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1&word=<%=word%>">처음</a>
						<%
							if(currentPage >1) {
					
						%>
								<a href= "<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
						<%
							}
						%>
							<span><%=currentPage%></span>
						
						<%
							if(currentPage < lastPage) {
						%>	
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>
						<%
							}
						%>
							<a href = "<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>&word=<%=word %>">마지막</a>
					<%
						}				
					%>
				</div>
						<!-- 게시글 검색창 -->
				<form action = "<%=request.getContextPath()%>/board/boardList.jsp" method="post">
					<label for ="word">게시글 검색 : </label>
					<input type = "text" name="word" id="word">
					<button type = submit>검색</button>	
				
				</form>
			</div>
		</div>
	

</body>
</html>