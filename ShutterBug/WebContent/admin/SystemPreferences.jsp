<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
%>
<html>
<head>
  <title>System Preferences</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<table>
<tr><td>
  <fieldset>
  <legend>System Preferences</legend>
  <table>
  <tr><td><a href="javascript:requestProcess('SelectionBrowser.jsp','Browse and Maintain Selection Lists')">Selection Maintenance</a></td><td>Setup configuration parameters</td></tr>
  <tr><td><a href="javascript:requestProcess('ReportBrowser.jsp','Browse and Maintain Report Descriptions')">Report Maintenance</a></td><td>Setup Jasper reports and parameters</td></tr>
  <tr><td><a href="javascript:requestProcess('NameCardMerge.jsp','Merge Duplicate Name Card Records')">Merge Names</a></td><td>Select NameCards and merge contents.</td></tr>
  <tr><td><a href="javascript:requestProcess('ProductCardBrowser.jsp','Browse and Maintain Product Cards')">Product Maintenance</a></td><td>Create and Update ShutterBug Products.</td></tr>
<% if (NameLoginService.allowFunction(SessionCode, "TouchRawForJob")) { %>
  <tr><td><a href="javascript:requestProcess('../util/TouchRawForJob-g.jsp','Copy All: WORKING to FTP')">Touch Camera Files</a></td><td>Touch Camera Files for Job.</td></tr>
<% } %>
  <tr><td><a href="../report/ShowLog-g.jsp" target="_new">Show Log</a></td><td>Create and Update ShutterBug Products.</td></tr>
  </table>
  </fieldset>
  </td>
</tr>
</table>
<script>
function requestProcess(requestName, requestTitle) {
  var url = requestName + "?SessionCode=<%=SessionCode%>";
  openWindow(url,requestTitle);
}
</script>
</body>
</html>

