<%@ page import="au.com.fundfoto.shutterbug.entities.OrderSubject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderSubjectService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>

<%
  long OrderID = 0;  
  if (request.getParameter("OrderID") != null) {
    OrderID = Long.parseLong(request.getParameter("OrderID"));
  }
  long OrderSubjectID = 0;  
  if (request.getParameter("OrderSubjectID") != null) {
    OrderSubjectID = Long.parseLong(request.getParameter("OrderSubjectID"));
  }
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
    editMode = (String)request.getParameter("editMode");
  }
  OrderSubject os = new OrderSubjectService().getOrderSubject(OrderSubjectID);
%>

<html>
<head>
  <title>Order Subject <%=editMode%></title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:300px;">
<form name="OrderSubjectEdit" id="OrderSubjectEdit" action="OrderSubjectEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr>
  <td>
  <fieldset>
  <legend><%=editMode%> Order Subject</legend>
  <table>
  <tr><td colspan="2" class="messageBox" id="message"></td></tr>
  <tr><td class="inputLabel">Order Subject ID : </td><td class="inputField"><%=(os.getOrderSubjectID()==0?"New":os.getOrderSubjectID())%></td></tr>
  <tr><td class="inputLabel">Subject Name : </td><td class="inputField"><div id=SubjectName> <%=os.getSubjectName()%></div></td></tr>
  <% if (editMode.equals("Add")) { %>
  <tr><td class="inputLabel">Subject : </td>
  <td>
    <a href="javascript:chooseSubject()">Choose</a>
  </td></tr>
  <tr><td colspan="2"><input type="checkbox" name="MergeOrders"> Merge open Order(s) for this Subject?</td></tr>
  <% } %>
  </table>
  </fieldset>
  </td>
</tr>
<tr>
  <td>
    <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
    <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
    <input type="hidden" name="OrderID" value="<%=OrderID%>">
    <input type="hidden" name="OrderSubjectID" id="OrderSubjectID" value="<%=OrderSubjectID%>">    
    <input type="hidden" name="SubjectID" id="SubjectID" value="<%=os.getlSubjectID()%>">    
    <input type="hidden" name="editMode" value="<%=editMode%>">    
  </td>
</tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>

<script>
function chooseSubject() {
  var url = "SubjectSelect.jsp";
  var name = "Subject Select";
  openWindow(url, name);
}

function setSubjectID(ID, Name) {
  var f = document.getElementById("SubjectName");
  f.innerHTML = Name;
  f = document.getElementById("SubjectID");
  f.value = ID;
}
windowResize();
</script>
</body>
</html>
