<%@ page import="au.com.fundfoto.shutterbug.entities.Order" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderPayment" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderPaymentService" %>
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
    <caption>OrderPaymentBrowser</caption>
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
  <legend>Payments <a href="javascript:editOrderPayment(0,'Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Payment"></a></legend>
  <table>
  <tr><th>&nbsp;</th><th>&nbsp;</th><th>Date</th><th>Type</th><th>Amount</th><th>Note</th></tr>
<%
OrderPayment[] oss = new OrderPaymentService().getOrderPaymentList(OrderID);
boolean odd = true;
for (int i=0;i<oss.length;i++) {
  OrderPayment os = oss[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td class="evenRow"><a href="javascript:editOrderPayment('<%=os.getPaymentID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Payment"></a></td>
  <td class="evenRow"><a href="javascript:editOrderPayment('<%=os.getPaymentID()%>','Delete')"><img src="../images/delete_icon.jpg" height="20px" title="Delete Payment"></a></td>
  <td><%=os.getPaymentDate()%></td>
  <td><%=os.getType()%></td>
  <td><%=os.getAmount()%></td>
  <td><%=os.getNote()%></td>
  </tr>
<%
} %>
  </table>
  </fieldset>
  </td>
</tr>
</table>
<script>
function editOrderPayment(ID, editMode) {
	var url = "OrderPaymentEdit-g.jsp?editMode="+editMode+"&OrderID=<%=OrderID%>&PaymentID="+ID;
	var name = "Order Payment Edit";
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

