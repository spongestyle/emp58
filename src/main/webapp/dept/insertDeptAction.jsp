<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%

	//한글처리
	request.setCharacterEncoding("utf-8");

	// 1. 요청 분석
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")) {
	String msg = URLEncoder.encode("부서번호와 부서이름을 입력하세요","utf-8"); // get방식 주소창에 문자열 인코딩
	
	response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
    return;
 	}


	// 2. 요청 처리
	// 이미 존재하는 key(dept_no)값 동일한 값이 입력되면 예외(에러)가 발생한다. -> 동일한 dept_no값이 입력되었을때 예외가 발생하지 않도록...
	// 연결
	Class.forName("org.mariadb.jdbc.Driver");
	// 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 2-1 dept_no or dept_name중복검사
	String sql1 = "SELECT dept_no FROM departments WHERE dept_no =? OR dept_name = ?"; //입력하기전에 같은 dept_no가 존재하는지 확인
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, deptNo);
	stmt1.setString(2, deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()) { // 결과물있다 -> 같은 dept_no가 이미 존재한다
		String msg = URLEncoder.encode("부서번호or부서이름이 중복됩니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
		}
	
	// 2-2 쿼리만들기
	String sql2 = "INSERT INTO departments (dept_no, dept_name) Value(?, ?)";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	
	// 2-2 sql 들어가는 값
	stmt2.setString(1, deptNo);
	stmt2.setString(2, deptName);
	
	//
	int row = stmt2.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	// 결과 보여주는 페이지
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");

%>

