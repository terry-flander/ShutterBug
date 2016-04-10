<%@ page import="au.com.fundfoto.shutterbug.entities.JobCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%
long JobCardID = 0;
if (request.getParameter("JobCardID") != null) {
  JobCardID = Long.parseLong(request.getParameter("JobCardID"));
}

JobCard jc = new JobCardService().getJobCard(JobCardID);

jc.setName((String)request.getParameter("Name"));
jc.setCode((String)request.getParameter("Code"));
jc.setDescription((String)request.getParameter("Description"));
jc.setType((String)request.getParameter("Type"));
jc.setJobDate((String)request.getParameter("Date"));
jc.setStartTime((String)request.getParameter("StartTime"));
jc.setEndTime((String)request.getParameter("EndTime"));
jc.setBaseDirectory((String)request.getParameter("BaseDirectory"));

%>
<html>
<body>
<script>
<% if (jc.hasErrors()) { %>
     parent.errorMsg("<%=jc.getErrMsg()%>");
<% } else { 
     new JobCardService().saveJobCard(jc);
     if (jc.hasErrors()) { %>
       parent.errorMsg("<%=jc.getErrMsg()%>");
<%   } else { %>
       parent.success();
<%   }
   } %>
</script>   
</body>
</html>