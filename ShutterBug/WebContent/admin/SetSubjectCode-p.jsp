<%@ page import="au.com.fundfoto.shutterbug.entities.Subject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SubjectService" %>
<%
try {
  long SessionID = 0;
  if (request.getParameter("SessionID") != null) {
    SessionID = Long.parseLong(request.getParameter("SessionID"));
  }
	String msg = new SubjectService().setSubjectCode(SessionID);
	
%>
<html>
<body>
<script>
<% if (msg!=null) { 
%>
     parent.errorMsg("Could not set. See log for errors.");
<% } else {
%>
     parent.processSuccess();
<% } %>

</script>   
</body>
</html>
<% 
} catch (Exception e) {
  e.printStackTrace();
}
%>