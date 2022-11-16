<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
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
	

	// 2
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage;
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");

	String cntSql = null;
	PreparedStatement cntStmt = null;
		if (searchName == null) {
			cntSql = "SELECT COUNT(*) cnt FROM salaries";
			cntStmt = conn.prepareStatement(cntSql);
		} else {
			cntSql = "SELECT COUNT(*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
			cntStmt = conn.prepareStatement(cntSql);
			// first_name or last_name 검색해서 포함되어 있다면
			cntStmt.setString(1, "&"+ searchName +"&");
			cntStmt.setString(2, "&"+ searchName +"&");
		}
		
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if (cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	int lastPage = (int)Math.ceil((double)cnt/rowPerPage);
	
	// 
	
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
					<th>연봉</th>
					<th>입사날짜</th>
					<th>퇴사날짜</th>
					<th>이름</th>
					<th>성</th>
				</tr>
				
				<%
					for(Salary s : salaryList) {				
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
			<div class = "text-center">
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
					<!-- 검색하기 -->
				<form action = "<%=request.getContextPath()%>/salary/salaryList.jsp" method = "post">
					<label for= "searchName">
						<input type ="text" name="searchName" id= "searchName">
					</label>
					<button type = "submit">검색</button>
				</form>

		</div>
	</div>
</body>
</html>