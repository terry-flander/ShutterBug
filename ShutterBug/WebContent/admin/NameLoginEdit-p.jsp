<%@ page import="au.com.fundfoto.shutterbug.entities.NameLogin" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
long NameCardID = 0;
if (request.getParameter("NameCardID") != null) {
  NameCardID = Long.parseLong(request.getParameter("NameCardID"));
}
long NameLoginID = 0;
if (request.getParameter("NameLoginID") != null) {
  NameLoginID = Long.parseLong(request.getParameter("NameLoginID"));
}
NameLogin nl = NameLoginService.getNameLogin(NameLoginID);
String editMode = "";
if (request.getParameter("editMode") != null) {
  editMode = (String)request.getParameter("editMode");
}

nl.setNameLoginID(NameLoginID);
nl.setNameCardID(NameCardID);
nl.setLoginID((String)request.getParameter("LoginID"));
nl.setLoginPassword((String)request.getParameter("LoginPassword"));
nl.setStatus((String)request.getParameter("Status"));
nl.setAccessLevel((String)request.getParameter("AccessLevel"));
%>
<html>
<body>
<script>
<% if (nl.hasErrors()) { %>
     parent.errorMsg("<%=nl.getErrMsg()%>");
<% } else { 
  if (editMode.equals("Delete")) {
    NameLoginService.deleteNameLogin(nl);
  } else {
    NameLoginService.saveNameLogin(nl);
  }
%>
     parent.success();     
<% } %>
</script>   
</body>
</html>