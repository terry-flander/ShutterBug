<%@ page import="au.com.fundfoto.shutterbug.entities.NameCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCardService" %>
<html>
<head>
  <title>Name Card Select</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:500px;height:200;">
<form action="NameCardSelect-g.jsp" method="post" target="resultsForm">
  <table><tr><td style="border:none;">
  <fieldset>
  <legend>Find: <input type="text" name="NameFilter" id="NameFilter">&nbsp;<input type="submit" value="Filter"> 
  </legend>
  <iframe name="resultsForm" style="width:500px;height:200;border:none;"></iframe>
  </fieldset>
  </td>
  </tr>
  </table>
</form>
</div>
<script>
function setChoice(ID, Name) {
  window.opener.setNameCardID(ID,Name);
  self.close();
}
function windowResize() {
    var width = document.getElementById("resizeDiv").offsetWidth ;
    var height = document.getElementById("resizeDiv").offsetHeight ;
    window.resizeTo(width+100,height+200);
}
windowResize();
setFocus("NameFilter");
</script>
</body>
</html>

