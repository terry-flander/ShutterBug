<%@ page import="au.com.fundfoto.shutterbug.entities.Report" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>

<%
  long ReportID = 0;  
  if (request.getParameter("ReportID") != null) {
     ReportID = Long.parseLong(request.getParameter("ReportID"));
  }
  Report re = new ReportService().getReport(ReportID);
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
     editMode = (String)request.getParameter("editMode");
  }
%>

<html>
  <head>
  <title>Report <%=editMode%></title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:550px;">
<form name="ReportEdit" id="ReportEdit" action="ReportEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr><td>
  <fieldset>
  <legend><%=editMode%> Report</legend>
    <table>
    <tr><td class="messageBox" colspan="2" id="message"></td></tr>
    <tr><td class="inputLabel">Report ID : </td><td class="inputField"><%=(re.getReportID()==0?"New":re.getReportID())%></td></tr>
    <tr><td class="inputLabel">Title : </td><td class="inputField"><input type="text" name="Title" id="Title" value="<%=re.getTitle()%>"></td></tr>
    <tr><td class="inputLabel">Description : </td><td class="inputField"><input type="text" style="width:400px;" name="Description" value="<%=re.getDescription()%>"></td></tr>
    <tr><td class="inputLabel">Jasper File : </td><td class="inputField"><input type="text" style="width:400px;" name="JasperFile" value="<%=re.getJasperFile()%>"></td></tr>
    <tr><td class="inputLabel">Comments : </td><td class="inputField"><input type="text" style="width:400px;" name="Comments" value="<%=re.getComments()%>"></td></tr>
    </table>
  </fieldset>
</td></tr>
<tr><td>
  <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
  <input type="button" name="submitter" value="Cancel" onclick="cancel()">
  <input type="hidden" name="ReportID" value="<%=re.getReportID()%>">
</td></tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>
<script>
windowResize();
setFocus("Title")
</script>
</body>
</html>
