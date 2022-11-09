<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//한글
	request.setCharacterEncoding ("UTF-8");

	//1.요청 분석 (Controller)
	Department dept = new Department();	
	dept.deptNo = request.getParameter("dept_no");


	// 2.업무(요청)처리 (Model)-> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	// 연결
	Class.forName("org.mariadb.jdbc.Driver");
	
	// 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// sql 작성
	String sql = "DELETE FROM departments WHERE dept_no = ?;"; //N번째의 데이터 DELETE하기
	PreparedStatement stmt = conn.prepareStatement(sql); //쿼리 문장을 실행시키는 객체
	
	// sql delete문에 들어갈 값
	stmt.setString(1, dept.deptNo);
	
	// 디버깅
	int row = stmt.executeUpdate();
	
	if(row ==1) {
		System.out.println("삭제성공");
	} else {
		System.out.println("삭제실패");
	}
	
	
	//삭제후 보여주는 페이지
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>
