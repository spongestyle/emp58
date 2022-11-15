<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%

	
	
	// 1.요청 분석 (Controller)
	request.setCharacterEncoding("UTF-8");
	String word = request.getParameter("word");
	// 1) word -> null 2) word -> '' 3) word ->'단어'
	
	// 2.업무(요청)처리 (Model)-> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");

	
	// 부서 검색하기
	String sql = null;
	PreparedStatement stmt = null;
	if (word == null) {
			sql = "SELECT dept_no deptNo, dept_name deptName FROM departments ORDER BY dept_no ASC";
			stmt = conn.prepareStatement(sql);
			} else {
			/*
			SELECT *
			FROM departments
			WHERE dept_name LIKE ?
			ORDER BY dept_no ASC
			*/
			sql = "SELECT dept_no deptNo, dept_name deptName FROM departments WHERE dept_name LIKE ? ORDER BY dept_no ASC";
			stmt = conn.prepareStatement(sql);
			stmt.setString (1, "%"+word+"%");
	}

	ResultSet rs = stmt.executeQuery();  
	// <- 모델 데이터로서 ResultSet은 일반적인 타입이 아니고 독립적인 타입도 아니다.
	// ResultSet rs라는 모델 자료구조를 좀 더 일반적이고 독립적인 자료구조로 변경을 하자.
	ArrayList<Department> list = new ArrayList<>();
	while(rs.next()) { // ResultSet의 API(사용방법)를 모른다면 사용할 수 없는 반복문
		Department d = new Department();
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d);
	}
	// 3.출력 (View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
	
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
	<!-- 메뉴 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	<div class= "container mt-3" style= "width:600px;">
		<br>
		<h1>DEPT LIST</h1>
		<br>
		<!-- 부서명 검색창 -->
		<form action = "<%=request.getContextPath()%>/dept/deptList.jsp" method="post">
			<label for ="">부서이름 검색 : </label>
			<input type = "text" name="word" id="word">
			<button type = submit>검색</button>	
		</form>
		
		<div>		
			<!-- 부서목록출력(부서번호 내림차순으로) -->
			<table  class = "table">
				<thead>
					<tr class=h4>
						<th>부서번호</th>
						<th>부서이름</th>	
						<th>수정</th>
						<th>삭제</th>	
					</tr>			
				</thead>
				<tbody>
				<%
					for (Department d : list) {
				%>
						<tr>
							<td><%=d.deptNo%></td>
							<td><%=d.deptName%></td>
							<td>
								<a href="<%=request.getContextPath()%>/dept/updateDeptForm.jsp?deptNo=<%=d.deptNo%>">
								수정
								</a>
							</td>
							<td>
								<a href="<%=request.getContextPath()%>/dept/deleteDept.jsp?deptNo<%=d.deptNo%>">
								삭제
								</a>
							</td>
						</tr>
				<%			
				}
				%>
				</tbody>
			</table>
		<div>
			<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp">부서추가</a>
		</div>	
		</div>
	</div>


</body>
</html>