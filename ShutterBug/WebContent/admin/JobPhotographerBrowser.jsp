<%@ page import="au.com.fundfoto.shutterbug.entities.JobCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobPhotographer" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobPhotographerService" %>
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
<table><tr><td style="border:none;">
  <fieldset>
  <legend><a href="JobCardBrowser.jsp?SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Job Cards"></a> Job Card 
    <a href="javascript:browseJobNames('<%=jc.getJobCardID()%>')">Names</a>
    <a href="javascript:browseJobPhotographers('<%=jc.getJobCardID()%>')">Photographers</a>
    <a href="javascript:browseJobProcesses('<%=jc.getJobCardID()%>')">Processes</a>
    <a href="javascript:browseJobSessions('<%=jc.getJobCardID()%>')">Sessions</a></legend>
    <table>
    <caption>JobPhotographerBrowser</caption>
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
</td></tr></table>
<table><tr><td style="border:none;">
<fieldset>
<legend>Photographers <a href="javascript:editJobPhotographer('0','Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Photographer"></a></legend>
  <table>
  <tr><th>&nbsp;</th><th>&nbsp;</th><th>Name</th><th>Directory</th><th>Format</th></tr>
<%
JobPhotographer[] jps = new JobPhotographerService().getJobPhotographerList(JobCardID);
boolean odd = true;
for (int i=0;i<jps.length;i++) {
  JobPhotographer jp = jps[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td class="evenRow"><a href="javascript:editJobPhotographer('<%=jp.getJobPhotographerID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Name"></a></td>
  <td class="evenRow"><a href="javascript:editJobPhotographer('<%=jp.getJobPhotographerID()%>','Delete')"><img src="../images/delete_icon.jpg" height="20px" title="Delete Name"></a></td>
  <td><%=jp.getPhotographerName()%></td>
  <td><%=jp.getDirectory()%></td>
  <td><%=jp.getFormat()%></td>
  </tr>
<%
} %>
</table>
</fieldset>
</td></tr></table>
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
function editJobPhotographer(ID, editMode) {
  var url = "JobPhotographerEdit-g.jsp?editMode="+editMode+"&JobPhotographerID="+ID+"&JobCardID="+<%=JobCardID%>;
  var name = "Job Photographer Edit";
  openWindow(url,name);
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

