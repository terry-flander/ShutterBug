<%@ page import="au.com.fundfoto.shutterbug.entities.Report" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportParameter" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportParameterService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>

<%
  long ReportID = 0;  
  if (request.getParameter("ReportID") != null) {
    ReportID = Long.parseLong(request.getParameter("ReportID"));
  }
  long ParameterID = 0;  
  if (request.getParameter("ParameterID") != null) {
    ParameterID = Long.parseLong(request.getParameter("ParameterID"));
  }
  ReportParameter jp = new ReportParameterService().getReportParameter(ParameterID);
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
    editMode = (String)request.getParameter("editMode");
  }
%>


<html>
<head>
  <title>Report Parameter <%=editMode%></title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:300px;">
<form name="ReportParameterEdit" id="ReportParameterEdit" action="ReportParameterEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr>
  <td>
  <fieldset>
  <legend><%=editMode%> Report Parameter</legend>
  <table>
  <tr><td colspan="2" class="messageBox" id="message"></td></tr>
  <tr><td class="inputLabel">Parameter ID : </td><td class="inputField"><%=(jp.getParameterID()==0?"New":jp.getParameterID())%></td></tr>
  <tr><td class="inputLabel">Order : </td><td class="inputField"><input type="text" name="Order" value="<%=jp.getOrder()%>"></td></tr>
  <tr><td class="inputLabel">Code : </td><td class="inputField"><input type="text" name="Code" value="<%=jp.getCode()%>"></td></tr>
  <tr><td class="inputLabel">Description : </td><td class="inputField"><input type="text" name="Description" value="<%=jp.getDescription()%>"></td></tr>
  <tr><td class="inputLabel">Data Type : </td><td class="inputField"><select name="DataType" id="DataType"><%=OptionService.getHTMLOptionList("ParameterDataType")%></select></td></tr>
  <tr><td class="inputLabel">Validation : </td><td class="inputField"><input type="text" name="Validation" value="<%=jp.getValidation()%>"></td></tr>
 </table>
  </fieldset>
  </td>
</tr>
<tr>
  <td>
    <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
    <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
    <input type="hidden" name="ParameterID" value="<%=jp.getParameterID()%>">
    <input type="hidden" name="ReportID" value="<%=ReportID%>">    
    <input type="hidden" name="editMode" value="<%=editMode%>">    
  </td>
</tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>

<script>
setSelect('DataType','<%=jp.getDataType()%>');
windowResize();
setFocus("order");
</script>
</body>
</html>
