<%@ page import="au.com.fundfoto.shutterbug.entities.Order" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderSubject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderSubjectService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
long OrderID = Long.parseLong((String)request.getParameter("OrderID"));
Order or = new OrderService().getOrder(OrderID);
%>
<html>
<head>
  <title>Order Subjects</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<table>
<tr>
  <td>
<fieldset>
<legend><a href="OrderBrowser.jsp?SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Orders"></a> Order
    <a href="javascript:browseOrderNames('<%=or.getOrderID()%>')">Names</a>
    <a href="javascript:browseOrderSubjects('<%=or.getOrderID()%>')">Subjects</a>
    <a href="javascript:browseOrderNotes('<%=or.getOrderID()%>')">Notes</a>
    <a href="javascript:browseOrderLines('<%=or.getOrderID()%>')">Lines</a>
    <a href="javascript:browseOrderPayments('<%=or.getOrderID()%>')">Payments</a></legend>
    <table>
    <caption>OrderSubjectBrowser</caption>
    <tr><th>&nbsp;</th><th>Order Number</th><th>Order Date</th><th>Order Status</th><th>Bill To Name</th><th>Total Price</th><th>Balance Due</th></tr>
    <tr class="oddRow">
    <td class="evenRow"><a href="javascript:editOrder('<%=or.getOrderID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Order"></a></td>
    <td><%=or.getOrderNumber()%></td>
    <td><%=or.getOrderDate()%></td>
    <td><%=or.getOrderStatus()%></td>
    <td><%=or.getBillToName()%></td>
    <td align="right"><%=or.getTotalPrice()%></td>
    <td align="right"><%=or.getBalanceDue()%></td>
    </tr>
    </table>
</fieldset>
  </td>
</tr>
</table>
<table>
<tr>
  <td>
  <fieldset>
  <legend>Subjects <a href="javascript:editOrderSubject(0,'Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Subject"></a></legend>
  <table>
  <tr><th>&nbsp;</th><th>&nbsp;</th><th>Subject Code</th><th>Subject Name</th></tr>
<%
OrderSubject[] oss = new OrderSubjectService().getOrderSubjectList(OrderID);
boolean odd = true;
for (int i=0;i<oss.length;i++) {
  OrderSubject os = oss[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td class="evenRow"><a href="javascript:editOrderSubject('<%=os.getOrderSubjectID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Subject"></a></td>
  <td class="evenRow"><a href="javascript:editOrderSubject('<%=os.getOrderSubjectID()%>','Delete')"><img src="../images/delete_icon.jpg" height="20px" title="Delete Subject"></a></td>
  <td><%=os.getSubjectCode()%></td>
  <td><%=os.getSubjectName()%></td>
  </tr>
<%
} %>
  </table>
  </fieldset>
  </td>
</tr>
</table>
<script>
function editOrderSubject(ID, editMode) {
	var url = "OrderSubjectEdit-g.jsp?editMode="+editMode+"&OrderID=<%=OrderID%>&OrderSubjectID="+ID;
	var name = "Order Subject Edit";
	openWindow(url,name);
}
function editOrder(ID,editMode) {
  var url = "OrderEdit-g.jsp?OrderID="+ID+"&editMode="+editMode;
  var name = "Order Edit";
  openWindow(url,name);
}
function browseOrderNames(ID) {
  location.href = "OrderRelationBrowser.jsp?OrderID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseOrderSubjects(ID) {
	  location.href = "OrderSubjectBrowser.jsp?OrderID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseOrderNotes(ID) {
  location.href = "OrderNoteBrowser.jsp?OrderID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseOrderLines(ID) {
  location.href = "OrderLineBrowser.jsp?OrderID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseOrderPayments(ID) {
  location.href = "OrderPaymentBrowser.jsp?OrderID="+ID+"&SessionCode=<%=SessionCode%>";
}
</script>
</body>
</html>

