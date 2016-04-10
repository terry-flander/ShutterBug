<%@ page import="au.com.fundfoto.shutterbug.entities.JobCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameRelation" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameRelationService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
long JobCardID = Long.parseLong((String)request.getParameter("JobCardID"));
JobCard jc = new JobCardService().getJobCard(JobCardID);
%>
<html>
<head>
  <title>Job Card Relations</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<table>
<tr>
  <td>
  <fieldset>
  <legend><a href="JobCardBrowser.jsp?SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Job Cards"></a> Job Card 
    <a href="javascript:browseJobNames('<%=jc.getJobCardID()%>')">Names</a>
    <a href="javascript:browseJobPhotographers('<%=jc.getJobCardID()%>')">Photographers</a>
    <a href="javascript:browseJobProcesses('<%=jc.getJobCardID()%>')">Processes</a>
    <a href="javascript:browseJobSessions('<%=jc.getJobCardID()%>')">Sessions</a></legend>
    <table>
    <caption>JobRelationBrowser</caption>
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
  </td>
</tr>
</table>
<table>
<tr>
  <td>
  <fieldset>
  <legend>Names <a href="javascript:editRelation(0,'Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Job Name"></a></legend>
  <table>
  <tr><th>&nbsp;</th><th>&nbsp;</th><th>Name</th><th>Type</th></tr>
<%
NameRelation[] nrs = new NameRelationService().getNameRelationList(NameRelation.JOB_TYPE, JobCardID);
boolean odd = true;
for (int i=0;i<nrs.length;i++) {
  NameRelation nr = nrs[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td class="evenRow"><a href="javascript:editName('<%=nr.getChildID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Name"></a></td>
  <td class="evenRow"><a href="javascript:editRelation('<%=nr.getRelationID()%>','Delete')"><img src="../images/delete_icon.jpg" height="20px" title="Delete Name"></a></td>
  <td><%=nr.getChildName()%></td>
  <td><%=nr.getRelationType()%></td>
  </tr>
<%
} %>
  </table>
  </fieldset>
  </td>
</tr>
</table>
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
function editRelation(ID, editMode) {
	var url = "NameRelationEdit-g.jsp?editMode="+editMode+"&RelationID="+ID+"&ParentType="+<%=NameRelation.JOB_TYPE%>+"&ParentID="+<%=JobCardID%>;
	var name = "Name Relation Edit";
	openWindow(url,name);
}
function editName(ID, editMode) {
  var url = "NameCardEdit-g.jsp?editMode="+editMode+"&NameCardID="+ID;
  var name = "Name Relation Edit";
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

