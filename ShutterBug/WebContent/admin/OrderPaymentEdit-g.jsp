<%@ page import="au.com.fundfoto.shutterbug.entities.OrderPayment" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderPaymentService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>

<%
  long OrderID = 0;  
  if (request.getParameter("OrderID") != null) {
    OrderID = Long.parseLong(request.getParameter("OrderID"));
  }
  long PaymentID = 0;  
  if (request.getParameter("PaymentID") != null) {
    PaymentID = Long.parseLong(request.getParameter("PaymentID"));
  }
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
    editMode = (String)request.getParameter("editMode");
  }
  OrderPayment os = new OrderPaymentService().getOrderPayment(PaymentID);
%>

<html>
<head>
  <title>Order Payment <%=editMode%></title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:300px;">
<form name="OrderPaymentEdit" id="OrderPaymentEdit" action="OrderPaymentEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr>
  <td>
  <fieldset>
  <legend><%=editMode%> Order Payment</legend>
  <table>
  <tr><td colspan="2" class="messageBox" id="message"></td></tr>
  <tr><td class="inputLabel">Payment ID : </td><td class="inputField"><%=(os.getPaymentID()==0?"New":os.getPaymentID())%></td></tr>
  <tr><td class="inputLabel">Payment Date : </td><td class="inputField"><input type="text" name="PaymentDate" value="<%=os.getPaymentDate()%>"></td></tr>
  <tr><td class="inputLabel">Type : </td><td class="inputField"> <select name="Type" id="Type"><%=OptionService.getHTMLOptionList("OrderPaymentType")%></select></td></tr>
  <tr><td class="inputLabel">Amount : </td><td class="inputField"><input type="text" name="Amount" value="<%=os.getAmount()%>"></td></tr>
  <tr><td class="inputLabel">Note : </td><td class="inputField"><input type="text" name="Note" value="<%=os.getNote()%>"></td></tr>
  </table>
  </fieldset>
  </td>
</tr>
<tr>
  <td>
    <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
    <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
    <input type="hidden" name="OrderID" value="<%=OrderID%>">
    <input type="hidden" name="PaymentID" value="<%=os.getPaymentID()%>">    
    <input type="hidden" name="editMode" value="<%=editMode%>">    
  </td>
</tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>

<script>
windowResize();
setFocus("PaymentDate");
</script>
</body>
</html>
