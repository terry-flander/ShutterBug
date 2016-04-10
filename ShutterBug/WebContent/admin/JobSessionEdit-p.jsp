<%@ page import="au.com.fundfoto.shutterbug.entities.JobSession" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobSessionService" %>
<%
long SessionID = 0;
if (request.getParameter("SessionID") != null) {
  SessionID = Long.parseLong(request.getParameter("SessionID"));
}

JobSession js = new JobSessionService().getJobSession(SessionID);

js.setJobCardID(Long.parseLong((String)request.getParameter("JobCardID")));
js.setName((String)request.getParameter("Name"));
js.setCode((String)request.getParameter("Code"));
js.setDescription((String)request.getParameter("Description"));
js.setSessionDate((String)request.getParameter("Date"));
js.setStartTime((String)request.getParameter("StartTime"));
js.setEndTime((String)request.getParameter("EndTime"));

%>
<html>
<body>
<script>
<% if (js.hasErrors()) { %>
     parent.errorMsg("<%=js.getErrMsg()%>");
<% } else { 
     new JobSessionService().saveJobSession(js);
%>
     parent.success();
<% } %>
</script>   
</body>
</html>