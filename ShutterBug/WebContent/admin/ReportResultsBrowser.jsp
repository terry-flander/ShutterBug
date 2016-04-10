<%@ page import="au.com.fundfoto.shutterbug.entities.Report" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportResults" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportResultsService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
long ReportID = Long.parseLong((String)request.getParameter("ReportID"));
Report re = new ReportService().getReport(ReportID);
%>
<html>
<head>
  <title>Report Parameters</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:800px;">
<table>
<tr><td>
<fieldset>
<legend><a href="ReportBrowser.jsp?SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Reports"></a> Reports
  <a href="javascript:browseReportParameters('<%=re.getReportID()%>')">Parameters</a>
  <a href="javascript:browseReportResults('<%=re.getReportID()%>')">Results</a></legend>
<table>
<caption>ReportResultsBrowser</caption>
<tr><th>&nbsp;</th><th>Title</th><th>Description</th><th>Jasper File</th><th>Comments</th></tr>
  <tr class="oddRow">
  <td class="evenRow"><a href="javascript:editReport('<%=re.getReportID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Report"></a></td>
  <td><%=re.getTitle()%></td>
  <td><%=re.getDescription()%></td>
  <td><%=re.getJasperFile()%></td>
  <td><%=re.getComments()%></td>
  </tr>
</table>
</fieldset>
</td></tr>
<tr><td>
<fieldset>
<legend>Report Results</legend>
  <table>
  <tr><th>&nbsp;</th><th>Date Run</th><th>Run By</th><th>Parameters</th></tr>
<%
ReportResults[] rrs = new ReportResultsService().getReportResultsList(ReportID);
boolean odd = true;
for (int i=0;i<rrs.length;i++) {
  ReportResults rr = rrs[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td><a href="javascript:showReport('<%=rr.getFileName()%>')">View</a></td>
  <td><%=rr.getRunTime()%></td>
  <td><%=rr.getRunByID()%></td>
  <td><%=rr.getParameters()%></td>
  </tr>
<%
} %>
</table>
</fieldset>
</td></tr>
</table>
</div>
<iframe name="hiddenFrame" id='hiddenFrame' class="hiddenFrame"></iframe>
<script>
function editReport(ID,editMode) {
  var url = "ReportEdit-g.jsp?ReportID="+ID+"&editMode="+editMode;
  var name = "Report Edit";
  openWindow(url,name);
}
function showReport(fileName) {
  var url = "ReportResultsView.jsp?fileName="+fileName+"&reportTitle=<%=re.getTitle()%>";
	var name = "Report Results";
	openWindow(url,name);
}
function browseReportParameters(ID) {
  location.href = "ReportParameterBrowser.jsp?ReportID="+ID+"&SessionCode=<%=SessionCode%>";
}
function browseReportResults(ID) {
  location.href = "ReportResultsBrowser.jsp?ReportID="+ID+"&SessionCode=<%=SessionCode%>";
}
</script>
</body>
</html>

