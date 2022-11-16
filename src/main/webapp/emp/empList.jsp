<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 1
	// 페이지 알고리즘
	int currentPage = 1; //현재 페이지
	if(request.getParameter("currentPage") != null) { //안전장치
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 한글
	request.setCharacterEncoding("UTF-8");
	String searchWord = request.getParameter("searchWord"); //검색
	// 접속연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 2. 요청처리
	
	int rowPerPage = 10; // 한페이지당 10; 지정
	int beginRow = (currentPage-1) * rowPerPage;
	
	
	// 검색 페이지 구하기
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(searchWord == null) {
		cntSql = "SELECT COUNT(*)  FROM employees";
		cntStmt = conn.prepareStatement(cntSql);
	} else { // word가 들어간 페이지 갯수
		cntSql = "SELECT COUNT (*)  FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY emp_no ASC";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%" + searchWord + "%");
		cntStmt.setString(2, "%" + searchWord + "%");	
	}
	ResultSet cntRs = cntStmt.executeQuery();
		
	
	
	int cnt = 0; //전체 행의 수
	if(cntRs.next()) {
		cnt = cntRs.getInt("COUNT(*)");
	}
	// lastPage 처리
	int lastPage = cnt / rowPerPage;
	if(cnt % rowPerPage != 0) {
		lastPage = lastPage + 1; // lastPage++, lastPage+=1
	}
	
	// 한페이지당 출력할 emp목록 불러오기
	String empSql = null;
	PreparedStatement empStmt = null;
	if ( searchWord == null ){
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setInt(1, (currentPage-1) * rowPerPage);
		empStmt.setInt(2, rowPerPage);
	} else { //searchWord를 포함하는 게시글 출력
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE? OR last_name LIKE ? ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setString (1, "%" + searchWord + "%");
		empStmt.setString (2, "%" + searchWord + "%");
		empStmt.setInt(3, (currentPage-1) * rowPerPage);
		empStmt.setInt(4, rowPerPage);		
	}
		
	ResultSet empRs = empStmt.executeQuery();
	
	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()) {
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
	}
%>

<!DOCTYPE html>
<html>
	<!-- Bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		th.green { background: rgba(0, 128, 0, 0.1); }
		
		td.green { background: rgba(0, 128, 0, 0.1); }
		
		body { background: rgb(238, 238, 255); }
	
		table { background-color : white;}
		
	</style>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div class= "container mt-3" style= "width:600px;">
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>	
	
		<h1>사원목록</h1>
		
		<table class = "table">
			<tr>
				<th>사원번호</th>
				<th>퍼스트네임</th>
				<th>라스트네임</th>
			</tr>
			<%
				for(Employee e : empList) {
			%>
					<tr>
						<td><%=e.empNo%></td>
						<td><%=e.firstName%></td>
						<td><%=e.lastName%></td>
					</tr>
			<%		
				}
			%>
		</table>
		
		
	
		<!-- 페이징 코드 ★★★-->
		<div>
			<%
				if (searchWord == null) {
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음</a>
					<span>  <%=currentPage%></span> <!--  현재 페이지  -->
					<%
						if(currentPage > 1) {				
					%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
					<%
						}
					
						if(currentPage < lastPage) {
					%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>	
					<%	
						}
					%>
						<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막</a>
			<%
				} else { // searchWord 를 검색하고 나서 페이징
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1&searchWord=<%=searchWord%>">처음</a>
					<span>  <%=currentPage%></span> <!--  현재 페이지  -->
					<%
						if(currentPage > 1) {				
					%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>&searchWord=<%=searchWord%>">이전</a>
					<%
						}
					
						if(currentPage < lastPage) {
					%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>&searchWord=<%=searchWord%>">다음</a>	
					<%	
						}
					%>	
						<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&searchWord=<%=searchWord%>">마지막</a>
			<%
				}
			%>

		</div>
		
		
		<!--댓글 검색-->
		<form action = "<%=request.getContextPath()%>/emp/empList.jsp" method ="post">
			<label for ="">사원이름 검색 :</label>
				<input type = "text" name = "searchWord "id ="searchWord">
			<button type = "submit">검색</button>
		</form>
		

		
	</div>
</body>
</html>