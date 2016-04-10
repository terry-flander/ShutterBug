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
    <caption>SessionProcessBrowser</caption>
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
<tr><td class="messageBox" id="message"></td></tr>
<tr><td>
  <fieldset>
  <legend>Processes</legend>
  <table>
  <tr><td><a href="javascript:bulkLoadSubjects()" style="font-family:Arial;">Bulk Load Subject Names</a></td><td>Input form allowing entry of multiple Subject names and Contact information.</td><tr>
  <tr><td><a href="javascript:runProcess('SetSubjectCode-p.jsp')" style="font-family:Arial;">Set Subject Codes</a></td><td>Set the Subject Code for all Subjects if no Shots exist. If Shots exist, set Subject Code for new Subjects only.</td></tr>
  <tr><td><a href="javascript:updateShotList()" style="font-family:Arial;">Update Shot List</a></td><td>Scan RAW directory for any photos which were not loaded from PHOTOGRAPHERS. Create Shot record for new photos.</td></tr>
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
function updateShotList() {
  var url = "UpdateShotList-g.jsp?JobSessionID=<%=JobSessionID%>";
  var name = "Update Shot List";
  openWindow(url,name);
}
function bulkLoadSubjects() {
  var url = "BulkLoadSubject-g.jsp?JobSessionID=<%=JobSessionID%>";
  var name = "Bulk Load Subjects";
  openWindow(url,name);
}
function runProcess(url) {
	var f = document.getElementById('RunProcess');
	f.action = url;
	f.submit();
}
function editSession(ID,editMode) {
  var url = "JobSessionEdit-g.jsp?SessionID="+ID+"&JobCardID=<%=JobCardID%>&editMode="+editMode;
  var name = "Session Edit";
  openWindow(url,name);
}
function browseSessionNames(ID) {
  location.href = "SessionRelationBrowser.jsp?JobSessionID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseSessionProcesses(ID) {
  location.href = "SessionProcessBrowser.jsp?JobSessionID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseSessionSubjects(ID) {
  location.href = "SessionSubjectBrowser.jsp?JobSessionID="+ID+"&SessionCode=<%=SessionCode%>";
}
</script>
</body>
</html>

