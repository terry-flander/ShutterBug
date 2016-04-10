<%
try {
  long JobCardID = 0;
  if (request.getParameter("JobCardID") != null) {
    JobCardID = Long.parseLong(request.getParameter("JobCardID"));
  }
%>
<html>
  <head>
  <title>Convert JPG to PROOF</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:400px;">
<form name="runReport" id="runReport" action="ConvertJpgToProof-p.jsp" target="hiddenFrame" method="post">
<table>
<tr><td>
  <fieldset>
  <legend>Convert JPG to PROOF</legend>
    <table>
    <tr><td class="messageBox" colspan="2" id="message"></td></tr>
    </table>
  </fieldset>
</td></tr>
<tr><td>
  <input type="button" name="saveButton" value="Convert" onclick="process()">&nbsp;
  <input type="button" name="submitter" value="Cancel" onclick="cancel()">
  <input type="hidden" name="JobCardID" value="<%=JobCardID%>">
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
function jobSuccess() {
  window.opener.jobProcessSuccess();
  self.close();
}
windowResize();
</script>
</body>
</html>
<%
} catch (Exception e) {
  // oops
} %>
