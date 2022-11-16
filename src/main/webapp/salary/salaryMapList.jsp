<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- HashMap<키,값>, ArrayList<요소> -->
<%

	// 1) 요청분석
	// 페이징 currentPage, ...
	int currentPage = 1;
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));		
	}
	//한글
	request.setCharacterEncoding("UTF-8");
	String searchName = request.getParameter("searchName");	
		
	// 2) 요청처리
	
	
	// db 연결 - > 모델생성
	String driver = "org.maradb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234"); // ->커넥션연결 매서드 ("프로트콜://주소:포트번호","","")
	
	
	// 페이징 rowPerPage, beginRow
	int rowPerPage = 10;
	int beginRow = (currentPage-1)* rowPerPage;
	
	String cntSql = null;
	PreparedStatement cntStmt = null;
		if (searchName == null) {
			cntSql = "SELECT COUNT (*) cnt FROM salaries";
			cntStmt = conn.prepareStatement(cntSql);
		} else {
			cntSql = "SELECT COUNT (*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e. last_name LIKE ?";
			cntStmt = conn.prepareStatement(cntSql);
			// first_name or last_name 검색해서 포함되어 있다면
			cntStmt.setString(1, "%" + searchName + "%");			
			cntStmt.setString(2, "%" + searchName + "%");	
		}
	ResultSet cntRs = cntStmt.executeQuery();
	
	int cnt = 0;
	if (cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	int lastPage = (int)Math.ceil((double)cnt/rowPerPage);
	
	
	String sql = null;
	PreparedStatement stmt = null;
	if(searchName == null){
		sql ="SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate,  CONCAT(e.first_name, ' ', e.last_name)name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);		
	} else {
		sql ="SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, CONCAT(e.first_name,' ', e.last_name)name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE CONCAT(e.first_name, ' ',e.last_name) LIKE ? ORDER BY s.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+searchName+"%");
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);		
	}
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while (rs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", rs.getInt("empNo"));
		m.put("salary", rs.getInt("salary"));
		m.put("fromDate", rs.getString("fromDate"));
		m.put("toDate", rs.getString("toDate"));
		m.put("name", rs.getString("name"));
		list.add(m);
	}
	
	cntRs.close();
	cntStmt.close();
	conn.close(); // db연결을 끊는 매서드1
%>


	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<!-- Bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		th.green { background: rgba(0, 128, 0, 0.1); }
		
		td.green { background: rgba(0, 128, 0, 0.1); }
		
		tr.green { background: rgba(0, 128, 0, 0.1); }
		
		body { background: rgb(238, 238, 255); }
	
		table { background-color : white;}
		
	</style>
<title>Insert title here</title>
</head>
<body>
	<div class= "container mt-3" style= "width:800px;">
		<div class="text-center">
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>	
		<br>
		<h2 class="text-center">연봉</h2>
			

		<div class ="container mt-3">
			<table  class ="table table-bordered table-hover">
				<tr class="green">
					<th>사원번호</th>
					<th>이름</th>
					<th>연봉</th>
					<th>입사날짜</th>
					<th>퇴사날짜</th>					
				</tr>
				
				<%
					for(HashMap<String, Object> m : list) {				
				%>
						<tr>
							<td><%=m.get("empNo")%></td>
							<td><%=m.get("name")%></td>
							<td><%=m.get("salary")%></td>
							<td><%=m.get("fromDate")%></td>
							<td><%=m.get("toDate")%></td>
						</tr>
				<%
					}
				%>
	
			</table>
			
			<!-- 페이징 -->
			<div class = "text-center">
				<%
					if(searchName == null){			
				%>
						<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=1">처음</a>
					<%
						if(currentPage > 1){
					%>
							<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage-1%>">이전</a>
					<%
						}
					%>
					<span><%=currentPage%></span>
					<%
						if(currentPage < lastPage){
					%>
							<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage+1%>">다음</a>
					<%
						}
					%>
						<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=lastPage%>">마지막</a>
				<% 
					}else{			
				%>
						<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=1&searchName=<%=searchName%>">처음</a>
						<%
							if(currentPage > 1){
						%>
								<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage-1%>&searchName=<%=searchName%>">이전</a>
						<%
							}
						%>
						<span><%=currentPage%></span>
						<%
							if(currentPage < lastPage){
						%>
								<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=currentPage+1%>&searchName=<%=searchName%>">다음</a>
						<%
							}
						%>
						<a href="<%=request.getContextPath()%>/salary/salaryMapList.jsp?currentPage=<%=lastPage%>&searchName=<%=searchName%>">마지막</a>
				<% 
					}
				%>
					
			</div>
					<!-- 검색하기 -->
				<form action = "<%=request.getContextPath()%>/salary/salaryMapList.jsp" method = "post">
					<label for= "searchName">
						<input type ="text" name="searchName" id= "searchName">
					</label>
					<button type = "submit">검색</button>
				</form>

		</div>
	</div>
	
</body>
</html>


















