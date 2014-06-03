<%@ page contentType="text/html; charset=utf-8" language="java"
	import="java.sql.*" import="database.*" import="java.util.*"
	errorPage=""%>
<%
	/*if(session.getAttribute("name")!=null)
	 {
	 String name=(String) session.getAttribute("name");
	 }*/
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SALES</title>
</head>
<body>
	<%
		try {
			Class.forName("org.postgresql.Driver");
			Connection conn = null;
			conn = DriverManager.getConnection(
					"jdbc:postgresql://localhost:5432/postgres",
					"postgres", "password");
			conn.setAutoCommit(false);
	%>
	<form action="salesAnalytics.jsp" method="post">
		<table style="margin:auto">
			<tr align="center">
				<td><select id="rowtype" name="rowtype">
						<option	<%if ("customers".equals(request.getParameter("rowtype"))) {%>selected<%}%> value="customers">Customers</option>
						<option <%if ("states".equals(request.getParameter("rowtype"))) {%>selected <%}%> value="states">States</option>
				</select></td>
			</tr>
			<tr>
				<td> State <select id="states" name="states">
					<option>All</option>
					<option <%if ("Alabama".equals(request.getParameter("states"))) {%>selected <%}%>>Alabama</option>
					<option	<%if ("Arkansas".equals(request.getParameter("states"))) {%>selected <%}%>>Alaska</option>
					<option <%if ("Arizona".equals(request.getParameter("states"))) {%>selected <%}%>>Arizona</option>
					<option	<%if ("Arkansas".equals(request.getParameter("states"))) {%>selected <%}%>>Arkansas</option>
					<option	<%if ("California".equals(request.getParameter("states"))) {%>selected <%}%>>California</option>
					<option	<%if ("Colorado".equals(request.getParameter("states"))) {%>selected <%}%>>Colorado</option>
					<option	<%if ("Connecticut".equals(request.getParameter("states"))) {%>selected <%}%>>Connecticut</option>
					<option	<%if ("Delaware".equals(request.getParameter("states"))) {%>selected <%}%>>Delaware</option>
					<option <%if ("Florida".equals(request.getParameter("states"))) {%>selected <%}%>>Florida</option>
					<option <%if ("Georgia".equals(request.getParameter("states"))) {%>selected <%}%>>Georgia</option>
					<option <%if ("Idaho".equals(request.getParameter("states"))) {%>selected <%}%>>Hawaii</option>
					<option <%if ("Idaho".equals(request.getParameter("states"))) {%>selected <%}%>>Idaho</option>
					<option	<%if ("Illinois".equals(request.getParameter("states"))) {%>selected <%}%>>Illinois</option>
					<option <%if ("Indiana".equals(request.getParameter("states"))) {%>selected <%}%>>Indiana</option>
					<option <%if ("Iowa".equals(request.getParameter("states"))) {%>selected <%}%>>Iowa</option>
					<option <%if ("Kansas".equals(request.getParameter("states"))) {%>selected <%}%>>Kansas</option>
					<option	<%if ("Kentucky".equals(request.getParameter("states"))) {%>selected <%}%>>Kentucky</option>
					<option	<%if ("Louisiana".equals(request.getParameter("states"))) {%>selected <%}%>>Louisiana</option>
					<option <%if ("Maine".equals(request.getParameter("states"))) {%>selected <%}%>>Maine</option>
					<option	<%if ("Maryland".equals(request.getParameter("states"))) {%>selected <%}%>>Maryland</option>
					<option	<%if ("Massachusetts".equals(request.getParameter("states"))) {%>selected <%}%>>Massachusetts</option>
					<option	<%if ("Michigan".equals(request.getParameter("states"))) {%>selected <%}%>>Michigan</option>
					<option	<%if ("Minnesota".equals(request.getParameter("states"))) {%>selected <%}%>>Minnesota</option>
					<option	<%if ("Mississippi".equals(request.getParameter("states"))) {%>selected <%}%>>Mississippi</option>
					<option	<%if ("Missouri".equals(request.getParameter("states"))) {%>selected <%}%>>Missouri</option>
					<option <%if ("Montana".equals(request.getParameter("states"))) {%>selected <%}%>>Montana</option>
					<option	<%if ("Nebraska".equals(request.getParameter("states"))) {%>selected <%}%>>Nebraska</option>
					<option <%if ("Nevada".equals(request.getParameter("states"))) {%>selected <%}%>>Nevada</option>
					<option	<%if ("New Hampshire".equals(request.getParameter("states"))) {%>selected <%}%>>New Hampshire</option>
					<option	<%if ("New Jersey".equals(request.getParameter("states"))) {%>selected <%}%>>New Jersey</option>
					<option	<%if ("New Mexico".equals(request.getParameter("states"))) {%>selected <%}%>>New Mexico</option>
					<option	<%if ("New York".equals(request.getParameter("states"))) {%>selected <%}%>>New York</option>
					<option	<%if ("North Carolina".equals(request.getParameter("states"))) {%>selected <%}%>>North Carolina</option>
					<option	<%if ("North Dakota".equals(request.getParameter("states"))) {%>selected <%}%>>North Dakota</option>
					<option <%if ("Ohio".equals(request.getParameter("states"))) {%>selected <%}%>>Ohio</option>
					<option	<%if ("Oklahoma".equals(request.getParameter("states"))) {%>selected <%}%>>Oklahoma</option>
					<option <%if ("Oregon".equals(request.getParameter("states"))) {%>selected <%}%>>Oregon</option>
					<option	<%if ("Pennsylvania".equals(request.getParameter("states"))) {%>selected <%}%>>Pennsylvania</option>
					<option	<%if ("Rhode Island".equals(request.getParameter("states"))) {%>selected <%}%>>Rhode Island</option>
					<option	<%if ("South Carolina".equals(request.getParameter("states"))) {%>selected <%}%>>South Carolina</option>
					<option <%if ("South Dakota".equals(request.getParameter("states"))) {%>selected <%}%>>South Dakota</option>
					<option	<%if ("Tennessee".equals(request.getParameter("states"))) {%>selected <%}%>>Tennessee</option>
					<option <%if ("Texas".equals(request.getParameter("states"))) {%>selected <%}%>>Texas</option>						<option <%if ("Utah".equals(request.getParameter("state"))) {%>selected <%}%>>Utah</option>
					<option <%if ("Vermont".equals(request.getParameter("states"))) {%>selected <%}%>>Vermont</option>
					<option	<%if ("Virginia".equals(request.getParameter("states"))) {%>selected <%}%>>Virginia</option>
					<option	<%if ("Washington".equals(request.getParameter("states"))) {%>selected <%}%>>Washington</option>
					<option	<%if ("West Virginia".equals(request.getParameter("states"))) {%>selected <%}%>>West Virginia</option>
					<option	<%if ("Wisconsin".equals(request.getParameter("states"))) {%>selected <%}%>>Wisconsin</option>
					<option <%if ("Wyoming".equals(request.getParameter("states"))) {%>selected <%}%>>Wyoming</option>
				</select> Category <select id="categories" name="categories">
					<option value=-1>All</option>
					<%
						try {
							ResultSet rsCat = null;
							Statement st = conn.createStatement();
							rsCat = st.executeQuery("SELECT id,name FROM categories");
							while (rsCat.next()) {
								if ((rsCat.getInt("id")+"").equals(request.getParameter("categories"))) {
					%>
					<option value=<%=rsCat.getInt("id") %> selected><%=rsCat.getString("name")%></option>
					<%
								} else {
					%>
					<option value=<%=rsCat.getInt("id") %>><%=rsCat.getString("name")%></option>
					<%
								}
							}
						} catch (SQLException sqle) {
							out.println(sqle.getMessage());
						}
					%>
				</select></td>
			</tr>
			<tr>
				<td align="center"><input type="submit" name="value" value="Run Query" /></td>
			</tr>
		</table>
	</form>
	<%
		if (request.getParameter("rowtype")!=null) {	
			String rowtype = request.getParameter("rowtype");
			int category = Integer.parseInt(request.getParameter("categories"));
			String state = request.getParameter("states");
	%>
	<table style="margin:auto" border=1>
		<tr>
			<th></th>
			<%
				String query = "SELECT product, SUM(subtotal) AS total FROM precols WHERE true";
				if (category!=-1) {
					query += " AND category="+category;
				}
				if (!"All".equals(state)) {
					query += " AND state='"+state+"'";
				}
				query += " GROUP BY product ORDER BY total DESC NULLS LAST LIMIT 10";
				PreparedStatement prst = conn.prepareStatement(query);
				ResultSet rsCols = null;
				rsCols = prst.executeQuery();
				while(rsCols.next()) {
			%>
			<th><%=rsCols.getString("product") %><br><%=rsCols.getInt("total") %></th>
			<%
				}
			%>
		</tr>
		<%
		// ROW HEADERS AND MATRIX
		%>
	</table>
	<%
		}
			conn.commit();
			conn.setAutoCommit(true);
			conn.close();
		} catch (SQLException sqle) {
			out.println(sqle.getMessage());
		} catch (Exception e) {
			out.println(e.getMessage());
		}
	%>
</body>
</html>
