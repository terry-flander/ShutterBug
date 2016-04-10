<%
try {
  long JobCardID = 0;
  if (request.getParameter("JobCardID") != null) {
    JobCardID = Long.parseLong(request.getParameter("JobCardID"));
  }
%>
<html>
  <head>
  <title>Move WORKING Subject Mounts to JPG</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:400px;">
<form name="runReport" id="runReport" action="MoveSubjectWorkingToJpg-p.jsp" target="hiddenFrame" method="post">
<table>
<tr><td>
  <fieldset>
  <legend>Move WORKING Subject Mounts to JPG</legend>
    <table>
    <tr><td class="messageBox" colspan="2" id="message"></td></tr>
    </table>
  </fieldset>
</td></tr>
<tr><td>
  <input type="button" name="saveButton" value="Move" onclick="process()">&nbsp;
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
