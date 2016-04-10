<%@ page import="au.com.fundfoto.shutterbug.entities.NameCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
if (!NameLoginService.accessOK(SessionCode)) {
   response.sendRedirect("../login.html");
}
String NameFilter = "";  
if (request.getParameter("NameFilter") != null) {
   NameFilter = (String)request.getParameter("NameFilter");
}
long toID = 0;
if (request.getParameter("To") != null) {
   toID = Long.parseLong((String)request.getParameter("To"));
}
NameCard[] names = null;
if (NameFilter.length()>0) {
  NameCardService ncs = new NameCardService();
  ncs.setNameFilter(NameFilter);
	names = ncs.getNameCardList();
	for (int i=0;i<names.length;i++) {
	  if (request.getParameter("Merge_"+names[i].getNameCardID()) != null) {
	    ncs.mergeNameCards(names[i].getNameCardID(), toID);
	  }
	}
	names = ncs.getNameCardList();
}
%>
<html>
<head>
  <title>Merge Name Cards</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:800px;">
<form action="NameCardMerge.jsp?SessionCode=<%=SessionCode%>" method="post">
  <table>
  <caption>NameCardMerge</caption>
  <tr><td style="border:none;">
  <fieldset>
  <legend>Merge Name Cards&nbsp;<input type="text" name="NameFilter" value="<%=NameFilter%>">&nbsp;<input type="submit" value="Search">&nbsp;<input type="submit" value="Merge"></legend>
  <table>
  <tr><th>Merge</th><th>Into</th><th>ID</th><th>First Name</th><th>Middle Name</th><th>Last Name</th><th>Company</th><th>Address</th><th>City</th><th>State</th><th>PostCode</th><th>eMail</th><th>Phone</th><th>Mobile</th><th>Birthday</th></tr>
<%
if (names!=null) {
	boolean odd = true;
	for (int i=0;i<names.length;i++) {
	  NameCard nc = names[i]; 
	  String rowClass = (odd?"oddRow":"evenRow");
	  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td><input type="checkbox" name="Merge_<%=nc.getNameCardID()%>"></td>
  <td><input type="radio" name="To" value="<%=nc.getNameCardID()%>"></td>
  <td><%=nc.getNameCardID()%></td>
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
</td></tr></table>
</form>
</div>
<script>
windowResize();
</script>
</body>
</html>

