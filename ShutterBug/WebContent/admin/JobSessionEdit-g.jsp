<%@ page import="au.com.fundfoto.shutterbug.entities.JobSession" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobSessionService" %>

<%
  long SessionID = 0;  
  if (request.getParameter("SessionID") != null) {
     SessionID = Long.parseLong(request.getParameter("SessionID"));
  }
  long JobCardID = 0;
  if (request.getParameter("JobCardID") != null) {
    JobCardID = Long.parseLong(request.getParameter("JobCardID"));
	}
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
     editMode = (String)request.getParameter("editMode");
  }
  JobSession js = new JobSessionService().getJobSession(SessionID);
  js.setJobCardID(JobCardID);
%>

<html>
<head>
  <title>Session <%=editMode%></title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:400px;">
<form name="JobSessionEdit" id="JobSessionEdit" action="JobSessionEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr>
  <td>
  <fieldset>
  <legend><%=editMode%> Session</legend>
  <table>
  <tr><td class="messageBox" id="message"></td></tr>
  <tr><td class="inputLabel">Session ID : </td><td class="inputField"><%=(js.getSessionID()==0?"New":js.getSessionID())%></td></tr>
  <tr><td class="inputLabel">Name : </td><td class="inputField"><input type="text" name="Name" id="Name" value="<%=js.getName()%>"></td></tr>
  <tr><td class="inputLabel">Code : </td><td class="inputField"><input type="text" name="Code" value="<%=js.getCode()%>"></td></tr>
  <tr><td class="inputLabel">Description : </td><td class="inputField"><input type="text" name="Description" value="<%=js.getDescription()%>"></td></tr>
  <tr><td class="inputLabel">Date : </td><td class="inputField"><input type="text" name="Date" value="<%=js.getSessionDate()%>"></td></tr>
  <tr><td class="inputLabel">Start : </td><td class="inputField"><input type="text" name="StartTime" value="<%=js.getStartTime()%>"></td></tr>
  <tr><td class="inputLabel">End : </td><td class="inputField"><input type="text" name="EndTime" value="<%=js.getEndTime()%>"></td></tr>
  </table>
  </fieldset>
  </td>
</tr>  
<tr><td>
  <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
  <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
  <input type="hidden" name="JobCardID" value="<%=js.getJobCardID()%>">
  <input type="hidden" name="SessionID" value="<%=js.getSessionID()%>">
</td></tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>
<script>
windowResize();
setFocus("Name");
</script>
</body>
</html>
