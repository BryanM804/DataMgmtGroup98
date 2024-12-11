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
		// 19:25
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		String q = "SELECT DATE(departure) dd, DATE(arrival) ad, TIME(departure) dt, TIME(arrival) at FROM trainsdb.schedule WHERE scid="+request.getParameter("scid")+";";
		ResultSet res = stmt.executeQuery(q);
		res.next();
		
		String ddate = res.getString("dd");
		String adate = res.getString("ad");
		String departTime = res.getString("dt");
		String arrivalTime = res.getString("at");
		
		String[] attrs = {"linename", "departure", "arrival", "travel", "origin", "dest", "fare", "tid"};
		
		StringBuilder query = new StringBuilder();
		query.append("UPDATE trainsdb.schedule SET ");
		
		for (int i = 0; i < attrs.length; i++) {
			String attr = request.getParameter(attrs[i]);
			if (attr != null && !attr.equals("") && !attrs[i].startsWith("departure") && !attrs[i].startsWith("arrival")) {
				query.append(attrs[i]+"='"+attr+"',");
			} else if (attrs[i].startsWith("departure") || attrs[i].startsWith("arrival")) {
				if (!request.getParameter(attrs[i]+"Date").equals("")) {
					if (attrs[i].equals("departure"))
						ddate = request.getParameter(attrs[i]+"Date");
					else
						adate = request.getParameter(attrs[i]+"Date");
				}
				
				if (request.getParameter(attrs[i]).equals("")) {
					if (attrs[i].equals("departure"))
						attr = ddate+" "+departTime;
					else
						attr = adate+" "+arrivalTime;
				} else {
					if (attrs[i].equals("departure"))
						attr = ddate+" "+request.getParameter(attrs[i])+":00";
					else
						attr = adate+" "+request.getParameter(attrs[i])+":00";
				}
				query.append(attrs[i]+"='"+attr+"',");
			}
		}
		query.deleteCharAt(query.length() - 1);
		query.append(" WHERE scid="+request.getParameter("scid")+";");
	
		
		int affectedRows = stmt.executeUpdate(query.toString());
		
		if (affectedRows < 1) {
			throw new Exception("Could not edit schedule");
		} else {
			response.sendRedirect("customerRep.jsp");
		} 
		
		con.close();
		res.close();
		stmt.close();
	%>
</body>
</html>