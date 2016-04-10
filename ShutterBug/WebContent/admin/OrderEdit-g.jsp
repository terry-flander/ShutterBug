<%@ page import="au.com.fundfoto.shutterbug.entities.Order" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>

<%
  long OrderID = 0;  
  if (request.getParameter("OrderID") != null) {
     OrderID = Long.parseLong(request.getParameter("OrderID"));
  }
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
     editMode = request.getParameter("editMode");
  }
  Order or = new OrderService().getOrder(OrderID);
%>

<html>
<head>
  <title>Order Edit</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:400px;">
<form name="OrderEdit" id="OrderEdit" action="OrderEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr>
  <td>
    <fieldset>
    <legend><%=editMode%> Order</legend>
    <table>
    <tr><td class="messageBox" colspan="2" id="message"></td></tr>
    <tr><td class="inputLabel">OrderID : </td><td class="inputField"><%=(or.getOrderID()==0?"New":or.getOrderID())%></td></tr>
    <tr><td class="inputLabel">Order Number : </td><td class="inputField"><input type="text" name="OrderNumber" id="OrderNumber" value="<%=or.getOrderNumber()%>"></td></tr>
    <tr><td class="inputLabel">Order Date : </td><td class="inputField"><input type="text" name="OrderDate" value="<%=or.getOrderDate()%>"></td></tr>
    <tr><td class="inputLabel">OrderStatus : </td><td class="inputField">  <select name="OrderStatus" id="OrderStatus"><option value="">-choose-</option><%=OptionService.getHTMLOptionList("OrderStatus")%></select>&nbsp;</td></tr>
    <tr><td class="inputLabel">Bill To : </td><td class="inputField"><div id=BillToName><%=or.getBillToName()%></div></td></tr>
		<tr><td class="inputLabel">Relation Name : </td><td> <a href="javascript:chooseName()">Choose</a>&nbsp;<a href="javascript:editNameCard(0)">New</a></td></tr>
    <tr><td class="inputLabel">Total Price : </td><td class="inputField"><input type="text" name="TotalPrice" value="<%=or.getTotalPrice()%>"></td></tr>
    <tr><td class="inputLabel">Balance Due : </td><td class="inputField"><input type="text" name="BalanceDue" value="<%=or.getBalanceDue()%>"></td></tr>
    </table>
    </fieldset>
  </td>
</tr>
<tr>
  <td>
    <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
    <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
    <input type="hidden" name="OrderID" value="<%=or.getOrderID()%>">
    <input type="hidden" name="NameCardID" id="NameCardID" value="<%=or.getNameCardID()%>">    
    <input type="hidden" name="editMode" value="<%=editMode%>">
  </td>
</tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>

<script>
function chooseName() {
  var url = "NameCardSelect.jsp";
  var name = "Bill To Name Select";
  openWindow(url, name);
}
function editNameCard(ID) {
  var url = "NameCardEdit-g.jsp?NameCardID="+ID+"&setName=true";
  var name = "Name Card Edit";
  openWindow(url,name);
}
function setNameCardID(ID, Name) {
  var f = document.getElementById("BillToName");
  f.innerHTML = Name;
  f = document.getElementById("NameCardID");
  f.value = ID;
}
setSelect("OrderStatus","<%=or.getOrderStatus()%>");
windowResize();
setFocus("OrderNumber");
</script>
</body>
</html>

