<%@ page import="au.com.fundfoto.shutterbug.entities.Subject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SubjectService" %>
<%
  long JobSessionID = 0;  
  if (request.getParameter("JobSessionID") != null) {
    JobSessionID = Long.parseLong(request.getParameter("JobSessionID"));
  }
%>

<html>
<head>
  <title>Bulk Load Subject Names</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:600px;">
<form name="SubjectLoad" id="SubjectLoad" action="BulkLoadSubject-p.jsp" target="hiddenFrame" method="post">
<table>
<tr>
  <td>
    <fieldset>
    <legend>Bulk Load Subject Names</legend>
    <table>
    <tr><td colspan="2" class="messageBox" id="message"></td></tr>
    <tr><th>Subject Name(s)<br>[Last, First (;)]</th><th>Contact Name<br>[(Last if different,) First]</th><th>Contact Number</th></tr>
<% for (int i=0;i<10;i++) { %>   
    <tr><td><input type="text" name="subjectName_<%=i%>" id="subjectName_<%=i%>"></td><td><input type="text" name="contactName_<%=i%>"></td><td><input type="text" name="contactNumber_<%=i%>"></td></tr>
<% } %>
    </table>
    </fieldset>
  </td>
</tr>
<tr>
  <td>
    <input type="submit" name="saveButton" value="Load">&nbsp;
    <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
    <input type="hidden" name="JobSessionID" value="<%=JobSessionID%>">
  </td>
</tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>
<script>
windowResize();
setFocus("subjectName_0");
</script>
</body>
</html>
