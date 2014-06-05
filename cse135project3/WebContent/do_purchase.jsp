<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<%@include file="welcome.jsp" %>
<%
if(session.getAttribute("name")!=null)
{

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>

<body>

<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<table width="100%">
		<tr><td><a href="products_browsing.jsp" target="_self">Show Produts</a></td></tr>
		<tr><td><a href="buyShoppingCart.jsp" target="_self">Buy Shopping Cart</a></td></tr>
	</table>	
</div>
<div style="width:79%; position:absolute; top:50px; right:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
<p><table align="center" width="80%" style="border-bottom-width:2px; border-top-width:2px; border-bottom-style:solid; border-top-style:solid">
	<tr><td align="left"><font size="+3">
	<%
	String uName=(String)session.getAttribute("name");
	int userID  = (Integer)session.getAttribute("userID");
	String role = (String)session.getAttribute("role");
	String card=null;
	int card_num=0;
	try {card=request.getParameter("card"); }catch(Exception e){card=null;}
	try
	{
		 card_num    = Integer.parseInt(card);
		 if(card_num>0)
		 {
	
				Connection conn=null;
				Statement stmt=null;
				try
				{
					String  SQL="delete from sales where uid="+userID+";";
					
					try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
					String url="jdbc:postgresql://localhost:5432/postgres";//"jdbc:postgresql://127.0.0.1:5432/P1";
					String user="postgres";
					String password="password";//"880210";
					conn =DriverManager.getConnection(url, user, password);
					stmt =conn.createStatement();
				
					try{
							conn.setAutoCommit(false);
							// Update precomputation tables
							String updateQuery =
									"SELECT u.id uid,s.id sid,p.id pid,c.id cid,(a.quantity*a.price) total"
									+ " FROM users u"
									+ " JOIN sales a ON u.id=a.uid"
									+ " JOIN products p ON p.id=a.pid"
									+ " JOIN categories c ON p.cid=c.id"
									+ " JOIN states s ON u.state=s.name"
									+ " WHERE a.uid="+userID;
							ResultSet salesUpdates = stmt.executeQuery(updateQuery);
							Statement updater = conn.createStatement();
							while(salesUpdates.next()) {
								int uid = salesUpdates.getInt("uid");	// user id
								int sid = salesUpdates.getInt("sid");	// states id
								int pid = salesUpdates.getInt("pid");	// products id
								int cid = salesUpdates.getInt("cid");	// categories id
								int total = salesUpdates.getInt("total");	// total
								// Update precols
								System.out.println("UPDATING THE PRECOLS");
								try {
									String precols = "UPDATE precols SET subtotal=subtotal+"+total+" WHERE stateid="+sid+" AND productid="+pid;
									updater.executeUpdate(precols);
								} catch(SQLException e) {
									String precols = "INSERT INTO precols(stateid,productid,subtotal) VALUES ("+sid+","+pid+","+total+")";
									updater.executeUpdate(precols);
								}
								// Update prerows
								System.out.println("UPATING THE PREROWS");
								try {
									String prerows = "UPDATE prerows SET subtotal=subtotal+"+total+" WHERE uid="+uid+" AND cid="+cid;
									updater.executeUpdate(prerows);
								} catch(SQLException e) {
									String prerows = "INSERT INTO prerows(uid,cid,subtotal) VALUES ("+uid+","+cid+","+total+")";
									updater.executeUpdate(prerows);
								}
								// Update the Martix
								System.out.println("UPDATING THE PREMATRIX");
								try {
									String themartix = "UPDATE prematrix SET subtotal=subtotal+"+total+" WHERE uid="+uid+" AND pid="+pid;
									updater.executeUpdate(themartix);
								} catch(SQLException e) {
									String themartix = "INSERT INTO prematrix(uid,pid,subtotal) VALUES ("+uid+","+pid+","+total+")";
									updater.executeUpdate(themartix);
								}
							}
							stmt.execute(SQL);
							conn.commit();
							conn.setAutoCommit(true);
							out.println("Dear customer '"+uName+"', Thanks for your purchasing.<br> Your card '"+card+"' has been successfully proved. <br>We will ship the products soon.");
							out.println("<br><font size=\"+2\" color=\"#990033\"> <a href=\"products_browsing.jsp\" target=\"_self\">Continue purchasing</a></font>");
					}
					catch(Exception e)
					{
						out.println(e);
						out.println("Fail! Please try again <a href=\"purchase.jsp\" target=\"_self\">Purchase page</a>.<br><br>");
						
					}
					conn.close();
				}
				catch(Exception e)
				{
						out.println("<font color='#ff0000'>Error.<br><a href=\"purchase.jsp\" target=\"_self\"><i>Go Back to Purchase Page.</i></a></font><br>");
						
				}
			}
			else
			{
			
				out.println("Fail! Please input valid credit card numnber.  <br> Please <a href=\"purchase.jsp\" target=\"_self\">buy it</a> again.");
			}
		}
	catch(Exception e) 
	{ 
		out.println("Fail! Please input valid credit card numnber.  <br> Please <a href=\"purchase.jsp\" target=\"_self\">buy it</a> again.");
	}
%>
	
	</font><br>
</td></tr>
</table>
</div>
</body>
</html>
<%}%>