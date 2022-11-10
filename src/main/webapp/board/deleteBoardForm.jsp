<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>

<%
	//한글넣기
	request.setCharacterEncoding ("UTF-8");
	//1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	
	// 2. 요청처리
	// 접속연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection ("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");	
	// sql
	String sql = "DELETE FROM board WHERE boardNo = ?; "; //N번째의 데이터 DELETE하기
	PreparedStatement stmt = conn.prepareStatement(sql); //쿼리 문장을 실행시키는 객체
	// sql delete문에 들어갈 값
	
	stmt.setInt(1, boardNo);
	
	
	
	// 디버깅
	

	//삭제후 보여주는 페이지
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");

%>
