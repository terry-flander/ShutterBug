<%@ page import="au.com.fundfoto.shutterbug.entities.JobCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.Option" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>
<%@ page import="au.com.fundfoto.shutterbug.util.StringUtil" %>
<%@ page import="java.io.File" %>
<%
try {
  long JobCardID = 0;
  if (request.getParameter("JobCardID") != null) {
    JobCardID = Long.parseLong(request.getParameter("JobCardID"));
  }
	JobCard jc = new JobCardService().getJobCard(JobCardID);
	String processMsg = null;
	if (jc!=null) {
    Option[] dirs = new OptionService().getOptionList("CreateDirectories");
    String proofDir = null;
    String jpgDir = null;
    int totalPix = 0;
    for (int i=0;i<dirs.length;i++) {
      if (dirs[i].getOptionName().equals("PROOF")) {
        proofDir = dirs[i].getOptionValue();
      }
      if (dirs[i].getOptionName().equals("JPG")) {
        jpgDir = dirs[i].getOptionValue();
      }
    }
    File[] dirList = new File(jc.getBaseDirectory() + "/" + jpgDir).listFiles();
    for (int i=0;i<dirList.length;i++) {
      File f = dirList[i];
      String toFile = jc.getBaseDirectory() + "/" + proofDir + "/" + f.getName();
      new File(toFile).createNewFile();
      totalPix++;
    }
    processMsg = "Created: " + totalPix;
	} else {
	  processMsg = "Job does not exist";
	}
%>
<html>
<body>
<script>
parent.errorMsg("<%=processMsg%>");
</script>   
</body>
</html>
<% 
} catch (Exception e) {
  e.printStackTrace();
}
%>