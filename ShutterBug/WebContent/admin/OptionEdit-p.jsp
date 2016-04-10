<%@ page import="au.com.fundfoto.shutterbug.entities.Option" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>
<%
try {
	long OptionID = 0;
	if (request.getParameter("OptionID") != null) {
	  OptionID = Long.parseLong(request.getParameter("OptionID"));
	}
	long SelectionID = 0;
	if (request.getParameter("SelectionID") != null) {
	  SelectionID = Long.parseLong(request.getParameter("SelectionID"));
	}
  String editMode = "";
  if (request.getParameter("editMode") != null) {
    editMode = (String)request.getParameter("editMode");
  }

  Option op = new OptionService().getOption(OptionID);

  op.setSelectionID(SelectionID);
  op.setOptionID(OptionID);
  op.setOptionName((String)request.getParameter("OptionName"));
  op.setOptionValue((String)request.getParameter("OptionValue"));
  op.setOptionAttributes((String)request.getParameter("OptionAttributes"));
  if (!editMode.equals("Delete") && new OptionService().duplicateCheck(op)) {
    op.addErrMsg("Option Value for this Selection already exists.");
  }

%>
<html>
<body>
<script>
<% 
if (op.hasErrors()) { %>
parent.errorMsg("<%=op.getErrMsg()%>");
<% 
} else {
  if (editMode.equals("Delete")) {
    new OptionService().deleteOption(op);
	} else {
    new OptionService().saveOption(op);
	}
%>
if ('<%=editMode%>'!='Add') {
  parent.success();
} else {
  parent.reset("OptionValue,OptionName","OptionName");
}
<% 
} %>

</script>   
</body>
</html>
<% } catch (Exception e) {
     e.printStackTrace();
   }
%>