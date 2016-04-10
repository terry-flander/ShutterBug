<%@ page import="au.com.fundfoto.shutterbug.entities.JobPhotographer" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobPhotographerService" %>

<%
try {
long JobPhotographerID = 0;
if (request.getParameter("JobPhotographerID") != null) {
  JobPhotographerID = Long.parseLong(request.getParameter("JobPhotographerID"));
}
String editMode = "";
if (request.getParameter("editMode") != null) {
  editMode = (String)request.getParameter("editMode");
}

JobPhotographer jp = new JobPhotographerService().getJobPhotographer(JobPhotographerID);
jp.clearErrors();
jp.setJobCardID(Long.parseLong((String)request.getParameter("JobCardID")));
jp.setNameCardID(Long.parseLong((String)request.getParameter("NameCardID")));
jp.setDirectory((String)request.getParameter("Directory"));
jp.setFormat((String)request.getParameter("Format"));
if (!editMode.equals("Delete") && new JobPhotographerService().duplicateCheck(jp)) {
  jp.addErrMsg("Photographer Directory for this Job already exists.");
}

%>
<html>
<body>
<script>
<% if (jp.hasErrors()) { 
%>
     parent.errorMsg("<%=jp.getErrMsg()%>");
<% } else {
	   if (editMode.equals("Delete")) {
       new JobPhotographerService().deleteJobPhotographer(jp);
	   } else {
       new JobPhotographerService().saveJobPhotographer(jp);
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