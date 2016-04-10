<%@ page import="au.com.fundfoto.shutterbug.entities.JobCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobSession" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobSessionService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.Subject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SubjectService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameRelation" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameRelationService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
long SubjectID = Long.parseLong((String)request.getParameter("SubjectID"));
Subject su = new SubjectService().getSubject(SubjectID);
long JobSessionID = su.getSessionID();
JobSession js = new JobSessionService().getJobSession(JobSessionID);
long JobCardID = js.getJobCardID();
JobCard jc = new JobCardService().getJobCard(JobCardID);
%>
<html>
<head>
  <title>Job Session Names</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<table>
<tr><td>
<fieldset>
<legend><a href="JobCardBrowser.jsp?SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Job Cards"></a> Job Card </legend>
    <table>
    <caption>SubjectRelationBrowser</caption>
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
    <td class="evenRow"><a href="javascript:editSession('<%=js.getSessionID()%>')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Session"></a></td>
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
<tr>
  <td>
  <fieldset>
  <legend><a href="SessionSubjectBrowser.jsp?JobSessionID=<%=JobSessionID%>&SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Subjects"></a> Subject</legend>
  <table>
   <tr><th>&nbsp;</th><th>&nbsp;</th><th>Subject Code</th><th>First Subject Name</th><th>Contact Name</th><th>Contact Number</th><th>Photographer</th><th>First Shot</th><th>Last Shot</th><th>Mount Shot</th><th>Status</th><th>Note</th></tr>
   <tr class="oddRow">
   <td class="evenRow"><a href="javascript:editSubject('<%=su.getSubjectID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Subject"></a></td>
   <td class="evenRow"><a href="javascript:editSubject('<%=su.getSubjectID()%>','Delete')"><img src="../images/delete_icon.jpg" height="20px" title="Delete Subject"></a></td>
   <td><%=su.getSubjectCode()%></td>
   <td><%=su.getFirstSubjectName()%></td>
   <td><%=su.getContactName()%></td>
   <td><%=su.getContactNumber()%></td>
   <td><%=su.getPhotographer()%></td>
   <td><%=su.getFirstShot()%></td>
   <td><%=su.getLastShot()%></td>
   <td><%=su.getShotName()%></td>
   <td><%=su.getStatus()%></td>
   <td><%=su.getNote()%></td>
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
  <legend>Names <a href="javascript:editRelation(0,'Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Name"></a></legend>
  <table>
  <tr><th>&nbsp;</th><th>&nbsp;</th><th>Name</th><th>Type</th></tr>
<%
NameRelation[] nrs = new NameRelationService().getNameRelationList(NameRelation.SUBJECT_TYPE, SubjectID);
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
function editRelation(ID, editMode) {
	var url = "NameRelationEdit-g.jsp?editMode="+editMode+"&RelationID="+ID+"&ParentType="+<%=NameRelation.SUBJECT_TYPE%>+"&ParentID="+<%=SubjectID%>;
	var name = "Name Relation Edit";
	openWindow(url,name);
}
function editName(ID,editMode) {
  var url = "NameCardEdit-g.jsp?editMode="+editMode+"&NameCardID="+ID;
  var name = "Name Relation Edit";
  openWindow(url,name);
}
function editSubject(ID, editMode) {
  var url = "SubjectEdit-g.jsp?editMode="+editMode+"&SubjectID="+ID+"&SessionID=<%=JobSessionID%>&JobCardID=<%=JobCardID%>&SessionCode=<%=SessionCode%>";
  var name = "Session Edit";
  openWindow(url,name);
}
function editSession(ID) {
  var url = "JobSessionEdit-g.jsp?SessionID="+ID+"&JobCardID=<%=JobCardID%>";
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
</script>
</body>
</html>

