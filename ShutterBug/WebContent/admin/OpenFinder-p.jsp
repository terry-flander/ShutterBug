<%@ page import="au.com.fundfoto.shutterbug.util.FileUtil" %>
<%
try {
  String dirPath = (request.getParameter("dirPath")!=null?request.getParameter("dirPath"):"");
  FileUtil.openFinder(dirPath);
} catch (Exception e) {
  e.printStackTrace();
}
%>