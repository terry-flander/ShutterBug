<%@ page import="au.com.fundfoto.shutterbug.entities.NameCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameRelation" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameRelationService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>

<%
  int ParentType = 0;  
  if (request.getParameter("ParentType") != null) {
    ParentType = Integer.parseInt(request.getParameter("ParentType"));
  }
  long ParentID = 0;  
  if (request.getParameter("ParentID") != null) {
    ParentID = Long.parseLong(request.getParameter("ParentID"));
  }
  long RelationID = 0;  
  if (request.getParameter("RelationID") != null) {
    RelationID = Long.parseLong(request.getParameter("RelationID"));
  }
  NameRelation nr = new NameRelationService().getNameRelation(RelationID);
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
    editMode = (String)request.getParameter("editMode");
  }
  NameCard nc = new NameCardService().getNameCard(nr.getlChildID());
%>

<html>
<head>
  <title>Name Relation <%=editMode%></title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:300px;">
<form name="NameRelationEdit" id="NameRelationEdit" action="NameRelationEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr>
  <td>
  <fieldset>
  <legend><%=editMode%> Name Card Relation</legend>
  <table>
  <tr><td colspan="2" class="messageBox" id="message"></td></tr>
  <tr><td class="inputLabel">Name Relation ID : </td><td class="inputField"><%=(nr.getRelationID()==0?"New":nr.getRelationID())%></td></tr>
  <tr><td class="inputLabel">Type : </td><td class="inputField"><select name="RelationType" id="RelationType"><%=OptionService.getHTMLOptionList("NameRelations")%></select></td></tr>
  <tr><td class="inputLabel">Relation Name : </td><td class="inputField"><div id=ChildName> <%=nc.getLastName()%>, <%=nc.getFirstName()%></div></td></tr>
  <% if (editMode.equals("Add")) { %>
  <tr><td class="inputLabel">Relation Name : </td>
  <td>
    <a href="javascript:chooseName()">Choose</a>&nbsp;
    <a href="javascript:editNameCard(0)">New</a>
  </td></tr>
  <% } %>
  </table>
  </fieldset>
  </td>
</tr>
<tr>
  <td>
    <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
    <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
    <input type="hidden" name="RelationID" value="<%=nr.getRelationID()%>">
    <input type="hidden" name="ParentType" value="<%=ParentType%>">    
    <input type="hidden" name="ParentID" value="<%=ParentID%>">    
    <input type="hidden" name="ChildID" id="ChildID" value="<%=nr.getChildID()%>">    
    <input type="hidden" name="editMode" value="<%=editMode%>">    
  </td>
</tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>

<script>
function chooseName() {
  var url = "NameCardSelect.jsp";
  var name = "Name Relation Select";
  openWindow(url, name);
}

function setNameCardID(ID, Name) {
  var f = document.getElementById("ChildName");
  f.innerHTML = Name;
  f = document.getElementById("ChildID");
  f.value = ID;
}
function editNameCard(ID) {
  var url = "NameCardEdit-g.jsp?NameCardID="+ID+"&setName=true";
  var name = "Name Card Edit";
  openWindow(url,name);
}
setSelect('RelationType','<%=nr.getRelationType()%>');
windowResize();
<% if (editMode.equals("Add")) { %>
setFocus("RelationType");
<% } else { %>
var s = document.getElementById("RelationType");
s.disabled = true;
<% } %>
</script>
</body>
</html>
