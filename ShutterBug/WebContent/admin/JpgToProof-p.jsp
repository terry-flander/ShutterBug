<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%
try {
  long JobCardID = 0;
  if (request.getParameter("JobCardID") != null) {
    JobCardID = Long.parseLong(request.getParameter("JobCardID"));
  }
	boolean ok = new JobCardService().moveProofToSubjects(JobCardID);
	%>
<html>
<body>
<script>
<% if (!ok) { 
%>
     parent.errorMsg("Could not copy Shots from JPG to PROOF. See log for errors.");
<% } else {
%>
     parent.success();
<% } %>

</script>   
</body>
</html>
<% 
} catch (Exception e) {
  e.printStackTrace();
}
%>