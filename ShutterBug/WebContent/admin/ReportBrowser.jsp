<%@ page import="au.com.fundfoto.shutterbug.entities.Report" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
if (!NameLoginService.accessOK(SessionCode)) {
   response.sendRedirect("../login.html");
}
%>
<html>
<head>
  <title>Browse and Maintain Report Definitions</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:700px;">
<table>
<tr><td style="border:none;">
<fieldset>
<legend>Reports <a href="javascript:editReport(0,'Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Report"></a></legend>
<table>
<caption>ReportBrowser</caption>
<tr><th>&nbsp;</th><th>Title</th><th>Description</th><th>Jasper File</th><th>Comments</th></tr>
<%
Report[] jcs = new ReportService().getReportList();
boolean odd = true;
for (int i=0;i<jcs.length;i++) {
  Report jc = jcs[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td><a href="javascript:browseReportParameters('<%=jc.getReportID()%>')"><img src="../images/choose_icon.jpg" height="20px" title="Choose"></a></td>
  <td><%=jc.getTitle()%></td>
  <td><%=jc.getDescription()%></td>
  <td><%=jc.getJasperFile()%></td>
  <td><%=jc.getComments()%></td>
  </tr>
<%
} %>
</table>
</fieldset>
</td></tr></table>
</div>
<script>
function editReport(ID,editMode) {
  var url = "ReportEdit-g.jsp?ReportID="+ID+"&editMode="+editMode;
  var name = "Report Edit";
  openWindow(url,name);
}
function browseReportParameters(ID) {
  location.href = "ReportParameterBrowser.jsp?ReportID="+ID+"&SessionCode=<%=SessionCode%>";
}
windowResize();
</script>
</body>
</html>

