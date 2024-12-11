<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*, java.time.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="./styles/midStyle.css" />
<title>Questions</title>
<%
	// Get the username from the session, set by checkCredentials
	String susername = (String)session.getAttribute("username");

	if (susername == null) {
		response.sendRedirect("login.jsp");
	}
%>
</head>
<body>
<div class="marginDiv">
	<%
		// This page is reused for customers and customer reps so it has different behaviors
		// depending on who is using it
	
		String type = (String)session.getAttribute("type");
		if (type != null && type.equals("customerRep")) {
			out.print("<form action=\"customerRep.jsp\">");
		} else {
			out.print("<form action=\"welcome.jsp\">");
		}
	%>
		<input type="submit" value="Back" class="defaultButton"/>
	</form>
	
	<h3>Questions</h3>
	<%
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		Statement replyStmt = con.createStatement();
		
		String q;
		
		if (request.getParameter("keyword") != null) {
			String keyword = request.getParameter("keyword");
			q = "SELECT * FROM trainsdb.question WHERE txt LIKE '%"+keyword+"%';";
		} else {
			q = "SELECT * FROM trainsdb.question;";	
		}
		
		ResultSet res = stmt.executeQuery(q);
		
		while (res.next()) {
			out.print("<h3>"+res.getString("txt")+"</h3>");
			out.print("Asked by: "+res.getString("username")+"<br>");
			if (type != null && type.equals("customerRep")) {
				out.print("<form action=\"addReply.jsp\"><input type=\"text\" name=\"reply\" class=\"inputField\" placeholder=\"Reply\"/>");
				out.print("<input type=\"hidden\" name=\"qid\" value=\""+res.getString("qid")+"\" />");
				out.print("<input type=\"submit\" class=\"defaultButton\" value=\"Post\" /></form>");
			}
			
			StringBuilder replyQuery = new StringBuilder();
			replyQuery.append("SELECT r.txt, e.username\n");
			replyQuery.append("FROM trainsdb.reply r, trainsdb.employee e\n");
			replyQuery.append("WHERE e.ssn=r.ssn\n");
			replyQuery.append("AND r.qid="+res.getString("qid")+";");
			
			ResultSet replies = replyStmt.executeQuery(replyQuery.toString());
			while (replies.next()) {
				out.print("<div style=\"margin-left: 50px\"><h5>"+replies.getString("e.username")+"</h5>"+replies.getString("txt")+"</div>");
			}
		}
		
		con.close();
		stmt.close();
		res.close();
	%>
</div>
</body>
</html>