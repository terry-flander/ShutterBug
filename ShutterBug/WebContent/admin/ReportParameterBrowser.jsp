<%@ page import="au.com.fundfoto.shutterbug.entities.Report" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportParameter" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportParameterService" %>
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
<table>
<tr><td>
<fieldset>
<legend><a href="ReportBrowser.jsp?SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Reports"></a> Reports
  <a href="javascript:browseReportParameters('<%=re.getReportID()%>')">Parameters</a>
  <a href="javascript:browseReportResults('<%=re.getReportID()%>')">Results</a></legend>
<table>
<caption>ReportParameterBrowser</caption>
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
<legend>Parameters <a href="javascript:editParameter('0','Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Report Parameter"></a></legend>
  <table>
  <tr><th>&nbsp;</th><th>&nbsp;</th><th>Order</th><th>Code</th><th>Description</th><th>Data Type</th><th>Validation</th></tr>
<%
ReportParameter[] rps = new ReportParameterService().getReportParameterList(ReportID);
boolean odd = true;
for (int i=0;i<rps.length;i++) {
  ReportParameter rp = rps[i]; 
  String rowClass = (odd?"oddRow":"evenRow");
  odd = !odd;
%>
  <tr class="<%=rowClass%>">
  <td class="evenRow"><a href="javascript:editParameter('<%=rp.getParameterID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Report Parameter"></a></td>
  <td class="evenRow"><a href="javascript:editParameter('<%=rp.getParameterID()%>','Delete')"><img src="../images/delete_icon.jpg" height="20px" title="Delete Report Parameter"></a></td>
  <td><%=rp.getOrder()%></td>
  <td><%=rp.getCode()%></td>
  <td><%=rp.getDescription()%></td>
  <td><%=rp.getDataType()%></td>
  <td><%=rp.getValidation()%></td>
  </tr>
<%
} %>
</table>
</fieldset>
</td></tr>
</table>
<iframe name="hiddenFrame" id='hiddenFrame' class="hiddenFrame"></iframe>
<script>
function editParameter(ID,editMode) {
	var url = "ReportParameterEdit-g.jsp?ParameterID="+ID+"&ReportID=<%=ReportID%>&editMode="+editMode;
	var name = "Report Parameter Edit";
	openWindow(url,name);
}
function editReport(ID,editMode) {
  var url = "ReportEdit-g.jsp?ReportID="+ID+"&editMode="+editMode;
  var name = "Report Edit";
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

