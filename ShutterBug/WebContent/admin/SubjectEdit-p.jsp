<%@ page import="au.com.fundfoto.shutterbug.entities.Subject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SubjectService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCardService" %>
<%
try {
	long SubjectID = 0;
	if (request.getParameter("SubjectID") != null) {
	  SubjectID = Long.parseLong(request.getParameter("SubjectID"));
	}
	String editMode = "";
	if (request.getParameter("editMode") != null) {
	  editMode = (String)request.getParameter("editMode");
	}
	String deleteSuccess = "SessionSubjectBrowser.jsp";
	if (editMode.equals("Delete")) {
		deleteSuccess += "?SessionCode="+(String)request.getParameter("SessionCode")+"&JobCardID="+(String)request.getParameter("JobCardID")+"&JobSessionID="+(String)request.getParameter("SessionID");
	}
	 
	Subject su = new SubjectService().getSubject(SubjectID);
	
	su.setSubjectID(Long.parseLong((String)request.getParameter("SubjectID")));
	su.setSessionID(Long.parseLong((String)request.getParameter("SessionID")));
	su.setSubjectCode((String)request.getParameter("SubjectCode"));
	su.setNameCardID(Long.parseLong((String)request.getParameter("NameCardID")));
	su.setPhotographerID(Long.parseLong((String)request.getParameter("PhotographerID")));
	su.setFirstShot((String)request.getParameter("FirstShot"));
	su.setLastShot((String)request.getParameter("LastShot"));
	su.setMountShotID((String)request.getParameter("Mount"));
	su.setStatus((String)request.getParameter("Status"));
	su.setNote((String)request.getParameter("Note"));

%>
<html>
<body>
<script>
<% if (su.hasErrors()) { 
%>
     parent.errorMsg("<%=su.getErrMsg()%>");
<% } else {
	   if (editMode.equals("Delete")) {
       new SubjectService().deleteSubject(su);
	   } else {
       new SubjectService().saveSubject(su);
	   }
%>
		 if ('<%=editMode%>'=='Delete') {
			 <% if (su.hasErrors()) { %>
			parent.errorMsg("<%=su.getErrMsg()%>");
			 <% } else { %>
		  parent.deleteSuccess('<%=deleteSuccess%>');
		   <% } %>
		 } else if ('<%=editMode%>'!='Add') {
		   parent.success();
		 } else {
		   parent.reset("FirstSubjectName","")
		 }
<% } %>

</script>   
</body>
</html>
<% } catch (Exception e) {
     e.printStackTrace();
   }
%>