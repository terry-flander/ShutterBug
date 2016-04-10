<%@ page import="au.com.fundfoto.shutterbug.entities.Report" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportService" %>
<%
long ReportID = 0;
if (request.getParameter("ReportID") != null) {
  ReportID = Long.parseLong(request.getParameter("ReportID"));
}

Report re = new ReportService().getReport(ReportID);

re.setTitle((String)request.getParameter("Title"));
re.setDescription((String)request.getParameter("Description"));
re.setJasperFile((String)request.getParameter("JasperFile"));
re.setComments((String)request.getParameter("Comments"));

%>
<html>
<body>
<script>
<% if (re.hasErrors()) { %>
     parent.errorMsg("<%=re.getErrMsg()%>");
<% } else { 
     new ReportService().saveReport(re);
%>
     parent.success();
<% } %>
</script>   
</body>
</html>