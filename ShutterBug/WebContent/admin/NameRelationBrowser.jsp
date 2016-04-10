<%@ page import="au.com.fundfoto.shutterbug.entities.NameCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameRelation" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameRelationService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
long NameCardID = Long.parseLong((String)request.getParameter("NameCardID"));
NameCard nc = new NameCardService().getNameCard(NameCardID);
%>
<html>
<head>
  <title>Name Card Relations</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<table class="browserTable">
<tr>
  <td>
  <fieldset>
  <legend><a href="NameCardBrowser.jsp?SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Job Cards"></a> Name Card
  <a href="javascript:browseNameRelation('<%=nc.getNameCardID()%>')">Names</a>
  <a href="javascript:browseNameLogin('<%=nc.getNameCardID()%>')">Logins</a>
  </legend>
  <table>
  <caption>NameRelationBrowser</caption>
  <tr><th>&nbsp;</th><th>First Name</th><th>Last Name</th><th>Company</th><th>Address</th><th>City</th><th>State</th><th>PostCode</th><th>eMail</th><th>Phone</th><th>Mobile</th></tr>
  <tr class="oddRow">
  <td class="evenRow"><a href="javascript:editName('<%=nc.getNameCardID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Name Card"></a></td>
  <td><%=nc.getFirstName()%></td>
  <td><%=nc.getLastName()%></td>
  <td><%=nc.getCompanyName()%></td>
  <td><%=nc.getAddress()%></td>
  <td><%=nc.getCity()%></td>
  <td><%=nc.getState()%></td>
  <td><%=nc.getPostCode()%></td>
  <td><%=nc.getEmail()%></td>
  <td><%=nc.getPhone()%></td>
  <td><%=nc.getMobile()%></td>
  </tr>
  </table>
  </fieldset>
  </td>
</tr>
</table>
<table>
<tr><td valign=top>
<table class="browserTable">
<tr>
  <td>
  <fieldset>
  <legend>Names <a href="javascript:editRelation(0,'Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Relation"></a></legend>
  <table>
  <tr><th>&nbsp;</th><th>&nbsp;</th><th>ID</th><th>Name</th><th>Type</th></tr>
<%
NameRelation[] nrs = new NameRelationService().getNameRelationList(NameRelation.NAME_TYPE, NameCardID);
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
</td>
<%
NameRelation[] job_nrs = new NameRelationService().getChildRelationList(NameRelation.JOB_TYPE, NameCardID);
NameRelation[] session_nrs = new NameRelationService().getChildRelationList(NameRelation.SESSION_TYPE, NameCardID);
NameRelation[] subject_nrs = new NameRelationService().getChildRelationList(NameRelation.SUBJECT_TYPE, NameCardID);
NameRelation[] order_nrs = new NameRelationService().getChildRelationList(NameRelation.ORDER_TYPE, NameCardID);
%>
<% if (job_nrs.length>0) { %>
<td valign=top>
<table class="browserTable">
<tr>
  <td>
  <fieldset>
  <legend>Related Jobs</legend>
  <table>
  <tr><th>ID</th><th>Description</th></tr>
<%
odd = true;
for (int i=0;i<job_nrs.length;i++) {
  NameRelation nr = job_nrs[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td><%=nr.getRelationID()%></td>
  <td><a href="javascript:browseJob('<%=nr.getParentID()%>')"><%=nr.getChildName()%></a></td>
  <td><%=nr.getRelationType()%></td>
  </tr>
<% 
} %>
  </table>
  </fieldset>
  </td>
</tr>
</table>
</td>
<% }
  if (session_nrs.length>0) { %>
<td valign=top>
<table class="browserTable">
<tr>
  <td>
  <fieldset>
  <legend>Related Sessions</legend>
  <table>
  <tr><th>ID</th><th>Description</th></tr>
<%
odd = true;
for (int i=0;i<session_nrs.length;i++) {
  NameRelation nr = session_nrs[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td><%=nr.getRelationID()%></td>
  <td><a href="javascript:browseSession('<%=nr.getParentID()%>')"><%=nr.getChildName()%></a></td>
  <td><%=nr.getRelationType()%></td>
  </tr>
<% 
} %>
  </table>
  </fieldset>
  </td>
</tr>
</table>
</td>
<% }
  if (subject_nrs.length>0) { %>
<td valign=top>
<table class="browserTable">
<tr>
  <td>
  <fieldset>
  <legend>Related Subjects</legend>
  <table>
  <tr><th>ID</th><th>Description</th></tr>
<%
odd = true;
for (int i=0;i<subject_nrs.length;i++) {
  NameRelation nr = subject_nrs[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td><%=nr.getRelationID()%></td>
  <td><a href="javascript:browseSubject('<%=nr.getParentID()%>')"><%=nr.getChildName()%></a></td>
  <td><%=nr.getRelationType()%></td>
  </tr>
<% 
} %>
  </table>
  </fieldset>
  </td>
</tr>
</table>
</td>
<% }
  if (order_nrs.length>0) { %>
<td valign=top>
<table class="browserTable">
<tr>
  <td>
  <fieldset>
  <legend>Related Orders</legend>
  <table>
  <tr><th>ID</th><th>Description</th></tr>
<%
odd = true;
for (int i=0;i<order_nrs.length;i++) {
  NameRelation nr = order_nrs[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td><%=nr.getRelationID()%></td>
  <td><a href="javascript:browseOrder('<%=nr.getParentID()%>')"><%=nr.getChildName()%></a></td>
  <td><%=nr.getRelationType()%></td>
  </tr>
<% 
} %>
  </table>
  </fieldset>
  </td>
</tr>
</table>
</td>
<% } %>
</tr>
</table>
<script>
function editRelation(ID, editMode) {
  var url = "NameRelationEdit-g.jsp?editMode="+editMode+"&RelationID="+ID+"&ParentType="+<%=NameRelation.NAME_TYPE%>+"&ParentID="+<%=NameCardID%>;
  var name = "Name Relation Edit";
  openWindow(url,name);
}
function editName(ID,editMode) {
  var url = "NameCardEdit-g.jsp?editMode="+editMode+"&NameCardID="+ID;
  var name = "Name Relation Edit";
  openWindow(url,name);
}
function browseJob(ID) {
  location.href = "JobSessionBrowser.jsp?JobCardID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseSession(ID) {
  location.href = "SessionSubjectBrowser.jsp?JobSessionID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseSubject(ID) {
  location.href = "SubjectRelationBrowser.jsp?SubjectID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseNameRelation(ID) {
  location.href = "NameRelationBrowser.jsp?NameCardID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseNameLogin(ID) {
	  location.href = "NameLoginBrowser.jsp?NameCardID="+ID+"&SessionCode=<%=SessionCode%>";
	}
function browseOrder(ID) {
	  location.href = "OrderLineBrowser.jsp?OrderID="+ID+"&SessionCode=<%=SessionCode%>";
	}
</script>
</body>
</html>

