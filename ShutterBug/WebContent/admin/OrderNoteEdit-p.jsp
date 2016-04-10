<%@ page import="au.com.fundfoto.shutterbug.entities.OrderNote" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderNoteService" %>
<%
long OrderID = 0;
if (request.getParameter("OrderID") != null) {
  OrderID = Long.parseLong(request.getParameter("OrderID"));
}
long OrderNoteID = 0;
if (request.getParameter("OrderNoteID") != null) {
  OrderNoteID = Long.parseLong(request.getParameter("OrderNoteID"));
}
String SessionCode = "";
if (request.getParameter("SessionCode") != null) {
  SessionCode = (String)request.getParameter("SessionCode");
}
String editMode = "";
if (request.getParameter("editMode") != null) {
  editMode = (String)request.getParameter("editMode");
}

OrderNoteService os = new OrderNoteService();
os.setSessionCode(SessionCode);
OrderNote on = os.getOrderNote(OrderNoteID);

on.setOrderID(OrderID);
on.setNoteText((String)request.getParameter("NoteText"));

%>
<html>
<body>
<script>
<% if (on.hasErrors()) { %>
     parent.errorMsg("<%=on.getErrMsg()%>");
<% } else { 
     if (editMode.equals("Delete")) {
       os.deleteOrderNote(on);
     } else {
       os.saveOrderNote(on);
     } %>
     parent.success();     
<% } %>
</script>   
</body>
</html>