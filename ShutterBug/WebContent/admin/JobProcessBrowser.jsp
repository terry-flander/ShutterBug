<%@ page import="au.com.fundfoto.shutterbug.entities.JobCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobSession" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobSessionService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%@ page import="java.util.Hashtable" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
long JobCardID = Long.parseLong((String)request.getParameter("JobCardID"));
JobCardService jcs = new JobCardService();
JobCard jc = jcs.getJobCard(JobCardID);
Hashtable<String,JobCardService.DirectoryCount> dc = jcs.countDirectories(JobCardID);

%>
<html>
<head>
  <title>Job Sessions</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<table>
<tr><td>
<fieldset>
<legend><a href="JobCardBrowser.jsp?SessionCode=<%=SessionCode%>" style="font-family:Arial;"><img src="../images/list_icon.png" height="20px" title="Browse Job Cards"></a> Job Card 
    <a href="javascript:browseJobNames()">Names</a>
    <a href="javascript:browseJobPhotographers()">Photographers</a>
    <a href="javascript:browseJobProcesses()">Processes</a>
    <a href="javascript:browseJobSessions()">Sessions</a></legend>
    <table>
    <caption>JobProcessBrowser</caption>
    <tr><th>&nbsp;</th><th>Name</th><th>Code</th><th>Description</th><th>Type</th><th>Date</th><th>Start</th><th>End</th></tr>
    <tr class="oddRow">
    <td class="evenRow"><a href="javascript:editJobCard('<%=jc.getJobCardID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Job Card"></a></td>
    <td><%=jc.getName()%></td>
    <td><%=jc.getCode()%></td>
    <td><%=jc.getDescription()%></td>
    <td><%=jc.getType()%></td>
    <td><%=jc.getJobDate()%></td>
    <td><%=jc.getStartTime()%></td>
    <td><%=jc.getEndTime()%></td>
    </tr>
    </table>
</fieldset>
</td></tr>
<tr><td class="messageBox" id="message" colspan="2"></td></tr>
<tr>
  <td>
  <fieldset  style="background-image:url('../images/process_map.jpg');background-repeat:no-repeat;background-size:900px;height:600px;width:880px;">
<% if (dc.containsKey("MISSING")) { %>  
  <div style="position:absolute;top:120px;left:30px;"><input type="button" style="font-size:16px;" value="Create Directories" 
    onClick="requestProcess('CreateDirectories-g.jsp','Create Directories for Job and Job Photographers')"></div>
<% } else if (dc.containsKey("PHOTOGRAPHER")) { %>
  <div style="position:absolute;top:130px;left:220px;font-size:16px;color:white;"><a style="font-size:16px;color:white;" 
    href="javascript:openFinder('<%=dc.get("PHOTOGRAPHER").getDirPath()%>')">[<%=dc.get("PHOTOGRAPHER").getDisplayFileCount()%>]</a></div>
<% } else { %>
  <div style="position:absolute;top:130px;left:220px;font-size:16px;color:white;">WARNING: No Photographers Exist on the Job</div>
<% } %>
<% if (dc.containsKey("RAW")) {
     if (dc.get("RAW").getFileCount()==0) { %>  
  <div style="position:absolute;top:150px;left:480px;"><input type="button" style="font-size:16px;" value="Link PHOTOGRAPHER to RAW" onClick="requestProcess('PhotographerToRaw-g.jsp','Link PHOTOGRAPHER to RAW')"></div>
<%   } %>
  <div style="position:absolute;top:120px;left:500px;"><input type="button" style="font-size:16px;" value="Create new Shots from new RAW" onClick="requestProcess('ReconcileShots-g.jsp','Create new Shots from new RAW')"></div>
  <div style="position:absolute;top:170px;left:750px;"><a style="font-size:16px;color:white;" href="javascript:openFinder('<%=dc.get("RAW").getDirPath()%>')">[<%=dc.get("RAW").getDisplayFileCount()%>]</a></div>
<% } 
   if (dc.containsKey("JPG")) { %>
  <div style="position:absolute;top:260px;left:450px;"><a style="font-size:16px;color:white;" href="javascript:openFinder('<%=dc.get("JPG").getDirPath()%>')">[<%=dc.get("JPG").getDisplayFileCount()%>]</a></div>
<% } %>
<% if (dc.containsKey("RAW") && NameLoginService.allowFunction(SessionCode, "ConvertRawToJpg") && dc.get("RAW").getFileCount()!=0 && dc.get("JPG").getFileCount()==0) { %>
  <div style="position:absolute;top:290px;left:700px;"><input type="button" style="font-size:16px;" value="Convert RAW to JPG" onClick="requestProcess('ConvertRawToJpg-g.jsp','Convert RAW to JPG')"></div>
<% } %>
<% if (dc.containsKey("PROOF")) {   
     if (NameLoginService.allowFunction(SessionCode, "ConvertJpgToProof") && dc.get("PROOF").getFileCount()==0) { %>  
  <div style="position:absolute;top:360px;left:100px;"><input type="button" style="font-size:16px;" value="Convert JPG to PROOF" onClick="requestProcess('ConvertJpgToProof-g.jsp','Convert JPG to PROOF')"></div>
<%   } %>
<%   if (dc.get("PROOF").getTopFileCount()!=0) { %>  
  <div style="position:absolute;top:390px;left:30px;"><input type="button" style="font-size:16px;" value="Move PROOF to Subjects" onClick="requestProcess('JpgToProof-g.jsp','Copy Subject Proofs: JPG to PROOFS/Subject')"></div>
<%   } %>
  <div style="position:absolute;top:405px;left:250px;"><a style="font-size:16px;color:white;" href="javascript:openFinder('<%=dc.get("PROOF").getDirPath()%>')">[<%=dc.get("PROOF").getDisplayFileCount()%>]</a></div>
<% } %>
<% if (dc.containsKey("MOUNTS") && dc.get("MOUNTS").getFileCount()==-1) { %>  
  <div style="position:absolute;top:370px;left:390px;"><input type="button" style="font-size:16px;" value="Mounts: JPG to WORKING Subjects" onClick="requestProcess('MoveSubjectJpgToWorking-g.jsp','Mounts: JPG to WORKING Subjects')"></div>
<% } else { %>
  <div style="position:absolute;top:400px;left:410px;"><input type="button" style="font-size:16px;" value="Mounts: WORKING Subject to JPG" onClick="requestProcess('MoveSubjectWorkingToJpg-g.jsp','Mounts: WORKING Subjects to JPG')"></div>
<% } %>
  <div style="position:absolute;top:470px;left:480px;"><a style="font-size:16px;color:white;" href="javascript:openFinder('<%=dc.get("MOUNTS").getDirPath()%>')">[<%=dc.get("MOUNTS").getDisplayFileCount()%>]</a></div>
  <div style="position:absolute;top:470px;left:760px;"><a style="font-size:16px;color:white;" href="javascript:openFinder('<%=dc.get("ORDERS").getDirPath()%>')">[<%=dc.get("ORDERS").getDisplayFileCount()%>]</a></div>
<% if (dc.containsKey("ORDERS") && dc.get("ORDERS").getFileCount()==-1) { %>  
  <div style="position:absolute;top:370px;left:670px;"><input type="button" style="font-size:16px;" value="Orders: JPG to WORKING Orders" onClick="requestProcess('MoveJobJpgToWorking-g.jsp','Orders: JPG to WORKING Orders')"></div>
<% } else { %>
  <div style="position:absolute;top:400px;left:690px;"><input type="button" style="font-size:16px;" value="Orders: WORKING Orders to JPG" onClick="requestProcess('MoveJobWorkingToJpg-g.jsp','Orders: WORKING Orders to JPG')"></div>
<% } %>
 <div style="position:absolute;top:645px;left:420px;"><a style="font-size:16px;color:white;" href="javascript:openFinder('<%=dc.get("FTP").getDirPath()%>')">Open Finder</a></div>
<% if (dc.containsKey("ORDERS") && dc.get("ORDERS").getFileCount()!=-1 || dc.get("MOUNTS").getFileCount()!=-1) { %>  
  <div style="position:absolute;top:675px;left:650px;"><input type="button" style="font-size:16px;" value="WORKING to FTP" onClick="requestProcess('CopyWorkingToFtp-g.jsp','Copy All: WORKING to FTP')"></div>
<% } %>
  <div style="position:absolute;top:645px;left:100px;"><input type="button" style="font-size:16px;" value="Create Orders" onClick="requestProcess('CreateOrders-g.jsp','Create Orders for Job. Attach Subject Proofs.')"></div>
<% if (dc.containsKey("ORDERCARDS")) { %>  
  <div style="position:absolute;top:675px;left:140px;font-size:16px;color:white;">[<%=dc.get("ORDERCARDS").getDisplayFileCount()%>]</div>
<% } %>
  </fieldset>
  </td>
</tr>
</table>
<form name="RunProcess" id="RunProcess" target="hiddenFrame" method="post"><input type="hidden" name="JobCardID" value="<%=JobCardID%>"></form>
<form name="OpenFile" id="OpenFile" target="_new" method="post"></form>
<iframe name="hiddenFrame" id='hiddenFrame' class="hiddenFrame"></iframe>
<script>
function runProcess(url) {
	  var f = document.getElementById('RunProcess');
	  f.action = url;
	  f.submit();
	}
function openFile(url) {
  var f = document.getElementById('OpenFile');
  f.action = "file://" + url;
  alert("POST:"+f.action);
  f.submit();
}
function requestProcess(requestName, requestTitle) {
  var url = requestName + "?JobCardID=<%=JobCardID%>";
  openWindow(url,requestTitle);
}
function editJobCard(ID,editMode) {
  var url = "JobCardEdit-g.jsp?editMode="+editMode+"&JobCardID="+ID;
  var name = "Job Card Edit";
  openWindow(url,name);
}
function browseJobNames() {
  location.href = "JobRelationBrowser.jsp?JobCardID=<%=jc.getJobCardID()%>&SessionCode=<%=SessionCode%>";
}
function browseJobPhotographers() {
  location.href = "JobPhotographerBrowser.jsp?JobCardID=<%=jc.getJobCardID()%>&SessionCode=<%=SessionCode%>";
}
function browseJobProcesses() {
  location.href = "JobProcessBrowser.jsp?JobCardID=<%=jc.getJobCardID()%>&SessionCode=<%=SessionCode%>";
}
function browseJobSessions() {
  location.href = "JobSessionBrowser.jsp?JobCardID=<%=jc.getJobCardID()%>&SessionCode=<%=SessionCode%>";
}
function jobProcessSuccess() {
  location.href = "JobProcessBrowser.jsp?JobCardID=<%=jc.getJobCardID()%>&SessionCode=<%=SessionCode%>";
}
function openFinder(dirPath) {
	runProcess("OpenFinder-p.jsp?dirPath="+dirPath+"&JobCardID=<%=jc.getJobCardID()%>");
	//openFile(dirPath);
}
</script>
</body>
</html>

