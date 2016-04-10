<%@ page import="au.com.fundfoto.shutterbug.entities.JobCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
if (!NameLoginService.accessOK(SessionCode)) {
   response.sendRedirect("../login.html");
}
%>
<html>
<head>
  <title>Job Cards</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<table><tr><td style="border:none;">
	<fieldset>
	<legend>Job Cards <a href="javascript:editJobCard(0,'Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add Job Card"></a></legend>
	<table>
	<caption>JobCardBrowser</caption>
	<tr><th>&nbsp;</th><th>Name</th><th>Code</th><th>Description</th><th>Type</th><th>Date</th><th>Start</th><th>End</th></tr>
	<%
	JobCard[] jcs = new JobCardService().getJobCardList();
	boolean odd = true;
	for (int i=0;i<jcs.length;i++) {
	  JobCard jc = jcs[i]; 
	  String rowClass = (odd?"oddRow":"evenRow");
	  odd = !odd;
	%>
	<tr class="<%=rowClass%>">
		<td><a href="javascript:browseSessions('<%=jc.getJobCardID()%>')"><img src="../images/choose_icon.jpg" height="20px" title="Choose"></a></td>
		<td><%=jc.getName()%></td>
		<td><%=jc.getCode()%></td>
		<td><%=jc.getDescription()%></td>
		<td><%=jc.getType()%></td>
		<td><%=jc.getJobDate()%></td>
		<td><%=jc.getStartTime()%></td>
		<td><%=jc.getEndTime()%></td>
	</tr>
	<%
	} %>
	</table>
	</fieldset>
</td></tr></table>
<script>
function editJobCard(ID,editMode) {
  var url = "JobCardEdit-g.jsp?editMode="+editMode+"&JobCardID="+ID;
  var name = editMode+" Job Card ";
  openWindow(url,name);
}

function browseSessions(ID) {
  location.href = "JobSessionBrowser.jsp?JobCardID="+ID+"&SessionCode=<%=SessionCode%>";
}
</script>
</body>
</html>

