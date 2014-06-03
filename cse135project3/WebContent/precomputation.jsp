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
	stmt.execute("CREATE TABLE preCols(state TEXT,product TEXT,category INTEGER,subtotal INTEGER)");
	rs = stmt.executeQuery("SELECT states.name AS state"
			+ " ,products.name AS product"
			+ " ,products.cid AS category"
			+ " ,SUM(sales.quantity*sales.price) AS subtotal"
			+ " FROM"
			+ " (sales JOIN users ON sales.uid=users.id) RIGHT OUTER JOIN"
			+ " (states FULL OUTER JOIN products ON true) ON sales.pid=products.id AND users.state=states.name"
			+ " GROUP BY states.name, products.name, products.cid"
			+ " ORDER BY states.name"
			);
	conn.commit();
	PreparedStatement prst=conn.prepareStatement("INSERT INTO precols(state,product,category,subtotal) VALUES (?,?,?,?)");
	while(rs.next()) {
		prst.setString(1,rs.getString("state"));
		prst.setString(2,rs.getString("product"));
		prst.setInt(3,rs.getInt("category"));
		prst.setInt(4,rs.getInt("subtotal"));
		prst.execute();
	}
	conn.commit();
} catch(Exception e) {
  out.println(e.getMessage());
} finally {
	conn.close();
}	
%>
</body>
</html>
