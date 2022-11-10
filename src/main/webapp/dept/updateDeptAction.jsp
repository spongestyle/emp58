<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	//한글
	request.setCharacterEncoding("utf-8");

	// 1.요청분석
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")) {
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp");
		return;
	}
	
	Department dept = new Department();
	dept.deptNo = deptNo;
	dept.deptName = deptName;


	// 2.요청처리
	//연결
	Class.forName("org.mariadb.jdbc.Driver");
	
	//접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	//쿼리만들기
	String sql = "UPDATE departments SET dept_name = ?  WHERE dept_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	//sql 값 세팅
	stmt.setString(1, deptName);
	stmt.setString(2, deptNo);
	
	
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
