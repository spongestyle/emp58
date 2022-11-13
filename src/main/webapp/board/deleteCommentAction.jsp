<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.net.*" %>

<%

	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentPw = request.getParameter("commentPw");

	// 2
	// 연결접속
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");

	// 쿼리 문자열 생성
	String sql = "DELETE FROM comment WHERE comment_no=? AND comment_pw=?";
	// 쿼리 셋팅
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, commentNo);
	stmt.setString(2, commentPw);
	
	// 쿼리실행
	int row = stmt.executeUpdate();
	// 쿼리실행결과 
	if(row == 1) {
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
	} else {
		String msg = URLEncoder.encode("비밀번호를 확인하세요", "utf-8");
		response.sendRedirect(
				request.getContextPath()+"/board/deleteBoardForm.jsp?boardNo="+commentNo+"&msg="+msg);
	}

%>