<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*, java.time.*" %>
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
		String username = (String)session.getAttribute("username");
		String type = (String)session.getAttribute("type");
		
		if (username == null || type == null || !type.equals("customerRep")) {
			response.sendRedirect("login.jsp");
		}
		
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		String ssnQ = "SELECT ssn FROM trainsdb.employee WHERE username='"+username+"';";
		ResultSet ssns = stmt.executeQuery(ssnQ);
		ssns.next();
		String ssn = ssns.getString("ssn");
		
		String q = "INSERT INTO trainsdb.reply (txt, ssn, qid) VALUES ('"+request.getParameter("reply")+"', "+ssn+", "+request.getParameter("qid")+");";
		
		int affectedRows = stmt.executeUpdate(q);
		
		if (affectedRows < 1) {
			throw new Exception("Could not add reply.");
		} else {
			response.sendRedirect("viewQuestions.jsp");
		}
		
		con.close();
		stmt.close();
		ssns.close();
	%>
</body>
</html>