<%@ page import="au.com.fundfoto.shutterbug.entities.Selection" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SelectionService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
if (!NameLoginService.accessOK(SessionCode)) {
   response.sendRedirect("../login.html");
}
%>
<html>
<head>
  <title>Browse and Maintain Selection Lists</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:500px;">
<table>
<caption>SelectionBrowser</caption>
<tr><td style="border:none;">
<fieldset>
<legend>Selections <a href="javascript:editSelection(0,'Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Selection"></a></legend>
<table>
<tr><th>&nbsp;</th><th>Code</th><th>Description</th></tr>
<%
Selection[] ses = new SelectionService().getSelectionList();
boolean odd = true;
for (int i=0;i<ses.length;i++) {
  Selection se = ses[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td><a href="javascript:browseOptions('<%=se.getSelectionID()%>')"><img src="../images/choose_icon.jpg" height="20px" title="Choose"></a></td>
  <td><%=se.getSelectionCode()%></td>
  <td><%=se.getDescription()%></td>
  </tr>
<%
} %>
</table>
</fieldset>
</td></tr></table>
</div>
<script>
function editSelection(ID,editMode) {
	var url = "SelectionEdit-g.jsp?SelectionID="+ID+"&editMode="+editMode;
	var name = "Selection Edit";
	openWindow(url,name);
}
function browseOptions(ID) {
  location.href = "OptionBrowser.jsp?SelectionID="+ID+"&SessionCode=<%=SessionCode%>";
}
windowResize();
</script>
</body>
</html>

