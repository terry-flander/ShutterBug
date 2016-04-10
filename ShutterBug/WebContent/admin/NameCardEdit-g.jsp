<%@ page import="au.com.fundfoto.shutterbug.entities.NameCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCardService" %>

<%
  long NameCardID = 0;  
  if (request.getParameter("NameCardID") != null) {
     NameCardID = Long.parseLong(request.getParameter("NameCardID"));
  }
  String setNameCardID = (request.getParameter("NameCardID")!=null?"true":"false");
  NameCard nc = new NameCardService().getNameCard(NameCardID);
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
     editMode = (String)request.getParameter("editMode");
  }
%>

<html>
<head>
  <title>Name Card <%=editMode%></title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:400px;">
<form name="NameCardEdit" id="NameCardEdit" action="NameCardEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr>
  <td>
    <fieldset>
    <legend><%=editMode%> Name Card</legend>
    <table>
    <tr><td class="messageBox" colspan="2" id="message"></td></tr>
    <tr><td class="inputLabel">Name Card ID : </td><td class="inputField"><%=(nc.getNameCardID()==0?"New":nc.getNameCardID())%></td></tr>
    <tr><td class="inputLabel">First Name : </td><td class="inputField"><input type="text" name="FirstName" id="FirstName" value="<%=nc.getFirstName()%>"></td></tr>
    <tr><td class="inputLabel">Middle Name : </td><td class="inputField"><input type="text" name="MiddleName" value="<%=nc.getMiddleName()%>"></td></tr>
    <tr><td class="inputLabel">Last Name : </td><td class="inputField"><input type="text" name="LastName" value="<%=nc.getLastName()%>"></td></tr>
    <tr><td class="inputLabel">Company : </td><td class="inputField"><input type="text" name="CompanyName" value="<%=nc.getCompanyName()%>"></td></tr>
    <tr><td class="inputLabel">Address : </td><td class="inputField"><input type="text" name="Address" value="<%=nc.getAddress()%>"></td></tr>
    <tr><td class="inputLabel">City : </td><td class="inputField"><input type="text" name="City" value="<%=nc.getCity()%>"></td></tr>
    <tr><td class="inputLabel">State : </td><td class="inputField">
    <select name="State" id="State">
    <option value="">-select-</option>
    <option value="ACT">ACT</option>
    <option value="NSW">NSW</option>
    <option value="NT">NT</option>
    <option value="QLD">QLD</option>
    <option value="SA">SA</option>
    <option value="TAS">TAS</option>
    <option value="VIC">VIC</option>
    <option value="WA">WA</option>
    </select>
    </td></tr>
    <tr><td class="inputLabel">PostCode : </td><td class="inputField"><input type="text" name="PostCode" value="<%=nc.getPostCode()%>"></td></tr>
    <tr><td class="inputLabel">eMail : </td><td class="inputField"><input type="text" name="Email" value="<%=nc.getEmail()%>"></td></tr>
    <tr><td class="inputLabel">Phone : </td><td class="inputField"><input type="text" name="Phone" value="<%=nc.getPhone()%>"></td></tr>
    <tr><td class="inputLabel">Mobile : </td><td class="inputField"><input type="text" name="Mobile" value="<%=nc.getMobile()%>"></td></tr>
    <tr><td class="inputLabel">Birth Date : </td><td class="inputField"><input type="text" name="BirthDate" value="<%=nc.getBirthDate()%>"></td></tr>
    </table>
    </fieldset>
  </td>
</tr>
<tr>
  <td>
    <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
    <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
    <input type="hidden" name="NameCardID" value="<%=nc.getNameCardID()%>">
    <input type="hidden" name="setNameCardID" value="<%=setNameCardID%>">
  </td>
</tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>

<script>
function setChoice(ID, Name) {
	try {
    window.opener.setNameCardID(ID, Name);
	} catch (e) {
		
	}
}
setSelect("State","<%=nc.getState()%>");
windowResize();
setFocus("FirstName");
</script>
</body>
</html>
