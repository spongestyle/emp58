<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%


	
	// 한글
	request.setCharacterEncoding("UTF-8"); 
	//접속연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234"); // ->커넥션연결 매서드 ("프로트콜://주소:포트번호","","")
	
	
	ArrayList<DeptEmp> lise = new ArrayList<DeptEmp>();
	while(rs.next()) {
		DeptEmp de = new DeptEmp();
		de.emp = new Employee();
		de.emp.empNo = rs.getInt("empNo");
		de.dept = new Department();
		de.dept.deptNo = rs.getInt ("deptNo");
		de.fromDate = rs.getString("fromDate"); 
		de.toDate = rs.getString("toDate");
	}



%>
<%
	//DeptEmp.class가 없다면
	//deptEmpMapList.jsp
	ArrayList<HashMap<String, Object>> list = new ArrayList<String, Object>();
	while(rs.next()) {
		// ...
	}


%>




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>