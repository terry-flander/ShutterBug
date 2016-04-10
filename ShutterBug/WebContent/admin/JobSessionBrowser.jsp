<%@ page import="au.com.fundfoto.shutterbug.entities.JobCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobSession" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobSessionService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
long JobCardID = Long.parseLong((String)request.getParameter("JobCardID"));
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
<legend><a href="JobCardBrowser.jsp?SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Job Cards"></a> Job Card 
    <a href="javascript:browseJobNames('<%=jc.getJobCardID()%>')">Names</a>
    <a href="javascript:browseJobPhotographers('<%=jc.getJobCardID()%>')">Photographers</a>
    <a href="javascript:browseJobProcesses('<%=jc.getJobCardID()%>')">Processes</a>
    <a href="javascript:browseJobSessions('<%=jc.getJobCardID()%>')">Sessions</a></legend>
    <table>
    <caption>JobSessionBrowser</caption>
    <tr><th>&nbsp;</th><th>Name</th><th>Code</th><th>Description</th><th>Type</th><th>Date</th><th>Start</th><th>End</th></tr>
    <tr class="oddRow">
    <td class="evenRow"><a href="javascript:editJobCard('<%=jc.getJobCardID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Job Card"></a></td>
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
<tr><td class="messageBox" id="message" colspan="2"></td></tr>
<tr><td>
<fieldset>
<legend>Sessions <a href="javascript:editSession('0','Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Session"></a></legend>
  <table>
  <tr><th>&nbsp;</th><th>Name</th><th>Code</th><th>Description</th><th>Date</th><th>Start</th><th>End</th></tr>
<%
JobSession[] jss = new JobSessionService().getJobSessionList(JobCardID);
boolean odd = true;
for (int i=0;i<jss.length;i++) {
  JobSession js = jss[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td><a href="javascript:browseSessionSubjects('<%=js.getSessionID()%>')"><img src="../images/choose_icon.jpg" height="20px" title="Choose"></a></td>
  <td><%=js.getName()%></td>
  <td><%=js.getCode()%></td>
  <td><%=js.getDescription()%></td>
  <td><%=js.getSessionDate()%></td>
  <td><%=js.getStartTime()%></td>
  <td><%=js.getEndTime()%></td>
  </tr>
<% 
} %>
</table>
</fieldset>
</td></tr>
</table>
<iframe name="hiddenFrame" id='hiddenFrame' class="hiddenFrame"></iframe>
<script>
function editJobCard(ID,editMode) {
  var url = "JobCardEdit-g.jsp?editMode="+editMode+"&JobCardID="+ID;
  var name = "Job Card Edit";
  openWindow(url,name);
}
function browseJobNames(ID) {
  location.href = "JobRelationBrowser.jsp?JobCardID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseJobPhotographers(ID) {
  location.href = "JobPhotographerBrowser.jsp?JobCardID="+ID+"&SessionCode=<%=SessionCode%>";
}
function editSession(ID, editMode) {
	var url = "JobSessionEdit-g.jsp?editMode="+editMode+"&SessionID="+ID+"&JobCardID=<%=JobCardID%>";
	var name = "Session Edit";
	openWindow(url,name);
}
function browseSessionNames(ID) {
  location.href = "SessionRelationBrowser.jsp?JobSessionID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseSessionSubjects(ID) {
  location.href = "SessionSubjectBrowser.jsp?JobSessionID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseSessionProcesses(ID) {
	  location.href = "SessionProcessBrowser.jsp?JobSessionID="+ID+"&SessionCode=<%=SessionCode%>";
	}
function browseJobProcesses(ID) {
  location.href = "JobProcessBrowser.jsp?JobCardID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseJobSessions(ID) {
  location.href = "JobSessionBrowser.jsp?JobCardID="+ID+"&SessionCode=<%=SessionCode%>";
}
</script>
</body>
</html>

