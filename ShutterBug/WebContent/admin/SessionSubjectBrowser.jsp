<%@ page import="au.com.fundfoto.shutterbug.entities.JobCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobSession" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobSessionService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.Subject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SubjectService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
long JobSessionID = Long.parseLong((String)request.getParameter("JobSessionID"));
JobSession js = new JobSessionService().getJobSession(JobSessionID);
long JobCardID = js.getJobCardID();
JobCard jc = new JobCardService().getJobCard(JobCardID);
%>
<html>
<head>
  <title>Job Sessions</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<table>
<tr><td>
<fieldset>
  <legend><a href="JobCardBrowser.jsp?SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Job Cards"></a> Job Card </legend>
    <table>
    <caption>SessionSubjectBrowser</caption>
    <tr><th>Name</th><th>Code</th><th>Description</th><th>Type</th><th>Date</th><th>Start</th><th>End</th></tr>
    <tr class="oddRow">
    <td><%=jc.getName()%></td>
    <td><%=jc.getCode()%></td>
    <td><%=jc.getDescription()%></td>
    <td><%=jc.getType()%></td>
    <td><%=jc.getJobDate()%></td>
    <td><%=jc.getStartTime()%></td>
    <td><%=jc.getEndTime()%></td>
    </tr>
    </table>
</fieldset>
</td></tr>
<tr>
  <td>
  <fieldset>
  <legend><a href="JobSessionBrowser.jsp?JobCardID=<%=JobCardID%>&SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Sessions"></a> Session
  <a href="javascript:browseSessionNames('<%=js.getSessionID()%>')">Names</a>
  <a href="javascript:browseSessionProcesses('<%=js.getSessionID()%>')">Processes</a>
  <a href="javascript:browseSessionSubjects('<%=js.getSessionID()%>')">Subjects</a>
  </legend>
    <table>
    <tr><th>&nbsp;</th><th>Name</th><th>Code</th><th>Description</th><th>Date</th><th>Start</th><th>End</th></tr>
    <tr class="oddRow">
    <td class="evenRow"><a href="javascript:editSession('<%=js.getSessionID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Session"></a></td>
    <td><%=js.getName()%></td>
    <td><%=js.getCode()%></td>
    <td><%=js.getDescription()%></td>
    <td><%=js.getSessionDate()%></td>
    <td><%=js.getStartTime()%></td>
    <td><%=js.getEndTime()%></td>
    </tr>
    </table>
    </fieldset>
    </td>
</tr>
<tr><td class="messageBox" id="message" colspan="2"></td></tr>
<tr><td colspan="2">
  <fieldset>
  <legend>Subject&nbsp;
  <a href="javascript:editSubject('0','Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Subject"></a>
  </legend>
  <table>
  <tr><th>&nbsp;</th><th>Subject Code</th><th>First Subject Name</th><th>Contact Name</th><th>Contact Number</th><th>Photographer</th><th>First Shot</th><th>Last Shot</th><th>Mount Shot</th><th>Status</th><th>Note</th></tr>
<%
Subject[] sss = new SubjectService().getSubjectList(JobSessionID);
boolean odd = true;
for (int i=0;i<sss.length;i++) {
  Subject ss = sss[i];
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td><a href="javascript:browseSubjectRelations('<%=ss.getSubjectID()%>')"><img src="../images/choose_icon.jpg" height="20px" title="Choose"></a></td>
  <td><%=ss.getSubjectCode()%></td>
  <td><%=ss.getFirstSubjectName()%></td>
  <td><%=ss.getContactName()%></td>
  <td><%=ss.getContactNumber()%></td>
  <td><%=ss.getPhotographer()%></td>
  <td><%=ss.getFirstShot()%></td>
  <td><%=ss.getLastShot()%></td>
  <td><%=ss.getShotName()%></td>
  <td><%=ss.getStatus()%></td>
  <td><%=ss.getNote()%></td>
  </tr>
<% 
} %>
  </table>
  </fieldset>
  </td>
</tr>
</table>
<form name="RunProcess" id="RunProcess" target="hiddenFrame" method="post">
<input type="hidden" name="SessionID" value="<%=JobSessionID%>">
</form>
<iframe name="hiddenFrame" id='hiddenFrame' class="hiddenFrame">
</iframe>
<script>
function editSession(ID,editMode) {
  var url = "JobSessionEdit-g.jsp?editMode="+editMode+"&SessionID="+ID+"&JobCardID=<%=JobCardID%>";
  var name = "Session Edit";
  openWindow(url,name);
}
function editSubject(ID, editMode) {
  var url = "SubjectEdit-g.jsp?editMode="+editMode+"&SubjectID="+ID+"&SessionID=<%=JobSessionID%>&JobCardID=<%=JobCardID%>&SessionCode=<%=SessionCode%>";
  var name = "Session Edit";
  openWindow(url,name);
}
function browseSessionNames(ID) {
  location.href = "SessionRelationBrowser.jsp?JobSessionID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseSubjectRelations(ID) {
  location.href = "SubjectRelationBrowser.jsp?SubjectID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseSessionSubjects(ID) {
  location.href = "SessionSubjectBrowser.jsp?JobSessionID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseSessionProcesses(ID) {
  location.href = "SessionProcessBrowser.jsp?JobSessionID="+ID+"&SessionCode=<%=SessionCode%>";
}
</script>
</body>
</html>

