<%@ page import="au.com.fundfoto.shutterbug.entities.ReportParameter" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportParameterService" %>

<%
try {
long ParameterID = 0;
if (request.getParameter("ParameterID") != null) {
  ParameterID = Long.parseLong(request.getParameter("ParameterID"));
}
String editMode = "";
if (request.getParameter("editMode") != null) {
  editMode = (String)request.getParameter("editMode");
}

ReportParameter rp = new ReportParameterService().getReportParameter(ParameterID);

rp.setReportID(Long.parseLong((String)request.getParameter("ReportID")));
rp.setParameterID(Long.parseLong((String)request.getParameter("ParameterID")));
rp.setOrder((String)request.getParameter("Order"));
rp.setDescription((String)request.getParameter("Description"));
rp.setCode((String)request.getParameter("Code"));
rp.setDataType((String)request.getParameter("DataType"));
rp.setValidation((String)request.getParameter("Validation"));

%>
<html>
<body>
<script>
<% if (rp.hasErrors()) { 
%>
     parent.errorMsg("<%=rp.getErrMsg()%>");
<% } else {
	   if (editMode.equals("Delete")) {
       new ReportParameterService().deleteReportParameter(rp);
	   } else {
       new ReportParameterService().saveReportParameter(rp);
	   }
%>
     parent.success();
<% } %>

</script>   
</body>
</html>
<% } catch (Exception e) {
     e.printStackTrace();
   }
%>