<%@ page import="au.com.fundfoto.shutterbug.entities.LoadSubject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.SubjectService" %>
<%@ page import="java.util.Vector" %>
<%
try {
  long JobSessionID = 0;
  StringBuffer errMsg = new StringBuffer();
  if (request.getParameter("JobSessionID") != null) {
    JobSessionID = Long.parseLong(request.getParameter("JobSessionID"));
  }
  int i = 0;
  Vector<LoadSubject> names = new Vector<LoadSubject>();
  while (i<100 && request.getParameter("subjectName_"+i)!=null) {
    String subjectNames = (String)request.getParameter("subjectName_"+i);
    String contactNames = (String)request.getParameter("contactName_"+i);
    String contactNumber = (String)request.getParameter("contactNumber_"+i);
    LoadSubject ls = new LoadSubject(subjectNames, contactNames, contactNumber);
    if (ls.notEmpty()) {
	    if (!ls.hasError()) {
	      names.add(ls);
	    } else {
	      errMsg.append(ls.getErrMsg());
	    }
    }
    i++;
  }
  if (errMsg.length()==0) {
    errMsg.append(new SubjectService().bulkLoad(JobSessionID, names));
  }

%>
<html>
<body>
<script>
<%   if (errMsg.length()>0) { %>
       parent.errorMsg(errMsg);
<%   } else { %>
       parent.success();
<%   } %>
</script>   
</body>
</html>
<% } catch (Exception e) {
     e.printStackTrace();
   }
%>
<%!
%>
