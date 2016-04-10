<%@ page import="au.com.fundfoto.shutterbug.entities.Subject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SubjectService" %>
<%
String SubjectFilter = "";  
if (request.getParameter("SubjectFilter") != null) {
   SubjectFilter = (String)request.getParameter("SubjectFilter");
}
%>
<html>
<head>
  <title>Subject Select</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<table>
<tr><th>Action</th><th>ID</th><th>Subject Code</th><th>First Name</th><th>Last Name</th></tr>
<%
SubjectService ncs = new SubjectService();
Subject[] subjects = ncs.getSubjectList(SubjectFilter);
boolean odd = true;
for (int i=0;i<subjects.length;i++) {
  Subject nc = subjects[i]; 
  if (odd) {
%>
  <tr class="oddRow">
<% } else { %>
  <tr class="evenRow">
<% } %>
  <td><a href="javascript:chooseCard('<%=nc.getSubjectID()%>','<%=nc.getFirstSubjectName()%>')">Choose</a></td>
  <td><%=nc.getSubjectID()%></td>
  <td><%=nc.getSubjectCode()%></td>
  <td><%=nc.getFirstSubjectName()%></td>
  </tr>
<% odd = !odd;
} %>
</table>
<script>
function chooseCard(ID,Name) {
	parent.setChoice(ID,Name);
}
</script>
</body>
</html>

