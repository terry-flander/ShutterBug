<%@ page import="au.com.fundfoto.shutterbug.entities.JobCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>

<%
  long JobCardID = 0;  
  if (request.getParameter("JobCardID") != null) {
     JobCardID = Long.parseLong(request.getParameter("JobCardID"));
  }
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
     editMode = (String)request.getParameter("editMode");
  }
  JobCard jc = new JobCardService().getJobCard(JobCardID);
%>

<html>
  <head>
  <title><%=editMode%> Job Card</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:550px;">
<form name="JobCardEdit" id="JobCardEdit" action="JobCardEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr><td>
  <fieldset>
  <legend><%=editMode%> Job Card</legend>
    <table>
    <tr><td class="messageBox" colspan="2" id="message"></td></tr>
    <tr><td class="inputLabel">Job Card ID : </td><td class="inputField"><%=(jc.getJobCardID()==0?"New":jc.getJobCardID())%></td></tr>
    <tr><td class="inputLabel">Name : </td><td class="inputField"><input type="text" name="Name" id="Name" value="<%=jc.getName()%>"></td></tr>
    <tr><td class="inputLabel">Code : </td><td class="inputField"><input type="text" name="Code" value="<%=jc.getCode()%>"></td></tr>
    <tr><td class="inputLabel">Description : </td><td class="inputField"><input type="text" style="width:400px;" name="Description" value="<%=jc.getDescription()%>"></td></tr>
    <tr><td class="inputLabel">Type : </td><td class="inputField"><select name="Type" id="Type"><%=OptionService.getHTMLOptionList("JobTypes")%></select></td></tr>
    <tr><td class="inputLabel">Date : </td><td class="inputField"><input type="text" name="Date" value="<%=jc.getJobDate()%>"></td></tr>
    <tr><td class="inputLabel">Start : </td><td class="inputField"><input type="text" name="StartTime" value="<%=jc.getStartTime()%>"></td></tr>
    <tr><td class="inputLabel">End : </td><td class="inputField"><input type="text" name="EndTime" value="<%=jc.getEndTime()%>"></td></tr>
    <tr><td class="inputLabel">Base Directory : </td><td class="inputField"><input type="text" style="width:400px;" name="BaseDirectory" value="<%=jc.getBaseDirectory()%>"></td></tr>
    </table>
  </fieldset>
</td></tr>
<tr><td>
  <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
  <input type="button" name="submitter" value="Cancel" onclick="cancel()">
  <input type="hidden" name="JobCardID" value="<%=jc.getJobCardID()%>">
</td></tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>
<script>
setSelect("Type","<%=jc.getType()%>");
windowResize();
setFocus("Name")
</script>
</body>
</html>
