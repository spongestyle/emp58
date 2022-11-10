<%@page import="vo.Department"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	//한글
	request.setCharacterEncoding("utf-8");

	// 1.
   String deptNo = request.getParameter("deptNo");
   //deptList의 링크로 호출하지 않고 updateDeptForm.jsp 주소창에 직접 호출하면 deptNo는 null값이된다.
   if(deptNo == null) { 
      response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
      return;
   }
	// 2. 
   Class.forName("org.mariadb.jdbc.Driver");
   Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
   
   
   String sql = "SELECT dept_name deptName FROM departments WHERE dept_no = ?";
   PreparedStatement stmt = conn.prepareStatement(sql);
   
   
   stmt.setString(1, deptNo);
   ResultSet rs = stmt.executeQuery(); 

   Department dept = null;   
   if (rs.next()) { // ResultSet의 API(사용방법)를 모른다면 사용할 수 없는 반복문
      dept = new Department();
      dept.deptNo = deptNo;
      dept.deptName = rs.getString("deptName");
   }
	// 3.
%>
<!DOCTYPE html>
<html>
<head>
	<!-- Bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<meta charset="UTF-8">
<title>updateDeptForm</title>
</head>
	<body>
		<div>
		<!-- 메뉴 partial jsp 구성 -->
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<div class= "container mt-3" style= "width:600px;">
			<h1>부서수정</h1>
			<form method="post" action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp">
				<table class ="table">
					<tr>
						<td>부서번호</td>
						<td><input type="text" name="deptNo" value="<%=dept.deptNo%>" readonly="readonly"></td>
					</tr>
					<tr>
						<td>부서이름</td>
						<td><input type="text" name="deptName" value="<%=dept.deptName%>"></td>
					</tr>
				</table>
				<button type="submit">수정</button>
			</form>
		</div>
</body>
</html>