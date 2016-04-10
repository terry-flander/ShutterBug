<%@ page import="au.com.fundfoto.shutterbug.entities.Selection" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SelectionService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.Option" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>

<%
  long SelectionID = 0;  
  if (request.getParameter("SelectionID") != null) {
    SelectionID = Long.parseLong(request.getParameter("SelectionID"));
  }
  long OptionID = 0;  
  if (request.getParameter("OptionID") != null) {
    OptionID = Long.parseLong(request.getParameter("OptionID"));
  }
  Option op = new OptionService().getOption(OptionID);
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
    editMode = (String)request.getParameter("editMode");
  }
%>

<html>
<head>
  <title>Selection Option <%=editMode%></title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:300px;">
<form name="OptionEdit" id="OptionEdit" action="OptionEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr>
  <td>
  <fieldset>
  <legend><%=editMode%> Selection Option</legend>
  <table>
  <tr><td colspan="2" class="messageBox" id="message"></td></tr>
  <tr><td class="inputLabel">Selection ID : </td><td class="inputField"><%=(op.getOptionID()==0?"New":op.getOptionID())%></td></tr>
  <tr><td class="inputLabel">Option Name : </td><td class="inputField"><input type="text" id="OptionName" name="OptionName" value="<%=op.getOptionName()%>"></td></tr>
  <tr><td class="inputLabel">Option Value : </td><td class="inputField"><input type="text" id="OptionValue" name="OptionValue" value="<%=op.getOptionValue()%>"></td></tr>
  <tr><td class="inputLabel">Option Attributes : </td><td class="inputField"><input type="text" name="OptionAttributes" value="<%=op.getOptionAttributes()%>"></td></tr>
  </table>
  </fieldset>
  </td>
</tr>
<tr>
  <td>
    <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
    <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
    <input type="hidden" name="OptionID" value="<%=op.getOptionID()%>">
    <input type="hidden" name="SelectionID" value="<%=SelectionID%>">    
    <input type="hidden" name="editMode" value="<%=editMode%>">    
  </td>
</tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>

<script>
windowResize();
setFocus("OptionName");
</script>
</body>
</html>
