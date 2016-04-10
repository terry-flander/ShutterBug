<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%
try {
  long JobCardID = 0;
  if (request.getParameter("JobCardID") != null) {
    JobCardID = Long.parseLong(request.getParameter("JobCardID"));
  }
  boolean ok = new JobCardService().moveMountShotsBetweenJpgAndWorking(JobCardID, false);
	
%>
<html>
<body>
<script>
<% if (!ok) { 
%>
     parent.errorMsg("Could not move Mount Shots. See log for errors.");
<% } else {
%>
     parent.jobSuccess();
<% } %>

</script>   
</body>
</html>
<% 
} catch (Exception e) {
  e.printStackTrace();
}
%>