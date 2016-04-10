<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%
try {
  long JobCardID = 0;
  if (request.getParameter("JobCardID") != null) {
    JobCardID = Long.parseLong(request.getParameter("JobCardID"));
  }
  boolean mountOnly = (request.getParameter("mountOnly")!=null);
	String processMsg = new JobCardService().createOrders(JobCardID, mountOnly);
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