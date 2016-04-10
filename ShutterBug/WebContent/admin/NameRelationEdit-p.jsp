<%@ page import="au.com.fundfoto.shutterbug.entities.NameRelation" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameRelationService" %>
<%
try {
long RelationID = 0;
if (request.getParameter("RelationID") != null) {
  RelationID = Long.parseLong(request.getParameter("RelationID"));
}
int ParentType = 0;
if (request.getParameter("ParentType") != null) {
  ParentType = Integer.parseInt(request.getParameter("ParentType"));
}
String editMode = "";
if (request.getParameter("editMode") != null) {
  editMode = (String)request.getParameter("editMode");
}

NameRelation nr = new NameRelationService().getNameRelation(RelationID);

nr.setParentType(ParentType);
nr.setParentID((String)request.getParameter("ParentID"));
nr.setChildID((String)request.getParameter("ChildID"));
nr.setRelationType((String)request.getParameter("RelationType"));
if (!editMode.equals("Delete") && new NameRelationService().duplicateCheck(nr)) {
  nr.addErrMsg("Name Relation for this Name and Type already exists.");
}

%>
<html>
<body>
<script>
<% if (nr.hasErrors()) { 
%>
     parent.errorMsg("<%=nr.getErrMsg()%>");
<% } else {
	   if (editMode.equals("Delete")) {
       new NameRelationService().deleteNameRelation(nr);
	   } else {
       new NameRelationService().saveNameRelation(nr);
	   }
%>
     parent.success();
<% } %>

</script>   
</body>
</html>
<% } catch (Exception e) {
     e.printStackTrace();
   }
%>