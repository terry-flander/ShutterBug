<%@ page import="au.com.fundfoto.shutterbug.entities.Subject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SubjectService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobSession" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobSessionService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobPhotographer" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobPhotographerService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>

<%
  long JobSessionID = 0;  
  if (request.getParameter("JobSessionID") != null) {
    JobSessionID = Long.parseLong(request.getParameter("JobSessionID"));
  }
  JobSession js = new JobSessionService().getJobSession(JobSessionID);
  JobCard jc = new JobCardService().getJobCard(js.getJobCardID());
  String photographerOptions = new JobPhotographerService().getHTMLJobPhotographerList(jc.getJobCardID());
%>

<html>
<head>
  <title>Update Shot List</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:700px;">
<form name="UpdateShotList" id="UpdateShotList" action="UpdateShotList-p.jsp" target="hiddenFrame" method="post">
<table>
<tr>
  <td>
    <fieldset>
    <legend>Update Shot List</legend>
    <table>
    <tr><td colspan="5" class="messageBox" id="message"></td></tr>
    <tr><th>ID</th><th>Subject Name</th><th>Photographer</th><th>First Shot</th><th>Last Shot</th><th>Status</th><th>Note</th></tr>
<%
Subject[] sss = new SubjectService().getSubjectList(JobSessionID);
boolean odd = true;
for (int i=0;i<sss.length;i++) {
  Subject ss = sss[i]; 
  String photographer = "PhotographerID_" + ss.getSubjectID();
  String firstShot = "FirstShot_" + ss.getSubjectID();
  String lastShot = "LastShot_" + ss.getSubjectID();
  String status = "Status_" + ss.getSubjectID();
  String note = "Note_" + ss.getSubjectID();
  String rowClass = (odd?"oddRow":"evenRow");
  String subjectStatus = OptionService.getHTMLOptionList("SubjectStatus");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
    <td><%=ss.getSubjectID()%></td>
    <td width="200px"><%=ss.getFirstSubjectName()%></td>
    <td><select name="<%=photographer%>" id="<%=photographer%>"><%=photographerOptions%></select></td>
    <td class="inputField"><input type="text" name="<%=firstShot%>" value="<%=ss.getFirstShot()%>" style="width:50px;" /></td>
    <td class="inputField"><input type="text" name="<%=lastShot%>" value="<%=ss.getLastShot()%>" style="width:50px;" /></td>
    <td class="inputField"><select name="<%=status%>" id="<%=status%>"><%=subjectStatus%></select></td>
    <td class="inputField"><input type="text" name="<%=note%>" value="<%=ss.getNote()%>"></td>
  </tr>
<% } %>
  </table>
  </fieldset>
  </td>
</tr>
<tr>
  <td>
    <input type="submit" name="saveButton" value="Save">&nbsp;
    <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
    <input type="hidden" name="JobSessionID" value="<%=JobSessionID%>">
  </td>
</tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>
<script>
<%
for (int i=0;i<sss.length;i++) {
	Subject ss = sss[i]; 
  String photographer = "PhotographerID_" + ss.getSubjectID();
  String status = "Status_" + ss.getSubjectID();
  if (i==0) {
%>
    var f = document.getElementById("<%=photographer%>");
<% } %>
setSelect("<%=photographer%>","<%=ss.getPhotographerID()%>");
setSelect("<%=status%>","<%=ss.getStatus()%>");
<% 
} %>
f.focus();
windowResize();
</script>
</body>
</html>
