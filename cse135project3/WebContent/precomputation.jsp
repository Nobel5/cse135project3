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
	
	stmt.execute("DROP TABLE IF EXISTS preCols");
	stmt.execute("DROP TABLE IF EXISTS preRows");
	stmt.execute("DROP TABLE IF EXISTS preMatrix");
	
	// Column headers
	stmt.execute("CREATE TABLE precols(stateid INTEGER,productid INTEGER,subtotal INTEGER)");
	rs = stmt.executeQuery(
			"SELECT states.id AS stateid"
			+ " ,products.id AS productid"
			+ " ,SUM(sales.quantity*sales.price) AS subtotal"
			+ " FROM"
			+ " (sales JOIN users ON sales.uid=users.id) RIGHT OUTER JOIN"
			+ " (states FULL OUTER JOIN products ON true) ON sales.pid=products.id AND users.state=states.name"
			+ " GROUP BY stateid, productid"
			+ " ORDER BY stateid"
			);
	conn.commit();
	PreparedStatement prst=conn.prepareStatement("INSERT INTO precols(stateid,productid,subtotal) VALUES (?,?,?)");
	while(rs.next()) {
		prst.setInt(1,rs.getInt("stateid"));
		prst.setInt(2,rs.getInt("productid"));
		prst.setInt(3,rs.getInt("subtotal"));
		prst.execute();
	}
	
	// Row headers
	
	conn.commit();
} catch(Exception e) {
  out.println(e.getMessage());
} finally {
	conn.close();
}	
%>
</body>
</html>
