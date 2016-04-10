<%@ page import="au.com.fundfoto.shutterbug.entities.Order" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameRelation" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameRelationService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
long OrderID = Long.parseLong((String)request.getParameter("OrderID"));
Order jc = new OrderService().getOrder(OrderID);
%>
<html>
<head>
  <title>Order Relations</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<table>
<tr>
  <td>
<fieldset>
<legend><a href="OrderBrowser.jsp?SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Orders"></a> Order
    <a href="javascript:browseOrderNames('<%=jc.getOrderID()%>')">Names</a>
    <a href="javascript:browseOrderSubjects('<%=jc.getOrderID()%>')">Subjects</a>
    <a href="javascript:browseOrderNotes('<%=jc.getOrderID()%>')">Notes</a>
    <a href="javascript:browseOrderLines('<%=jc.getOrderID()%>')">Lines</a>
    <a href="javascript:browseOrderPayments('<%=jc.getOrderID()%>')">Payments</a></legend>
    <table>
    <caption>OrderRelationBrowser</caption>
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
  </td>
</tr>
</table>
<table>
<tr>
  <td>
  <fieldset>
  <legend>Names <a href="javascript:editRelation(0,'Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Name"></a></legend>
  <table>
  <tr><th>&nbsp;</th><th>&nbsp;</th><th>Name</th><th>Type</th></tr>
<%
NameRelation[] nrs = new NameRelationService().getNameRelationList(NameRelation.ORDER_TYPE, OrderID);
boolean odd = true;
for (int i=0;i<nrs.length;i++) {
  NameRelation nr = nrs[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td class="evenRow"><a href="javascript:editName('<%=nr.getChildID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Name"></a></td>
  <td class="evenRow"><a href="javascript:editRelation('<%=nr.getRelationID()%>','Delete')"><img src="../images/delete_icon.jpg" height="20px" title="Delete Name"></a></td>
  <td><%=nr.getChildName()%></td>
  <td><%=nr.getRelationType()%></td>
  </tr>
<%
} %>
  </table>
  </fieldset>
  </td>
</tr>
</table>
<script>
function editRelation(ID, editMode) {
	var url = "NameRelationEdit-g.jsp?editMode="+editMode+"&RelationID="+ID+"&ParentType="+<%=NameRelation.ORDER_TYPE%>+"&ParentID="+<%=OrderID%>;
	var name = "Name Relation Edit";
	openWindow(url,name);
}
function editOrder(ID,editMode) {
  var url = "OrderEdit-g.jsp?OrderID="+ID+"&editMode="+editMode;
  var name = "Order Edit";
  openWindow(url,name);
}
function editName(ID,editMode) {
  var url = "NameCardEdit-g.jsp?editMode="+editMode+"&NameCardID="+ID;
  var name = "Name Relation Edit";
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

