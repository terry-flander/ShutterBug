<%@ page import="au.com.fundfoto.shutterbug.entities.Report" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportParameter" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportParameterService" %>
<%
long ReportID = 0;
if (request.getParameter("ReportID") != null) {
   ReportID = Long.parseLong(request.getParameter("ReportID"));
}
String SessionCode = null;
if (request.getParameter("SessionCode") != null) {
   SessionCode = (String)request.getParameter("SessionCode");
}
Report re = new ReportService().getReport(ReportID);
ReportParameter[] rps = new ReportParameterService().getReportParameterList(re.getReportID());
boolean hasParameters = rps!=null && rps.length>0;
%>
<html>
  <head>
  <title>Run <%=re.getTitle()%></title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:400px;">
<form name="runReport" id="runReport" action="JasperReport-p.jsp" target="hiddenFrame" method="post">
<table>
<tr><td>
  <fieldset>
  <legend><%=re.getTitle()%> Parameters</legend>
    <table>
    <tr><td class="messageBox" colspan="2" id="message"></td></tr>
<% if (hasParameters) { %>
<% for (int i=0;i<rps.length;i++) {
     ReportParameter rp = rps[i]; %>
    <tr><td class="inputLabel"><%=rp.getDescription()%> : </td><td class="inputField"><%=rp.getParameterHTML()%></td></tr>
<% } %>
<% } else { %>
    <tr><td class="inputLabel" colspan="2">-- None --</td></tr>
<% } %>
    </table>
  </fieldset>
</td></tr>
<tr><td>
  <input type="button" name="saveButton" value="Run Report" onclick="process()">&nbsp;
  <input type="button" name="submitter" value="Cancel" onclick="cancel()">
  <input type="hidden" name="ReportID" value="<%=ReportID%>">
  <input type="hidden" name="SessionCode" value="<%=SessionCode%>">
</td></tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>
<script>
function process() {
  var f = document.getElementById("message");
  f.innerHTML = '<b>Working...</b>';
  f = document.getElementById("runReport");
  f.submit();
}
windowResize();
</script>
</body>
</html>
