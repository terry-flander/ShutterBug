<%@ page import="au.com.fundfoto.shutterbug.entities.Report" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportResults" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportResultsService" %>
<%
long ReportID = Long.parseLong((String)request.getParameter("ReportID"));
Report re = new ReportService().getReport(ReportID);
%>
<html>
<head>
  <title><%=re.getTitle()%> Results</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:600px;">
<fieldset>
<legend><%=re.getTitle()%> Results</legend>
<table>
<caption>ReportResults</caption>
<tr><th>Action</th><th>ID</th><th>Date Run</th><th>Run By</th><th>Parameters</th></tr>
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
  <td><%=rr.getResultsID()%></td>
  <td><%=rr.getRunTime()%></td>
  <td><%=rr.getRunByName()%></td>
  <td><%=rr.getParameters()%></td>
  </tr>
<%
} %>
</table>
</fieldset>
</div>
<iframe name="hiddenFrame" id='hiddenFrame' class="hiddenFrame"></iframe>
<script>
function showReport(fileName) {
  var url = "../admin/ReportResultsView.jsp?fileName="+fileName+"&reportTitle=<%=re.getTitle()%>";
	var name = "Report Results";
	var settings="width=1,height=1,top=1,left=1,location=no,scrollbars=no,directories=no,status=no,menubar=no,toolbar=no,resizable=no";
	var w=window.open(url,name,settings);
	//w.close();
}
windowResize();
</script>
</body>
</html>

