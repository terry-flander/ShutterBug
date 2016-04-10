<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%
try {
  long JobCardID = 0;
  if (request.getParameter("JobCardID") != null) {
    JobCardID = Long.parseLong(request.getParameter("JobCardID"));
  }
	String processMsg = new JobCardService().createNewShots(JobCardID);
	%>
<html>
<body>
<script>
parent.errorMsg('<%=processMsg%>');
</script>   
</body>
</html>
<% 
} catch (Exception e) {
  e.printStackTrace();
}
%>