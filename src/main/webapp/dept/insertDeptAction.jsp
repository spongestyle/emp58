<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%

	//한글처리
	request.setCharacterEncoding("utf-8");

	//안전장치
		if(request.getParameter("dept_no") == null || 
		request.getParameter("dept_name") == null) {
		
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp");
		return;
	}

	// 1. 요청 분석
	Department dept = new Department();
	dept.deptNo = request.getParameter("dept_no");
	dept.deptName = request.getParameter("dept_name");

	// 2. 요청 처리
	// 연결
	Class.forName("org.mariadb.jdbc.Driver");
	
	// 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 쿼리만들기
	String sql = "INSERT INTO departments (dept_no, dept_name) Values(?, ?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// sql 들어가는 값
	stmt.setString(1, dept.deptNo);
	stmt.setString(2, dept.deptName);
	
	//
	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	// 결과 보여주는 페이지
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");

%>

