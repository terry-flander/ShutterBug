<%@ page import="au.com.fundfoto.shutterbug.entities.Order" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderNote" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderNoteService" %>
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
    <caption>OrderNoteBrowser</caption>
    <tr><th>&nbsp;</th><th>Order Number</th><th>Order Date</th><th>Order Status</th><th>Bill To Name</th><th>Total Price</th><th>Balance Due</th></tr>
    <tr class="oddRow">
    <td class="evenRow"><a href="javascript:editOrder('<%=jc.getOrderID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Order"></a></td>
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
<legend>OrderNotes <a href="javascript:editOrderNote('0','Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Order Note"></a></legend>
  <table>
  <tr><th>&nbsp;</th><th>&nbsp;</th><th>Text</th><th>Date</th><th>User</th></tr>
<%
OrderNote[] jss = new OrderNoteService().getOrderNoteList(OrderID);
boolean odd = true;
for (int i=0;i<jss.length;i++) {
  OrderNote js = jss[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td class="evenRow"><a href="javascript:editOrderNote('<%=js.getOrderNoteID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Order Note"></a></td>
  <td class="evenRow"><a href="javascript:editOrderNote('<%=js.getOrderNoteID()%>','Delete')"><img src="../images/delete_icon.jpg" height="20px" title="Delete Order Note"></a></td>
  <td><%=js.getNoteText()%></td>
  <td><%=js.getNoteDate()%></td>
  <td><%=js.getNoteName()%></td>
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
  var url = "OrderEdit-g.jsp?OrderID="+ID+"&editMode="+editMode+"&SessionCode=<%=SessionCode%>";
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
function editOrderNote(ID, editMode) {
  var url = "OrderNoteEdit-g.jsp?OrderNoteID="+ID+"&OrderID=<%=OrderID%>&SessionCode=<%=SessionCode%>&editMode="+editMode;
  var name = "Order Note Edit";
  openWindow(url,name);
}
</script>
</body>
</html>

