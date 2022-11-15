<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- HashMap<키,값>, ArrayList<요소> -->
<%

	// 1) 요청분석
	// 페이징 currentPage, ...

	// 2) 요청처리
	// 페이징 rowPerPage, ...
	int rowPerPage = 10;
	int beginRow = 0;
	// db 연결 - > 모델생성
	String driver = "org.maradb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234"); // ->커넥션연결 매서드 ("프로트콜://주소:포트번호","","")
	String sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while (rs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", rs.getInt("empNo"));
		m.put("salary", rs.getInt("salary"));
		m.put("fromDate", rs.getString("fromDate"));
		m.put("name", rs.getString("name"));
		list.add(m);
	}
	
	rs.close();
	stmt.close();
	conn.close(); // db연결을 끊는 매서드1
%>


	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	<h1>연봉 목록</h1>
	<table>
		<tr>
			<th>사원번호</th>
			<th>사원이름</th>
			<th>연봉</th>
			<th>계약일자</th>
		</tr>
		<%
			for(HashMap<String, Object> m : list) {	
		%>
				<tr>
					<td><%=m.get("empNo")%></td>
					<td><%=m.get("name")%></td>
					<td><%=m.get("salary")%></td>
					<td><%=m.get("fromDate")%></td>
				</tr>
		<%
			}
		%>
	
	
	
	</table>
	
	
	
	
	
	
</body>
</html>


















