<%@ page import="org.apache.log4j.*"%>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%@ page import="au.com.fundfoto.shutterbug.util.LoggerService" %>
<%
//Logger.getRootLogger();
LoggerService.configure();

String SessionCode = request.getParameter("SessionCode"); 
String LoginMessage = request.getParameter("LoginMessage");
if (LoginMessage==null) {
  LoginMessage="";
}
NameLoginService.logoffUser(SessionCode);
%>
<!DOCTYPE PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>ShutterBug Login</title>
  <link href="includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="includes/shutterbug.js"></script>
</head>
<body bgcolor="#8f8f8f">
<form name="LoginForm" id="LoginForm" action="login-p.jsp" method="post">
<table style="width:100%; height:100%;" >
<tr><td align="center" valign="middle">
<table>

<tr><td align="center"><img src="images/FundFotoLogo.jpg"></td></tr>
<tr align="center" valign="middle" style="background-color:white;"><td>
  <fieldset>
  <legend>ShutterBug Login</legend>
  <table>
  <tr><td class="inputLabel" style="color:white;">Login ID : </td><td class="inputField"><input type="text" style="width:100px;" name="LoginID" id="LoginID"></td></tr>
  <tr><td class="inputLabel" style="color:white;">Password : </td><td class="inputField"><input type="password" style="width:100px;" name="LoginPassword"></td></tr>
  <tr><td colspan="2" style="text-align:center; color:red;"><%=LoginMessage%></td></tr>
  <tr><td colspan="2"><input type="submit" name="loginButton" value="Login">&nbsp;</tr>
  </table>
  </fieldset>
</td></tr>
</table>
</table>
</form>
<script>
setFocus("LoginID");
</script>
</body>
</html>