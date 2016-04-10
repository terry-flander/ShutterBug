<%@ page import="au.com.fundfoto.shutterbug.entities.NameCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCardService" %>
<%
String NameFilter = "";  
if (request.getParameter("NameFilter") != null) {
   NameFilter = (String)request.getParameter("NameFilter");
}
%>
<html>
<head>
  <title>Name Card Select</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<table>
<tr><th>Action</th><th>ID</th><th>First Name</th><th>Middle Name</th><th>Last Name</th><th>Company</th><th>Address</th><th>City</th><th>State</th></tr>
<%
NameCardService ncs = new NameCardService();
ncs.setNameFilter(NameFilter);
NameCard[] names = ncs.getNameCardList();
boolean odd = true;
for (int i=0;i<names.length;i++) {
  NameCard nc = names[i]; 
  if (odd) {
%>
  <tr class="oddRow">
<% } else { %>
  <tr class="evenRow">
<% } %>
  <td><a href="javascript:chooseCard('<%=nc.getNameCardID()%>','<%=nc.getLastName()%>, <%=nc.getFirstName()%>')">Choose</a></td>
  <td><%=nc.getNameCardID()%></td>
  <td><%=nc.getFirstName()%></td>
  <td><%=nc.getMiddleName()%></td>
  <td><%=nc.getLastName()%></td>
  <td><%=nc.getCompanyName()%></td>
  <td><%=nc.getAddress()%></td>
  <td><%=nc.getCity()%></td>
  <td><%=nc.getState()%></td>
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

