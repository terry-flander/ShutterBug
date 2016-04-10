<%@ page import="au.com.fundfoto.shutterbug.entities.NameCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLogin" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>

<%
  long NameCardID = 0;  
  if (request.getParameter("NameCardID") != null) {
    NameCardID = Long.parseLong(request.getParameter("NameCardID"));
  }
  long NameLoginID = 0;  
  if (request.getParameter("NameLoginID") != null) {
    NameLoginID = Long.parseLong(request.getParameter("NameLoginID"));
  }
  NameLogin nl = NameLoginService.getNameLogin(NameLoginID);
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
    editMode = (String)request.getParameter("editMode");
  }
%>

<html>
<head>
  <title>Name Login <%=editMode%></title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:300px;">
<form name="NameLoginEdit" id="NameLoginEdit" action="NameLoginEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr>
  <td>
  <fieldset>
  <legend><%=editMode%> Name Card Login</legend>
  <table>
  <tr><td colspan="2" class="messageBox" id="message"></td></tr>
  <tr><td class="inputLabel">Name Login ID : </td><td class="inputField"><%=(nl.getNameLoginID()==0?"New":nl.getNameLoginID())%></td></tr>
  <tr><td class="inputLabel">Login ID : </td><td class="inputField"><input type="text" name="LoginID" id="LoginID" value="<%=nl.getLoginID()%>"></td></tr>
  <tr><td class="inputLabel">Login Password : </td><td class="inputField"><input type="text" name="LoginPassword" id="LoginPassword" value="<%=nl.getLoginPassword()%>"></td></tr>
  <tr><td class="inputLabel">Status : </td><td class="inputField"><select name="Status" id="Status"><%=OptionService.getHTMLOptionList("LoginStatus")%></select></td></tr>
  <tr><td class="inputLabel">Access Level : </td><td class="inputField"><select name="AccessLevel" id="AccessLevel"><%=OptionService.getHTMLOptionList("LoginAccessLevel")%></select></td></tr>
  <tr><td class="inputLabel">Date Created : </td><td class="inputField"><div id=DateCreated> <%=nl.getDateCreated()%></div></td></tr>
  <tr><td class="inputLabel">Last Login : </td><td class="inputField"><div id=LastLogin> <%=nl.getLastLogin()%></div></td></tr>
  </table>
  </fieldset>
  </td>
</tr>
<tr>
  <td>
    <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
    <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
    <input type="hidden" name="NameLoginID" value="<%=nl.getNameLoginID()%>">
    <input type="hidden" name="NameCardID" value="<%=NameCardID%>">    
    <input type="hidden" name="editMode" value="<%=editMode%>">    
  </td>
</tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>

<script>
setSelect('Status','<%=nl.getStatus()%>');
setSelect('AccessLevel','<%=nl.getAccessLevel()%>');
windowResize();
setFocus("LoginID");
</script>
</body>
</html>
