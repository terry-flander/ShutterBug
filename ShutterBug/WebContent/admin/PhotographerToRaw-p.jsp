<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%
try {
  long JobCardID = 0;
  if (request.getParameter("JobCardID") != null) {
    JobCardID = Long.parseLong(request.getParameter("JobCardID"));
  }
  boolean doneOnly = (request.getParameter("doneOnly")!=null);
	String processMsg = new JobCardService().copyRenameCameraPictures(JobCardID, doneOnly);
%>
<html>
<body>
<script>
parent.errorMsg("<%=processMsg%>");
</script>   
</body>
</html>
<% 
} catch (Exception e) {
  e.printStackTrace();
}
%>