<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Logout</title>
	<style>
		body {
			font-family: "Arial";
		}
		.defaultButton {
			margin: 2px;
			padding: 6px;
			border-radius: 15px;
		}
	</style>
</head>
<body>
	<%
		// Invalidate the session
		session.removeAttribute("username");
		session.invalidate();
	%>

	<h2>Goodbye!</h2>
	<form action="login.jsp">
		<input type="submit" value="Back to Login" class="defaultButton" />
	</form>
</body>
</html>