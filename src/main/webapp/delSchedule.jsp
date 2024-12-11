<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Loading...</title>
<%
	// Get the username from the session, set by checkCredentials
	String susername = (String)session.getAttribute("username");

	if (susername == null) {
		response.sendRedirect("login.jsp");
	}
%>
</head>
<body>
	<%
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		int affectedRows = stmt.executeUpdate("DELETE FROM trainsdb.schedule WHERE scid="+request.getParameter("scid")+";");
		
		if (affectedRows < 1) {
			throw new Exception("Could not delete schedule");
		} else {
			response.sendRedirect("customerRep.jsp");
		}
		
		con.close();
		stmt.close();
	%>
</body>
</html>