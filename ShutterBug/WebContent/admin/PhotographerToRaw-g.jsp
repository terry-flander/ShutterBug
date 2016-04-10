<%
try {
  long JobCardID = 0;
  if (request.getParameter("JobCardID") != null) {
    JobCardID = Long.parseLong(request.getParameter("JobCardID"));
  }
%>
<html>
  <head>
  <title>Copy Photographer Files to RAW with Renaming</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:400px;">
<form name="runReport" id="runReport" action="PhotographerToRaw-p.jsp" target="hiddenFrame" method="post">
<table>
<tr><td>
  <fieldset>
  <legend>Link PHOTOGRAPHER Files to RAW with Renaming</legend>
    <table>
    <tr><td class="messageBox" colspan="2" id="message"></td></tr>
    <tr><td class="inputField"><input type="checkbox" name="doneOnly"></td><td class="inputLabel">Rename 'done' Subjects only?</td></tr>
    </table>
  </fieldset>
</td></tr>
<tr><td>
  <input type="button" name="saveButton" onclick="process()" value="Link">&nbsp;
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
