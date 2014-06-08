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
	stmt.execute("DROP TABLE IF EXISTS prerowsstates");
	stmt.execute("DROP TABLE IF EXISTS prematrix");
	stmt.execute("DROP TABLE IF EXISTS prematrixstates");
	
	// Column headers
	stmt.execute("CREATE TABLE precols(stateid INTEGER,productid INTEGER,subtotal INTEGER)");
	stmt.execute("INSERT INTO precols(stateid,productid,subtotal) ("
			+ "SELECT states.id AS stateid"
			+ " ,products.id AS productid"
			+ " ,SUM(sales.quantity*sales.price) AS subtotal"
			+ " FROM sales JOIN users ON sales.uid=users.id JOIN products ON sales.pid=products.id RIGHT OUTER JOIN states ON users.state=states.name"
			+ " GROUP BY stateid, productid"
			+ " ORDER BY stateid"
			+ ");");
	System.out.println("1");
	String query="INSERT INTO precols(productid,subtotal) ("
			+ "SELECT products.id AS productid"
			+ " ,SUM(sales.quantity*sales.price) AS subtotal"
			+ " FROM sales JOIN users ON sales.uid=users.id JOIN products ON sales.pid=products.id RIGHT OUTER JOIN states ON users.state=states.name"
			+ " GROUP BY productid"
			+ ""
			+ ");";
			System.out.println("QUERY :\n"+query);
	stmt.execute(query);
	System.out.println("2");
	stmt.execute("UPDATE precols  SET stateid=0 WHERE stateid is NULL");
	System.out.println("3");
	conn.commit(); 
	System.out.println();
	
	// Row headers
	stmt.execute("CREATE TABLE prerows(uid INTEGER,cid INTEGER,subtotal INTEGER)");
	stmt.execute("INSERT INTO prerows(uid,cid,subtotal) ("
			+ "SELECT users.id AS userid"
			+ " ,products.cid AS cid"
			+ " ,SUM(sales.quantity*sales.price) AS subtotal"
			+ " FROM users JOIN sales ON users.id=sales.uid JOIN products ON products.id=sales.pid JOIN categories ON products.cid=categories.id"
			+ " GROUP BY userid, cid"
			+ " ORDER BY userid"
			+ ");");
	query="INSERT INTO prerows(uid,subtotal) ("
			+ "SELECT users.id AS userid"
			+ ""
			+ " ,SUM(sales.quantity*sales.price) AS subtotal"
			+ " FROM users JOIN sales ON users.id=sales.uid JOIN products ON products.id=sales.pid JOIN categories ON products.cid=categories.id"
			+ " GROUP BY userid"
			+ ""
			+ ");";
	System.out.println(query);
	stmt.execute(query);
	query="UPDATE prerows  SET cid=0 WHERE cid is NULL";
	stmt.execute(query);
	conn.commit();

	stmt.execute("CREATE TABLE prerowsstates(sid INTEGER, cid INTEGER, subtotal INTEGER)");
	stmt.execute("INSERT INTO prerowsstates(sid,cid,subtotal) ("
			+ "SELECT states.id AS sid"
			+ ",products.cid AS cid"
			+ ",SUM(sales.quantity*sales.price) AS subtotal"
			+ " FROM users JOIN sales ON users.id=sales.uid JOIN products ON products.id=sales.pid JOIN categories ON products.cid=categories.id JOIN states ON users.state=states.name"
			+ " GROUP BY sid, cid"
			+ " ORDER BY sid)");
	query = "INSERT INTO prerowsstates(sid,subtotal) ("
			+ "SELECT states.id AS sid"
			+ ",SUM(sales.quantity*sales.price) AS subtotal"
			+ " FROM users JOIN sales ON users.id=sales.uid JOIN products ON products.id=sales.pid JOIN categories ON products.cid=categories.id JOIN states ON users.state=states.name"
			+ " GROUP BY sid)";
	System.out.println(query);
	stmt.execute(query);
	query = "UPDATE prerowsstates SET cid=0 WHERE cid IS NULL";
	stmt.execute(query);
	conn.commit();
	
	stmt.execute("CREATE TABLE prematrix(uid INTEGER,pid INTEGER,subtotal INTEGER)");
	stmt.execute("INSERT INTO prematrix(uid,pid,subtotal) ("
			+ "SELECT sales.uid,sales.pid,SUM(sales.quantity*sales.price) AS sub FROM sales GROUP BY sales.uid,sales.pid);");
	conn.commit();
	
	stmt.execute("CREATE TABLE prematrixstates(sid INTEGER,pid INTEGER,subtotal INTEGER)");
	stmt.execute("INSERT INTO prematrixstates(sid,pid,subtotal) ("
			+ "SELECT states.id,sales.pid,SUM(sales.quantity*sales.price) AS sub FROM sales JOIN users ON sales.uid=users.id JOIN states ON users.state=states.name GROUP BY states.id,sales.pid)");
	conn.commit();
	
	stmt.execute("CREATE INDEX uidindex ON prematrix(uid)");
	//stmt.execute("CREATE INDEX pidindex ON prematrix(pid)");
	conn.commit();
	System.out.println("done");
} catch(Exception e) {
  out.println(e.getMessage());
} finally {
	conn.close();
}	
%>
</body>
</html>
