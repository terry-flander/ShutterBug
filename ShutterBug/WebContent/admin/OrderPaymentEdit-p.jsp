<%@ page import="au.com.fundfoto.shutterbug.entities.OrderPayment" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderPaymentService" %>
<%
long PaymentID = 0;
if (request.getParameter("PaymentID") != null) {
  PaymentID = Long.parseLong(request.getParameter("PaymentID"));
}
long OrderID = 0;
if (request.getParameter("OrderID") != null) {
  OrderID = Long.parseLong(request.getParameter("OrderID"));
}

OrderPaymentService ops = new OrderPaymentService();
OrderPayment op = ops.getOrderPayment(PaymentID);

op.setOrderID(OrderID);
op.setPaymentDate((String)request.getParameter("PaymentDate"));
op.setType((String)request.getParameter("Type"));
op.setAmount((String)request.getParameter("Amount"));
op.setNote((String)request.getParameter("Note"));

%>
<html>
<body>
<script>
<% if (op.hasErrors()) { %>
   parent.errorMsg("<%=op.getErrMsg()%>");
<% } else { 
   boolean ok = ops.saveOrderPayment(op);
   if (!ok) {
%>
     parent.errorMsg("<%=op.getErrMsg()%>");
<% } else { %>   
     parent.success();     
<% } 
} %>
</script>   
</body>
</html>