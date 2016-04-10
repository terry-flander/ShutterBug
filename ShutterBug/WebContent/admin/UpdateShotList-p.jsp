<%@ page import="au.com.fundfoto.shutterbug.entities.Subject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SubjectService" %>
<%
try {
  long JobSessionID = 0;  
  if (request.getParameter("JobSessionID") != null) {
    JobSessionID = Long.parseLong(request.getParameter("JobSessionID"));
  }
  Subject[] sus = new SubjectService().getSubjectList(JobSessionID);
  SubjectService ss = new SubjectService();
  StringBuffer errMess = new StringBuffer();
  for (int i=0;i<sus.length;i++) {
    Subject su = sus[i]; 
		su.setPhotographerID(Long.parseLong((String)request.getParameter("PhotographerID_"+su.getSubjectID())));
		su.setFirstShot((String)request.getParameter("FirstShot_"+su.getSubjectID()));
    su.setLastShot((String)request.getParameter("LastShot_"+su.getSubjectID()));
    su.setStatus((String)request.getParameter("Status_"+su.getSubjectID()));
    su.setNote((String)request.getParameter("Note_"+su.getSubjectID()));
		if (!su.hasErrors()) {
      ss.saveSubject(su);
		} else {
		  errMess.append(su.getFirstSubjectName()+": "+su.getErrMsg());
		}
  }
%>
<html>
<body>
<script>
<% if (errMess.length()>0) { 
%>
     parent.errorMsg("<%=errMess.toString()%>");
<% } else {
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