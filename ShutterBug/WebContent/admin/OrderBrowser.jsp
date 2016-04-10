<%@ page import="au.com.fundfoto.shutterbug.entities.Order" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = request.getParameter("SessionCode"); 
if (!NameLoginService.accessOK(SessionCode)) {
   response.sendRedirect("../login.html");
}
String OrderFilter = "";  
if (request.getParameter("OrderFilter") != null) {
   OrderFilter = (String)request.getParameter("OrderFilter");
}
String OrderStatus = "New";  
if (request.getParameter("OrderStatus") != null) {
   OrderStatus = (String)request.getParameter("OrderStatus");
}
%>
<html>
<head>
  <title>Orders</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
  <form action="OrderBrowser.jsp" id="searchNames" method="post">
  <table><tr><td style="border:none;">
  <fieldset>
  <legend>Orders <a href="javascript:editOrder(0,'Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Order"></a>&nbsp;Filter:&nbsp;
  <input type="text" name="OrderFilter" id="OrderFilter" value="<%=OrderFilter%>">&nbsp;Status:&nbsp;
  <select name="OrderStatus" id="OrderStatus"><option value="">ALL</option><%=OptionService.getHTMLOptionList("OrderStatus")%></select>&nbsp;
  <a href="javascript:doSearch()"><img src="../images/search_icon.jpg" height="20px" title="Search for Orders"></a>
  </legend>
  <table>
  <caption>OrderBrowser</caption>
  <tr><th>&nbsp;</th><th>Order Number</th><th>Order Date</th><th>Order Status</th><th>Bill To Name</th><th>Total Price</th><th>Balance Due</th></tr>
<%
Order[] orders = null;
if (OrderFilter.length()>0 || OrderStatus.length()>0) {
  OrderService os = new OrderService();
  os.setOrderFilter(OrderFilter, OrderStatus);
	orders = os.getOrderList();
	
	boolean odd = true;
	for (int i=0;i<orders.length;i++) {
	  Order or = orders[i]; 
	  String rowClass = (odd?"oddRow":"evenRow");
	  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td><a href="javascript:browseOrderLines('<%=or.getOrderID()%>')"><img src="../images/choose_icon.jpg" height="20px" title="Choose"></a></td>
  <td><%=or.getOrderNumber()%></td>
  <td><%=or.getOrderDate()%></td>
  <td><%=or.getOrderStatus()%></td>
  <td><%=or.getBillToName()%></td>
  <td align="right"><%=or.getTotalPrice()%></td>
  <td align="right"><%=or.getBalanceDue()%></td>
  </tr>
<% 
	}
} %>
  </table>
  </fieldset>
  <input type="hidden" name="SessionCode" value="<%=SessionCode%>">
  </td></tr>
</table>
</form>
<script>
function doSearch() {
	  parent.setOrderFilter(document.getElementById("OrderFilter").value,document.getElementById("OrderStatus").value);
	  var f = document.getElementById("searchNames");
	  f.submit();
	}
function editOrder(ID,editMode) {
  var url = "OrderEdit-g.jsp?OrderID="+ID+"&editMode="+editMode;
  var name = "Order Edit";
  openWindow(url,name);
}
function browseOrderLines(ID) {
  location.href = "OrderLineBrowser.jsp?OrderID="+ID+"&SessionCode=<%=SessionCode%>";
}
setSelect("OrderStatus",'<%=OrderStatus%>');
</script>
</body>
</html>

