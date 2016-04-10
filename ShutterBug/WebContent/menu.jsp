<%@ page import="au.com.fundfoto.shutterbug.entities.NameCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = request.getParameter("SessionCode"); 
if (!NameLoginService.accessOK(SessionCode)) {
  response.sendRedirect("login.html");
}
NameCard nc = new NameCardService().getNameCard(SessionCode);
%>
<html>
<head>
  <title>ShutterBug Home</title>
  <link href="includes/shutterbug.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#8f8f8f">
<form id="postForm" action="" target="actionFrame" method="post">
<table class="menuHeader">
<tr><td><img src="images/FundFotoLogo.jpg" height="50px"></td><td align="left" style="font-weight:bold;font-size:12pt;">Hello <%=nc.getFirstName()%>, Welcome to ShutterBug!</td>
<td align="right"><a style="color:white; text-decoration:none;" href="login-g.jsp?SessionCode=<%=SessionCode%>">Log Off&nbsp;&nbsp;</a></td>
</tr></table>
<table class="menuBox"><tr>
  <td class="menuChoice" id="home" onClick="runFunction('admin/home.jsp','home')">Home
  <input type="hidden" value="<%=SessionCode%>" name="SessionCode"></td>
  <td class="menuChoice" id="names" onClick="runFunction('admin/NameCardBrowser.jsp','names')">Names</td>
  <td class="menuChoice" id="jobs" onClick="runFunction('admin/JobCardBrowser.jsp','jobs')">Jobs</td>
  <td class="menuChoice" id="orders" onClick="runFunction('admin/OrderBrowser.jsp','orders')">Orders</td>
  <td class="menuChoice" id="reports" onClick="runFunction('report/ReportMenu.jsp','reports')">Report Menu</td>
  <td class="menuChoice" id="preferences" onClick="runFunction('admin/SystemPreferences.jsp','preferences')">System Preferences
    <input type="hidden" name="orderFilter" id="orderFilter"/>
    <input type="hidden" name="orderStatus" id="orderStatus"/>
    <input type="hidden" name="nameFilter" id="nameFilter"/>
    <input type="hidden" name="jobFilter" id="jobFilter"/>
  </td>
</tr>
</table>
<table class="actionBox"><tr><td><iframe class="actionFrame" id="actionFrame" name="actionFrame" src="admin/home.jsp">&nbsp;</iframe></td></tr></table>
</form>

<script>
function runFunction(ref,menu) {
  setTab(menu);
  var f = document.getElementById("postForm");
  f.action = ref + "?SessionCode=<%=SessionCode%>";
  if (menu=="orders") {
	    f.action += "&OrderFilter="+document.getElementById("orderFilter").value+"&OrderStatus="+document.getElementById("orderStatus").value;
  } else if (menu=="names") {
	    f.action += "&NameFilter="+document.getElementById("nameFilter").value;
	} else if (menu=="jobs") {
	    f.action += "&JobFilter="+document.getElementById("jobFilter").value;
	  }
  f.submit();
}
function setTab(menu) {
  var mc = 'home,names,jobs,orders,reports,preferences'.split(',');
  for (var i=0;i<mc.length;i++) {
    var c = document.getElementById(mc[i]);
    c.setAttribute("style","");
    c.style.borderBottom = '1px';
    if (c.id==menu) {
      c.style.backgroundColor = '#FFFFFF';
      c.style.borderBottom = '0px';
    }
  }
}
function setOrderFilter(filter, status) {
	  document.getElementById("orderFilter").value = filter;
	  document.getElementById("orderStatus").value = status;
}
function setNameFilter(filter) {
  document.getElementById("nameFilter").value = filter;
}
function setJobFilter(filter) {
  document.getElementById("jobFilter").value = filter;
}
setTab('home');
</script>
</body>
</html>