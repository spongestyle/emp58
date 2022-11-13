<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.net.URLEncoder" %>

<%

	//한글처리
	request.setCharacterEncoding("UTF-8");

	// 1.
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String boardPw = request.getParameter("boardPw");
	
	// 방어코드
	if(boardTitle == null || boardContent == null || boardWriter == null || boardPw == null || 
			boardTitle.equals("") ||boardContent.equals("") ||boardWriter.equals("") || boardPw.equals("")) {
				//// 메시지와 함께 입력폼으로 돌려보냄
			String msg = URLEncoder.encode("빈칸을 입력해주세요.", "UTF-8");	
			response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
			return;
		}
	// 2.
	// 연결 접속
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 쿼리만들기
	PreparedStatement stmt = conn.prepareStatement(
			"INSERT INTO board(board_title, board_content, board_writer, board_pw, createdate) values(?,?,?,?,curdate())");
	
	// 2 sql 들어가는 값
	stmt.setString(1, boardTitle);
	stmt.setString(2, boardContent);
	stmt.setString(3, boardWriter);
	stmt.setString(4, boardPw);
	
	int row = stmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	// 3. 결과출력
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>
