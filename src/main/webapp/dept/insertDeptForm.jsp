<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>부서 추가</h2>
	<form action = "<%=request.getContextPath()%>/dept/insertDeptAction.jsp">
		<table>
			
			
			<tr>
				<td>부서번호</td>
				<td>
					<input type="text" name="dept_no" value="">
				</td>				
			</tr>
			<tr>
				<td>부서이름</td>
				<td>
					<input type="text" name="dept_name" value="">
				</td>				
			</tr>
			<tr>
				<td colspan="2">
				<button type = "submit">add</button>
				</td>
			</tr>

		</table>
	</form>
</body>
</html>