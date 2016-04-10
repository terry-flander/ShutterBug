<%@ page import="au.com.fundfoto.shutterbug.entities.Order" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderLine" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderLineService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
long OrderID = Long.parseLong((String)request.getParameter("OrderID"));
Order jc = new OrderService().getOrder(OrderID);
%>
<html>
<head>
  <title>Order Lines</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<table>
<tr><td>
<fieldset>
<legend><a href="OrderBrowser.jsp?SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Orders"></a> Order
    <a href="javascript:browseOrderNames('<%=jc.getOrderID()%>')">Names</a>
    <a href="javascript:browseOrderSubjects('<%=jc.getOrderID()%>')">Subjects</a>
    <a href="javascript:browseOrderNotes('<%=jc.getOrderID()%>')">Notes</a>
    <a href="javascript:browseOrderLines('<%=jc.getOrderID()%>')">Lines</a>
    <a href="javascript:browseOrderPayments('<%=jc.getOrderID()%>')">Payments</a></legend>
    <table>
    <caption>OrderLineBrowser</caption>
    <tr><th>&nbsp;</th><th>Order Number</th><th>Order Date</th><th>Order Status</th><th>Bill To Name</th><th>Total Price</th><th>Balance Due</th></tr>
    <tr class="oddRow">
    <td class="evenRow"><a href="javascript:editOrder('<%=jc.getOrderID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Order"></a>&nbsp;
    <a href="javascript:editOrder('<%=jc.getOrderID()%>','Delete')"><img src="../images/delete_icon.jpg" height="20px" title="Delete Order"></a></td>
    <td><%=jc.getOrderNumber()%></td>
    <td><%=jc.getOrderDate()%></td>
    <td><%=jc.getOrderStatus()%></td>
    <td><%=jc.getBillToName()%></td>
    <td align="right"><%=jc.getTotalPrice()%></td>
    <td align="right"><%=jc.getBalanceDue()%></td>
    </tr>
    </table>
</fieldset>
</td></tr>
<tr><td class="messageBox" id="message" colspan="2"></td></tr>
<tr><td>
<fieldset>
<legend>OrderLines <a href="javascript:editOrderLine('0','Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Ordr Line"></a></legend>
  <table>
  <tr><th>&nbsp;</th><th>&nbsp;</th><th>Product</th><th>Options</th><th>Quantity</th><th>Cost</th><th>Price</th><th>Extended Price</th></tr>
<%
OrderLine[] jss = new OrderLineService().getOrderLineList(OrderID);
boolean odd = true;
for (int i=0;i<jss.length;i++) {
  OrderLine js = jss[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td class="evenRow"><a href="javascript:editOrderLine('<%=js.getOrderLineID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Order Line"></a></td>
  <td class="evenRow"><a href="javascript:editOrderLine('<%=js.getOrderLineID()%>','Delete')"><img src="../images/delete_icon.jpg" height="20px" title="Delete Order Line"></a></td>
  <td><%=js.getProductDesc()%></td>
  <td><%=js.getOptionList()%></td>
  <td align="right"><%=js.getQuantity()%></td>
  <td align="right"><%=js.getCost()%></td>
  <td align="right"><%=js.getPrice()%></td>
  <td align="right"><%=js.getExtendedPrice()%></td>
  </tr>
<% 
} %>
</table>
</fieldset>
</td></tr>
</table>
<iframe name="hiddenFrame" id='hiddenFrame' class="hiddenFrame"></iframe>
<script>
function editOrder(ID,editMode) {
  var url = "OrderEdit-g.jsp?editMode="+editMode+"&OrderLineID="+ID+"&OrderID=<%=OrderID%>";
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
function editOrderLine(ID,editMode) {
  var url = "OrderLineEdit-g.jsp?OrderLineID="+ID+"&OrderID=<%=OrderID%>&editMode="+editMode;
  var name = "Order Line Edit";
  openWindow(url,name);
}
</script>
</body>
</html>

