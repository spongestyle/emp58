<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 검색
	request.setCharacterEncoding("UTF-8");	//한글
	String searchName = request.getParameter("searchName");
	// 1) searchName == null, 2) searchName == "" or "단어"
	
	// 2
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage;
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	// 2-1. 마지막 페이지
	// 검색 기능 넣기 위한 null 초기화
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(searchName == null){
		cntSql = "SELECT COUNT(*) cnt FROM salaries";
		cntStmt = conn.prepareStatement(cntSql);	
	}else {
		cntSql = "SELECT COUNT(*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		// 성 or 이름에 검색하고자 하는 단어가 포함되어 있다면
		cntStmt.setString(1, "%"+searchName+"%");
		cntStmt.setString(2, "%"+searchName+"%");
	}
	
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	int lastPage = (int)Math.ceil((double)cnt/rowPerPage);
	
	// 2-2. 조인 처리
	// 테이블1 JOIN 테이블2 ON 조건
	String sql = null;
	PreparedStatement stmt = null;
	if(searchName == null){
		sql ="SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);		
	} else {
		sql ="SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY s.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+searchName+"%");
		stmt.setString(2, "%"+searchName+"%");
		stmt.setInt(3, beginRow);
		stmt.setInt(4, rowPerPage);		
	}
	
	ResultSet rs = stmt.executeQuery();
	ArrayList<Salary> salaryList = new ArrayList<>();
	while(rs.next()){
		Salary s = new Salary();
		s.emp = new Employee(); // ☆객체에 객체 넣기☆
		s.emp.empNo = rs.getInt("empNo");
		s.salary = rs.getInt("salary");
		s.fromDate = rs.getString("fromDate");
		s.toDate = rs.getString("toDate");
		s.emp.firstName = rs.getString("firstName");
		s.emp.lastName = rs.getString("lastName");
		salaryList.add(s);
	}
	
	// 3
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SALARY LIST</title>
<!-- 부트스트랩 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/empCss.css">
</head>
<body>
	<div class="container">
		<!-- 메뉴 partial jsp 구성-->
		<div class="text-center">
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<br>
		<h1 class="text-center">연봉</h1>
		
		<!-- 검색창 -->
		<!-- 즐겨찾기 등에 쓸 주소를 저장하려고 get 방식을 사용해야할 때가 있음 / <a>는 무조건 get 방식 -->
		<form action="<%=request.getContextPath()%>/salary/salaryList.jsp" method="post">
			<label for="searchName">
				<input type="text" name="searchName" id="searchName" placeholder="사원 성/이름 검색">
			 </label>
			<button type="submit" class="btn btn-outline-primary">검색</button>
		</form>
		
		<table class="table">
			<tr>
				<td>사원번호</td>
				<td>연봉</td>
				<td>입사날짜</td>
				<td>퇴사날짜</td>
				<td>이름</td>
				<td>성</td>
			</tr>
			<%
				for(Salary s : salaryList){
			%>	
					<tr>
						<td><%=s.emp.empNo%></td>
						<td><%=s.salary%></td>
						<td><%=s.fromDate%></td>
						<td><%=s.toDate%></td>
						<td><%=s.emp.firstName%></td>
						<td><%=s.emp.lastName%></td>
					</tr>
			<%
				}
			%>
		</table>
				<!-- 페이징 -->
		<div class="text-center">
			<%
				if(searchName == null){			
			%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1">처음</a>
					<%
						if(currentPage > 1){
					%>
							<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>">이전</a>
					<%
						}
					%>
					<span><%=currentPage%></span>
					<%
						if(currentPage < lastPage){
					%>
							<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>">다음</a>
					<%
						}
					%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>">마지막</a>
			<% 
				}else{			
			%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1&searchName=<%=searchName%>">처음</a>
					<%
						if(currentPage > 1){
					%>
							<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>&searchName=<%=searchName%>">이전</a>
					<%
						}
					%>
					<span><%=currentPage%></span>
					<%
						if(currentPage < lastPage){
					%>
							<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>&searchName=<%=searchName%>">다음</a>
					<%
						}
					%>
					<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>&searchName=<%=searchName%>">마지막</a>
			<% 
				}
			%>
		</div>
	</div>
</body>
</html>