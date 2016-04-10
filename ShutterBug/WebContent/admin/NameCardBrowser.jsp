<%@ page import="au.com.fundfoto.shutterbug.entities.NameCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = request.getParameter("SessionCode"); 
if (!NameLoginService.accessOK(SessionCode)) {
   response.sendRedirect("../login.html");
}
String NameFilter = "";  
if (request.getParameter("NameFilter") != null) {
   NameFilter = (String)request.getParameter("NameFilter");
}
%>
<html>
<head>
  <title>Name Cards</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
  <form id="searchNames" action="NameCardBrowser.jsp" method="post">
  <table><tr><td style="border:none;">
  <fieldset>
  <legend>Name Cards 
  <a href="javascript:editName('0','Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Name"></a>
  <input type="text" name="NameFilter" id="NameFilter" value="<%=NameFilter%>">
  <a href="javascript:doSearch()"><img src="../images/search_icon.jpg" height="20px" title="Search for Names"></a>
  </legend>
  <table>
  <caption>NameCardBrowser</caption>
  <tr><th>&nbsp;</th><th>First Name</th><th>Middle Name</th><th>Last Name</th><th>Company</th><th>Address</th><th>City</th><th>State</th><th>PostCode</th><th>eMail</th><th>Phone</th><th>Mobile</th><th>Birthday</th></tr>
<%
NameCard[] names = null;
if (NameFilter.length()>0) {
  NameCardService ncs = new NameCardService();
  ncs.setNameFilter(NameFilter);
	names = ncs.getNameCardList();
	
	boolean odd = true;
	for (int i=0;i<names.length;i++) {
	  NameCard nc = names[i]; 
	  String rowClass = (odd?"oddRow":"evenRow");
	  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td><a href="javascript:browseNameRelations('<%=nc.getNameCardID()%>')"><img src="../images/choose_icon.jpg" height="15px" title="Choose"></a></td>
  <td><%=nc.getFirstName()%></td>
  <td><%=nc.getMiddleName()%></td>
  <td><%=nc.getLastName()%></td>
  <td><%=nc.getCompanyName()%></td>
  <td><%=nc.getAddress()%></td>
  <td><%=nc.getCity()%></td>
  <td><%=nc.getState()%></td>
  <td><%=nc.getPostCode()%></td>
  <td><%=nc.getEmail()%></td>
  <td><%=nc.getPhone()%></td>
  <td><%=nc.getMobile()%></td>
  <td><%=nc.getBirthDate()%></td>
  </tr>
<% 
	}
} %>
  </table>
  </fieldset>
  <input type="hidden" name="SessionCode" value="<%=SessionCode%>">
  </td></tr>
</table>
</form>
<script>
function doSearch() {
	var f = document.getElementById("searchNames");
  parent.setNameFilter(document.getElementById("NameFilter").value);
	f.submit();
}
function editName(ID, editMode) {
  var url = "NameCardEdit-g.jsp?editMode="+editMode+"&NameCardID="+ID;
  var name = "Name Edit";
  openWindow(url,name);
}
function browseNameRelations(ID) {
  location.href = "NameRelationBrowser.jsp?NameCardID="+ID+"&SessionCode=<%=SessionCode%>";
}
</script>
</body>
</html>

