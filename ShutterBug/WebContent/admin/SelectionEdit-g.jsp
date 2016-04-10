<%@ page import="au.com.fundfoto.shutterbug.entities.Selection" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SelectionService" %>

<%
  long SelectionID = 0;  
  if (request.getParameter("SelectionID") != null) {
     SelectionID = Long.parseLong(request.getParameter("SelectionID"));
  }
  Selection se = new SelectionService().getSelection(SelectionID);
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
     editMode = (String)request.getParameter("editMode");
  }
%>

<html>
  <head>
  <title>Job Card <%=editMode%></title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:400px;">
<form name="SelectionEdit" id="SelectionEdit" action="SelectionEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr><td>
  <fieldset>
  <legend><%=editMode%> Selection</legend>
    <table>
    <tr><td class="messageBox" colspan="2" id="message"></td></tr>
    <tr><td class="inputLabel">Selection ID : </td><td class="inputField"><%=(se.getSelectionID()==0?"New":se.getSelectionID())%></td></tr>
    <tr><td class="inputLabel">Selection Code : </td><td class="inputField"><input type="text" name="SelectionCode" id="SelectionCode" value="<%=se.getSelectionCode()%>"></td></tr>
    <tr><td class="inputLabel">Description : </td><td class="inputField"><input type="text" name="Description" value="<%=se.getDescription()%>"></td></tr>
    </table>
  </fieldset>
</td></tr>
<tr><td>
  <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
  <input type="button" name="submitter" value="Cancel" onclick="cancel()">
  <input type="hidden" name="SelectionID" value="<%=se.getSelectionID()%>">
</td></tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>
<script>
windowResize();
setFocus("SelectionCode")
</script>
</body>
</html>
