<%@ page import="java.util.Enumeration" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">
<html>
<head>
<title>Here is what I found...</title>
</head>
<body>
<table>
<tr><th>Name</th><th>Value</th></tr>
<%
for (Enumeration<String> e = request.getParameterNames();e.hasMoreElements();) {
  String name = e.nextElement();
  String value = (String)request.getParameter(name);
  if (!value.equals("-select-") && value.length()>0) {
%>
<tr><td><%=name%></td><td><%=value%></td></tr>
<%
  }
}
%>
</table>
</body>
</html>