<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 한글
	request.setCharacterEncoding("utf-8");


	// 1.요청 분석 (Controller)
	Department dept = new Department();
	dept.deptNo = request.getParameter("dept_no");
	dept.deptName = null;
	
	// 2.요청 처리
	
	// 연결
	Class.forName("org.mariadb.jdbc.Driver");
	
	// 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");

	// sql만들기
	String sql = "SELECT dept_no deptNo, dept_name deptName FROM departments WHERE dept_no = ?";	
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// sql 값 세팅
	stmt.setString(1, dept.deptNo); // 받아온 게시물 번호(deptNo)를 쿼리문의 ?에 넣기
	
	
	// 쿼리 실행하는 메서드
	ResultSet rs = stmt.executeQuery(); // 받은 데이터 rs 변수에 저장
	


	if(rs.next()) {
		dept.deptName = rs.getString("dept_name");
	}
	System.out.println("수정할 데이터 : " + dept.deptNo + " " + dept.deptName);


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
		<div class = "container mt-3" style= "width:600px;">
		
		<form action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp" method="post">
			<table>
			
				<tr>
					<td colspan="2" class = "h4">부서 수정</td>
				</tr>
				
				<tr>
					<th>부서 번호</th>
					<td><input type="text" style = "background-color : pink" name="dept_no" value="<%=dept.deptNo%>" readonly = "readonly"></td>
				</tr>
				
				<tr>
					<th>부서 이름</th>
					<td><input type="text" name="dept_name" value="<%=dept.deptName%>"></td>
				</tr>
							
				<tr>
					<th colspan="2"><button type = "submit" class="btn btn-dark buttonSize"><span class="buttonFont">수정 완료</span></button></th>
				</tr>				
			</table>
		</form> 
	</div>

</body>
</html>