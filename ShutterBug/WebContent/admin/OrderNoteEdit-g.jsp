<%@ page import="au.com.fundfoto.shutterbug.entities.OrderNote" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderNoteService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>

<%
  long OrderID = 0;  
  if (request.getParameter("OrderID") != null) {
    OrderID = Long.parseLong(request.getParameter("OrderID"));
  }
  long OrderNoteID = 0;  
  if (request.getParameter("OrderNoteID") != null) {
    OrderNoteID = Long.parseLong(request.getParameter("OrderNoteID"));
  }
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
    editMode = (String)request.getParameter("editMode");
  }
  String SessionCode = "";  
  if (request.getParameter("SessionCode") != null) {
    SessionCode = (String)request.getParameter("SessionCode");
  }
  OrderNoteService ns = new OrderNoteService();
  ns.setSessionCode(SessionCode);
  OrderNote on = ns.getOrderNote(OrderNoteID);
%>

<html>
<head>
  <title>Order Subject <%=editMode%></title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:500px;">
<form name="OrderNoteEdit" id="OrderNoteEdit" action="OrderNoteEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr>
  <td>
  <fieldset>
  <legend><%=editMode%> Order Note</legend>
  <table>
  <tr><td colspan="2" class="messageBox" id="message"></td></tr>
  <tr><td class="inputLabel">Order Note ID : </td><td class="inputField"><%=(on.getOrderNoteID()==0?"New":on.getOrderNoteID())%></td></tr>
  <tr><td class="inputLabel" valign="top">Note : </td><td class="inputField"><textarea name="NoteText" id="NoteText" cols="50" rows="10"><%=on.getNoteText()%></textarea></td></tr>
  <tr><td class="inputLabel">Order Date : </td><td class="inputField"><%=on.getNoteDate()%></td></tr>
  <tr><td class="inputLabel">Order User : </td><td class="inputField"><%=on.getNoteName()%></td></tr>
  </table>
  </fieldset>
  </td>
</tr>
<tr>
  <td>
    <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
    <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
    <input type="hidden" name="OrderID" value="<%=OrderID%>">
    <input type="hidden" name="OrderNoteID" value="<%=OrderNoteID%>">    
    <input type="hidden" name="SessionCode" value="<%=SessionCode%>">    
    <input type="hidden" name="editMode" value="<%=editMode%>">    
  </td>
</tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>

<script>
windowResize();
</script>
</body>
</html>
