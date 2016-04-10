<%@ page import="au.com.fundfoto.shutterbug.entities.NameCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLogin" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
long NameCardID = Long.parseLong((String)request.getParameter("NameCardID"));
NameCard nc = new NameCardService().getNameCard(NameCardID);
%>
<html>
<head>
  <title>Name Card Logins</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<table>
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
<tr>
  <td>
  <fieldset>
  <legend>Logins <a href="javascript:editLogin(0,'Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Login"></a></legend>
  <table>
  <tr><th>&nbsp;</th><th>&nbsp;</th><th>LoginID</th><th>Status</th><th>Date Created</th><th>Last Login</th><th>Access Level</th></tr>
<%
NameLogin[] nls = NameLoginService.getNameLoginList(NameCardID);
boolean odd = true;
for (int i=0;i<nls.length;i++) {
  NameLogin nl = nls[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td class="evenRow"><a href="javascript:editLogin('<%=nl.getNameLoginID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Login"></a></td>
  <td class="evenRow"><a href="javascript:editLogin('<%=nl.getNameLoginID()%>','Delete')"><img src="../images/delete_icon.jpg" height="20px" title="Delete Login"></a></td>
  <td><%=nl.getLoginID()%></td>
  <td><%=nl.getStatus()%></td>
  <td><%=nl.getDateCreated()%></td>
  <td><%=nl.getLastLogin()%></td>
  <td><%=nl.getAccessLevel()%></td>
  </tr>
<% 
} %>
  </table>
  </fieldset>
  </td>
</tr>
</table>
<script>
function editLogin(ID, editMode) {
	var url = "NameLoginEdit-g.jsp?editMode="+editMode+"&NameLoginID="+ID+"&NameCardID="+<%=NameCardID%>;
	var name = "Name Login Edit";
	openWindow(url,name);
}
function editName(ID,editMode) {
  var url = "NameCardEdit-g.jsp?editMode="+editMode+"&NameCardID="+ID;
  var name = "Name Relation Edit";
  openWindow(url,name);
}
function browseNameRelation(ID) {
  location.href = "NameRelationBrowser.jsp?NameCardID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseNameLogin(ID) {
  location.href = "NameLoginBrowser.jsp?NameCardID="+ID+"&SessionCode=<%=SessionCode%>";
}
</script>
</body>
</html>

