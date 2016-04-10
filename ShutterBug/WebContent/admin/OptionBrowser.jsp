<%@ page import="au.com.fundfoto.shutterbug.entities.Selection" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SelectionService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.Option" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
long SelectionID = Long.parseLong((String)request.getParameter("SelectionID"));
Selection se = new SelectionService().getSelection(SelectionID);
%>
<html>
<head>
  <title>Selection Options</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<table>
<caption>OptionBrowser</caption>
<tr><td style="border:none;">
<fieldset>
<legend><a href="SelectionBrowser.jsp?SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Selections"></a> Selection</legend>
<table>
<tr><th>&nbsp;</th><th>Code</th><th>Description</th></tr>
  <tr class="oddRow">
   <td class="evenRow"><a href="javascript:editSelection('<%=se.getSelectionID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Selection"></a></td>
  <td><%=se.getSelectionCode()%></td>
  <td><%=se.getDescription()%></td>
  </tr>
</table>
</fieldset>
</td></tr></table>
<table><tr><td style="border:none;">
<fieldset>
<legend>Options <a href="javascript:editOption('0','Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Option"></a></legend>
  <table>
  <tr><th>&nbsp;</th><th>&nbsp;</th><th>Name</th><th>Value</th><th>Attributes</th></tr>
<%
Option[] ops = new OptionService().getOptionList(SelectionID);
boolean odd = true;
for (int i=0;i<ops.length;i++) {
  Option op = ops[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td class="evenRow"><a href="javascript:editOption('<%=op.getOptionID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Option"></a></td>
  <td class="evenRow"><a href="javascript:editOption('<%=op.getOptionID()%>','Delete')"><img src="../images/delete_icon.jpg" height="20px" title="Delete Option"></a></td>
  <td><%=op.getOptionName()%></td>
  <td><%=op.getOptionValue()%></td>
  <td><%=op.getOptionAttributes()%></td>
  </tr>
<% 
} %>
</table>
</fieldset>
</td></tr></table>
<script>
function editOption(ID, editMode) {
  var url = "OptionEdit-g.jsp?editMode="+editMode+"&OptionID="+ID+"&SelectionID=<%=SelectionID%>";
  var name = "Selection Option Edit";
  openWindow(url,name);
}
function editSelection(ID,editMode) {
  var url = "SelectionEdit-g.jsp?editMode="+editMode+"&SelectionID="+ID;
  var name = "Selection Edit";
  openWindow(url,name);
}
</script>
</body>
</html>

