<%@ page import="au.com.fundfoto.shutterbug.entities.Selection" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SelectionService" %>
<%
long SelectionID = 0;
if (request.getParameter("SelectionID") != null) {
  SelectionID = Long.parseLong(request.getParameter("SelectionID"));
}

Selection se = new SelectionService().getSelection(SelectionID);

se.setSelectionCode((String)request.getParameter("SelectionCode"));
se.setDescription((String)request.getParameter("Description"));

%>
<html>
<body>
<script>
<% if (se.hasErrors()) { %>
     parent.errorMsg("<%=se.getErrMsg()%>");
<% } else { 
     new SelectionService().saveSelection(se);
%>
     parent.success();
<% } %>
</script>   
</body>
</html>