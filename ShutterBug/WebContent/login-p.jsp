<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String LoginID = request.getParameter("LoginID"); 
String LoginPassword = request.getParameter("LoginPassword"); 
String SessionCode = NameLoginService.loginUser(LoginID, LoginPassword);
if (SessionCode==null) {
  response.sendRedirect("login-g.jsp?LoginMessage=Login ID/Password Invalid.");
} else {
%>
<html>
<body>
<script>
  function postwith (to,p) {
	  var myForm = document.createElement("form");
	  myForm.method="post" ;
	  myForm.action = to ;
	  for (var k in p) {
	    var myInput = document.createElement("input") ;
	    myInput.setAttribute("name", k) ;
	    myInput.setAttribute("value", p[k]);
	    myForm.appendChild(myInput) ;
	  }
	  document.body.appendChild(myForm) ;
	  myForm.submit() ;
	  document.body.removeChild(myForm) ;
  }
  postwith('menu.jsp',{SessionCode:'<%=SessionCode%>'});
</script>
</body>
<%
  //response.sendRedirect("menu.jsp?SessionCode="+SessionCode);
}
%>
