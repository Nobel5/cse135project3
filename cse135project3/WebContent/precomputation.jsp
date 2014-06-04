<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>PRECOMPUTATION</title>
</head>
<body>
<%
Connection conn=null;
Statement stmt,stmt_2,stmt_3;
ResultSet rs=null,rs_2=null,rs_3=null;
String SQL=null;
try {
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	String url="jdbc:postgresql://localhost:5432/postgres";
	String user="postgres";
	String password="password";
	conn = DriverManager.getConnection(url, user, password);
	conn.setAutoCommit(false);
	stmt = conn.createStatement();
	
	stmt.execute("DROP TABLE IF EXISTS precols");
	stmt.execute("DROP TABLE IF EXISTS prerows");
	stmt.execute("DROP TABLE IF EXISTS prematrix");
	
	// Column headers
	stmt.execute("CREATE TABLE precols(stateid INTEGER,productid INTEGER,subtotal INTEGER)");
	stmt.execute("INSERT INTO precols(stateid,productid,subtotal) ("
			+ "SELECT states.id AS stateid"
			+ " ,products.id AS productid"
			+ " ,SUM(sales.quantity*sales.price) AS subtotal"
			+ " FROM"
			+ " (sales JOIN users ON sales.uid=users.id) RIGHT OUTER JOIN"
			+ " (states FULL OUTER JOIN products ON true) ON sales.pid=products.id AND users.state=states.name"
			+ " GROUP BY stateid, productid"
			+ " ORDER BY stateid"
			+ ");");
	conn.commit(); 
	System.out.println();
	
	// Row headers
	stmt.execute("CREATE TABLE prerows(uid INTEGER,cid INTEGER,subtotal INTEGER)");
	stmt.execute("INSERT INTO prerows(uid,cid,subtotal) ("
			+ "SELECT users.id AS userid"
			+ " ,products.cid AS cid"
			+ " ,SUM(sales.quantity*sales.price) AS subtotal"
			+ " FROM"
			+ " (users FULL OUTER JOIN categories ON true)"
			+ " JOIN products ON products.cid=categories.id"
			+ " LEFT OUTER JOIN sales ON sales.uid=users.id AND sales.pid=products.id"
			+ " GROUP BY userid, cid"
			+ " ORDER BY userid"
			+ ");");
	conn.commit();
	
} catch(Exception e) {
  out.println(e.getMessage());
} finally {
	conn.close();
}	
%>
</body>
</html>
