<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*" %>
<%@ page import="vo.*"%>

<%
	//한글처리
	request.setCharacterEncoding("UTF-8");

	// 1.
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentContent = request.getParameter("commentContent");
	String commentPw = request.getParameter("commentPw");

	// 방어코드

	// 2.
	// 연결 접속
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 댓글쓰기 sql 만들기 
	String sql = "INSERT INTO comment(board_no, comment_content, comment_pw, createdate) VALUES (?, ?, ?, CURDATE())";
	PreparedStatement stmt = conn.prepareStatement(sql);

	
	// 2 sql 들어가는 값
	stmt.setInt(1, boardNo);
	stmt.setString(2, commentContent);
	stmt.setString(3, commentPw);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("댓글 등록 성공");
	}else {
		System.out.println("댓글 등록 실패");
	}
	
	// 3. 결과출력
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);

%>
