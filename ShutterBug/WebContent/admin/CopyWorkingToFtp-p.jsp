<%@ page import="au.com.fundfoto.shutterbug.entities.JobCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.Option" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>
<%@ page import="au.com.fundfoto.shutterbug.util.StringUtil" %>
<%@ page import="java.io.File" %>
<%
try {
  long JobCardID = 0;
  if (request.getParameter("JobCardID") != null) {
    JobCardID = Long.parseLong(request.getParameter("JobCardID"));
  }
  boolean ok = new JobCardService().copyWorkingToFtp(JobCardID);
%>
<html>
<body>
<script>
<% if (!ok) { 
	%>
	     parent.errorMsg("Could not move Working Shots. See log for errors.");
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