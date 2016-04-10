<html>
  <head>
  <title>Touch Photographer Files for Job In Photographer Directories</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:400px;">
<form name="runReport" id="runReport" action="TouchRawForJob-p.jsp" target="hiddenFrame" method="post">
<table>
<tr><td>
  <fieldset>
  <legend>Touch Photographer Files for JobCode In Photographer Directories</legend>
    <table>
    <tr><td class="messageBox" colspan="2" id="message"></td></tr>
    <tr><td class="inputField">Job Code: <input type="text" name="JobCode"></td></tr>
    </table>
  </fieldset>
</td></tr>
<tr><td>
  <input type="submit" name="saveButton" value="Touch">&nbsp;
  <input type="button" name="submitter" value="Cancel" onclick="cancel()">
</td></tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>
<script>
windowResize();
</script>
</body>
</html>
