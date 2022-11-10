<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	if (request.getParameter("boardTitle") == null
		|| request.getParameter("boardContent") == null
		|| request.getParameter("boardWriter") == null)    {
			
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp");
		return;
	}
	//한글처리
	request.setCharacterEncoding("utf-8");

	// 1.
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	
	
	
	// 2.
	// 연결 접속
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
		
	PreparedStatement stmt = conn.prepareStatement(
			"INSERT INTO board(board_title boardTitle, board_content boardContent, board_writer boardWriter, create_date) values(?,?,?,curdate())");
	
	// 2-2 sql 들어가는 값
	stmt.setString(1, boardTitle);
	stmt.setString(2, boardContent);
	stmt.setString(3, boardWriter);
	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	// 3. 결과출력
	response.sendRedirect(request.getContextPath()+"board/boardList.jsp");
%>
