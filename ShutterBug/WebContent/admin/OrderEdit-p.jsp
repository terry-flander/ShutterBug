<%@ page import="au.com.fundfoto.shutterbug.entities.Order" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderService" %>
<%
long OrderID = 0;
if (request.getParameter("OrderID") != null) {
  OrderID = Long.parseLong(request.getParameter("OrderID"));
}

String editMode = "";
if (request.getParameter("editMode") != null) {
  editMode = (String)request.getParameter("editMode");
}

OrderService os = new OrderService();
Order or = os.getOrder(OrderID);

or.setOrderNumber((String)request.getParameter("OrderNumber"));
or.setOrderDate((String)request.getParameter("OrderDate"));
or.setOrderStatus((String)request.getParameter("OrderStatus"));
or.setNameCardID((String)request.getParameter("NameCardID"));
or.setTotalPrice((String)request.getParameter("TotalPrice"));
or.setBalanceDue((String)request.getParameter("BalanceDue"));

%>
<html>
<body>
<script>
<% if (or.hasErrors()) { %>
   parent.errorMsg("<%=or.getErrMsg()%>");
<% } else {
     boolean ok = false;
     if (editMode.equals("Delete")) {
       ok = os.deleteOrder(or);
     } else {
       ok = os.saveOrder(or);
     }
     if (!ok) {
%>
       parent.errorMsg("<%=os.getErrMsg()%>");
<%   } else { %>
       parent.success();
<%   } 
  } %>
</script>   
</body>
</html>