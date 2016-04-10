<%@ page import="au.com.fundfoto.shutterbug.entities.JobCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobSession" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobSessionService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobPhotographer" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.JobPhotographerService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.Subject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SubjectService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.Option" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>
<%@ page import="au.com.fundfoto.shutterbug.util.StringUtil" %>
<%@ page import="java.io.File" %>
<%
try {
  String JobCode = null;
  if (request.getParameter("JobCode") != null) {
    JobCode = (String)request.getParameter("JobCode");
  }
	JobCard jc = new JobCardService().getJobCard(JobCode);
	String processMsg = null;
	if (jc!=null) {
    JobPhotographer[] photographers = new JobPhotographerService().getJobPhotographerList(jc.getJobCardID());
    JobSession[] jcs = new JobSessionService().getJobSessionList(jc.getJobCardID());
    Option[] dirs = new OptionService().getOptionList("CreateDirectories");
    String photoDir = null;
    for (int i=0;i<dirs.length;i++) {
      if (dirs[i].getOptionName().equals("PHOTOGRAPHER")) {
        photoDir = dirs[i].getOptionValue().substring(0,dirs[i].getOptionValue().indexOf("${Directory}"));
      }
    }
    int totalPix = 0; 
    int ranged = 0;
    for (int i=0;i<jcs.length;i++) {
      Subject[] sus = new SubjectService().getSubjectList(jcs[i].getSessionID());
      for (int j=0;j<sus.length;j++) {
        Subject su = sus[j];
        JobPhotographer jp = null;
        String PhotographerCode = "";
        for (int k=0;k<photographers.length && jp==null;k++) {
          if (photographers[k].getNameCardID()==su.getPhotographerID()) {
            jp = photographers[k];
            PhotographerCode = jp.getPhotographerInitials();
          }
        }
        if (jp!=null) {
          String sourceDir = photoDir + jp.getDirectory() + "/";
          ranged += su.getiLastShot() - su.getiFirstShot() + 1;
          int pixId = su.getiFirstShot() - 1;
          while (pixId<su.getiLastShot()) {
            pixId++;
            String fromFile = jc.getBaseDirectory() + "/" + sourceDir + StringUtil.formatNumber(pixId,jp.getFormat());;
            File f = new File(fromFile);
            f.getParentFile().mkdirs();
            f.createNewFile();
            totalPix++;
          }
        } // Subjects
      } // Sessions
    }
    processMsg = "Created: " + totalPix + " Range: " + ranged;
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