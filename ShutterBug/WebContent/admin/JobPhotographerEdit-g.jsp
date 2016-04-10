<%@ page import="au.com.fundfoto.shutterbug.entities.JobCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobPhotographer" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobPhotographerService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>
<%@ page import="org.apache.log4j.*"%>

<%
  Logger logger = Logger.getLogger("JobPhotographerEdit-g");
  long JobCardID = 0;  
  if (request.getParameter("JobCardID") != null) {
    JobCardID = Long.parseLong(request.getParameter("JobCardID"));
  }
  long JobPhotographerID = 0;  
  if (request.getParameter("JobPhotographerID") != null) {
    JobPhotographerID = Long.parseLong(request.getParameter("JobPhotographerID"));
  }
  JobPhotographer jp = new JobPhotographerService().getJobPhotographer(JobPhotographerID);
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
    editMode = (String)request.getParameter("editMode");
  }
  NameCard[] ncl = null;
  try {
    long companyID = Long.parseLong(OptionService.getOptionValue("Setup","CompanyNameCardID"));
    String relationType = OptionService.getOptionValue("Setup","PhotographerRelation"); 
    ncl = new NameCardService().getNameCardList(companyID, relationType);
  } catch (Exception e) {
    logger.warn("Unable to get NameCardList "+e.getMessage());
  }
%>


<html>
<head>
  <title>Name Job Photographer <%=editMode%></title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:400px;">
<form name="JobPhotographerEdit" id="JobPhotographerEdit" action="JobPhotographerEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr>
  <td>
  <fieldset>
  <legend>Job Photographer</legend>
  <table>
  <tr><td colspan="2" class="messageBox" id="message"></td></tr>
  <tr><td class="inputLabel">Job Photographer ID : </td><td class="inputField"><%=(jp.getJobPhotographerID()==0?"New":jp.getJobPhotographerID())%></td></tr>
  <tr><td class="inputLabel">Photographer Name : </td><td class="inputField">
    <select name="NameCardID" id="NameCardID">
    <option value="">-select-</option>
    <%
    if (ncl!=null) {
      for (int i=0;i<ncl.length;i++) {
        out.println("<option value=\"" + ncl[i].getNameCardID() + "\">" + ncl[i].getLastName() + ", " + ncl[i].getFirstName() + "</option>");
      }
    }
    %>
    </select>
    </td>
  </tr>
  <tr><td class="inputLabel">Directory : </td><td class="inputField"><input type="text" name="Directory" value="<%=jp.getDirectory()%>"></td></tr>
  <tr><td class="inputLabel">Format (####=Number) : </td><td class="inputField"><input type="text" name="Format" value="<%=jp.getFormat()%>"></td></tr>
  </table>
  </fieldset>
  </td>
</tr>
<tr>
  <td>
    <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
    <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
    <input type="hidden" name="JobPhotographerID" value="<%=jp.getJobPhotographerID()%>">
    <input type="hidden" name="JobCardID" value="<%=JobCardID%>">    
    <input type="hidden" name="editMode" value="<%=editMode%>">    
  </td>
</tr>
</table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>

<script>
setSelect('NameCardID','<%=jp.getNameCardID()%>');
windowResize();
setFocus("NameCardID");
</script>
</body>
</html>
