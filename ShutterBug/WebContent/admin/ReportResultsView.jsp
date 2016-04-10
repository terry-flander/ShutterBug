<%@ page import="au.com.fundfoto.shutterbug.entities.ReportResultsService" %>
<%ReportResultsService.writePdf((String)request.getParameter("fileName"),(String)request.getParameter("reportTitle"),response);
out.clear();
out = pageContext.pushBody();%>
<html>
  <head>
  <title>View Report Results</title>
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<script>
parent.success();
</script>
</body>
</html>