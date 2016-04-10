<%@ page import="org.apache.log4j.*"%>
<%@ page import="au.com.fundfoto.shutterbug.entities.Report" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = request.getParameter("SessionCode"); 
if (!NameLoginService.accessOK(SessionCode)) {
   // response.sendRedirect("../login.html");
}
Logger.getRootLogger();
Logger logger = Logger.getLogger(this.getClass().getName());
Report[] res = new ReportService().getReportList();
%>
<html>
<head>
  <title>Report Menu</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<fieldset>
<legend>Report Menu</legend>
<table>
<caption>ReportMenu</caption>
<%
  for (int i=0;i<res.length;i++) { 
%>
  <tr>
  <td><td><a href="javascript:runReport('<%=res[i].getReportID()%>')"><%=res[i].getTitle()%></a></td><td><a href="javascript:viewResults('<%=res[i].getTitle()%>','<%=res[i].getReportID()%>')">View Results</a></td>
  </tr>
<% } %>
</table>
</fieldset>
<script>
function runReport(reportID) {
  openWindow("JasperReport-g.jsp?SessionCode=<%=SessionCode%>&ReportID="+reportID);
}
function viewResults(requestTitle, ID) {
  var url = "ReportResults.jsp?SessionCode=<%=SessionCode%>&ReportID="+ID;
  openWindow(url,requestTitle);
}
</script>
</body>
</html>