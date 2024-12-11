<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*, java.time.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Questions</title>
</head>
<body>
	<%
		// Placeholder just showing questions for now
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		String q = "SELECT * FROM trainsdb.question;";
		
		ResultSet res = stmt.executeQuery(q);
		
		while (res.next()) {
			out.print("ID: "+res.getString("qid")+"\n");
			out.print("username: "+res.getString("username")+"\n");
			out.print("question: "+res.getString("txt"));
		}
	%>
</body>
</html>