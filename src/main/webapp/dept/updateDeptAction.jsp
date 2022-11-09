<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	//한글
	request.setCharacterEncoding("utf-8");

	//안전 장치코드

	if(request.getParameter("dept_no") == null || request.getParameter("dept_name") == null)
	{ 
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp"); /////////////
		return;
	}  

	// 1.요청분석
	Department dept = new Department();
	dept.deptNo = request.getParameter("dept_no");
	dept.deptName = request.getParameter("dept_name");


	// 2.요청처리
	//연결
	Class.forName("org.mariadb.jdbc.Driver");
	
	//접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	//쿼리만들기
	String sql = "UPDATE departments SET dept_name = ?  WHERE dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	//sql 값 세팅
	stmt.setString(1, dept.deptNo);
	stmt.setString(2, dept.deptName);
	
	//디버깅
	
	int row = stmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	
	//결과보여주는 페이지
	
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");

	

%>
