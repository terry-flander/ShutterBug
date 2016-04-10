<%@ page import="au.com.fundfoto.shutterbug.entities.Subject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ShotService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SubjectService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobPhotographer" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobPhotographerService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>

<%
  String SessionCode = "";  
  if (request.getParameter("SessionCode") != null) {
    SessionCode = (String)request.getParameter("SessionCode");
  }
  long SubjectID = 0;  
  if (request.getParameter("SubjectID") != null) {
    SubjectID = Long.parseLong(request.getParameter("SubjectID"));
  }
  long SessionID = 0;  
  if (request.getParameter("SessionID") != null) {
    SessionID = Long.parseLong(request.getParameter("SessionID"));
  }
  long JobCardID = 0;  
  if (request.getParameter("JobCardID") != null) {
    JobCardID = Long.parseLong(request.getParameter("JobCardID"));
  }
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
    editMode = (String)request.getParameter("editMode");
  }
  Subject sc = new SubjectService().getSubject(SubjectID);
  JobPhotographer[] ncl = new JobPhotographerService().getJobPhotographerList(JobCardID);
%>

<html>
<head>
  <title><%=editMode%> Subject</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:300px;">
<form name="SubjectEdit" id="SubjectEdit" action="SubjectEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr>
  <td>
    <fieldset>
    <legend><%=editMode%> Subject</legend>
    <table>
    <tr><td colspan="2" class="messageBox" id="message"></td></tr>
    <tr><td class="inputLabel">Subject ID : </td><td class="inputField"><%=(sc.getSubjectID()==0?"New":sc.getSubjectID())%></td></tr>
    <tr><td class="inputLabel">Subject Code : </td><td class="inputField"><%=(sc.getSubjectID()==0?"New":sc.getSubjectCode())%></td></tr>
    <tr><td class="inputLabel">First Subject Name : </td><td class="inputField"><div id="FirstSubjectName"><%=sc.getFirstSubjectName()%></div></td></tr>
    <tr><td class="inputLabel">Relation Name : </td><td> <a href="javascript:chooseName()">Choose</a>&nbsp;<a href="javascript:editNameCard(0)">New</a></td></tr>
    <tr><td class="inputLabel">Photographer : </td><td class="inputField">
      <select name="PhotographerID" id="PhotographerID">
      <option value="0">-select-</option>
<%
for (int i=0;i<ncl.length;i++) {
  out.println("<option value=\"" + ncl[i].getNameCardID() + "\">" + ncl[i].getPhotographerName() + "</option>");
}
%>
      </select>
      </td>
    </tr>
    <tr><td class="inputLabel">First Shot : </td><td class="inputField"><input type="text" name="FirstShot" value="<%=sc.getFirstShot()%>"></td></tr>
    <tr><td class="inputLabel">Last Shot : </td><td class="inputField"><input type="text" name="LastShot" value="<%=sc.getLastShot()%>"></td></tr>
    <tr><td class="inputLabel">Mount : </td><td class="inputField"><select name="Mount" id="Mount"><option value="0">-none-</option><%=new ShotService().getSubjectShotListHTML(sc.getSubjectID())%></select></td></tr>
    <tr><td class="inputLabel">Status : </td><td class="inputField"><select name="Status" id="Status"><%=OptionService.getHTMLOptionList("SubjectStatus")%></select></td></tr>
    <tr><td class="inputLabel">Note : </td><td class="inputField"><input type="text" name="Note" value="<%=sc.getNote()%>"></td></tr>
    </table>
    </fieldset>
  </td>
</tr>
<tr>
  <td>
    <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
    <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
    <input type="hidden" name="SessionCode" value="<%=SessionCode%>">
    <input type="hidden" name="JobCardID" value="<%=JobCardID%>">
    <input type="hidden" name="SessionID" value="<%=SessionID%>">
    <input type="hidden" name="SubjectID" value="<%=SubjectID%>">
    <input type="hidden" name="NameCardID" id="NameCardID" value="<%=sc.getNameCardID()%>">
    <input type="hidden" name="SubjectCode" value="<%=sc.getSubjectCode()%>">
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
  var name = "First Subject Name Select";
  openWindow(url, name);
}
function editNameCard(ID) {
  var url = "NameCardEdit-g.jsp?NameCardID="+ID+"&setName=true";
  var name = "Name Card Edit";
  openWindow(url,name);
}
function setNameCardID(ID, Name) {
  var f = document.getElementById("FirstSubjectName");
  f.innerHTML = Name;
  f = document.getElementById("NameCardID");
  f.value = ID;
}
setSelect('Status','<%=sc.getStatus()%>');
setSelect('PhotographerID','<%=sc.getPhotographerID()%>');
setSelect('Mount','<%=sc.getMountShotID()%>');
windowResize();
</script>
</body>
</html>