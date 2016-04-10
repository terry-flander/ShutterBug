<%@ page import="au.com.fundfoto.shutterbug.entities.OrderSubject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderSubjectService" %>
<%
try {
long OrderID = 0;
if (request.getParameter("OrderID") != null) {
  OrderID = Long.parseLong(request.getParameter("OrderID"));
}
int OrderSubjectID = 0;
if (request.getParameter("OrderSubjectID") != null) {
  OrderSubjectID = Integer.parseInt(request.getParameter("OrderSubjectID"));
}
String editMode = "";
if (request.getParameter("editMode") != null) {
  editMode = (String)request.getParameter("editMode");
}
boolean mergeOrders = request.getParameter("MergeOrders")!=null;

OrderSubject os = new OrderSubjectService().getOrderSubject(OrderSubjectID);

os.setOrderID(OrderID);
os.setOrderSubjectID(OrderSubjectID);
os.setSubjectID((String)request.getParameter("SubjectID"));

%>
<html>
<body>
<script>
<% if (os.hasErrors()) { 
%>
     parent.errorMsg("<%=os.getErrMsg()%>");
<% } else {
	   if (editMode.equals("Delete")) {
       new OrderSubjectService().deleteOrderSubject(os);
	   } else {
       new OrderSubjectService().saveOrderSubject(os, mergeOrders);
	   }
%>
     parent.success();
<% } %>

</script>   
</body>
</html>
<% } catch (Exception e) {
     e.printStackTrace();
   }
%>