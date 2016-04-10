<%@ page import="au.com.fundfoto.shutterbug.entities.NameCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameCardService" %>
<%
long NameCardID = 0;
if (request.getParameter("NameCardID") != null) {
  NameCardID = Long.parseLong(request.getParameter("NameCardID"));
}
boolean setNameCardID = (request.getParameter("setNameCardID")!=null && request.getParameter("setNameCardID").equals("true"));

NameCard nc = new NameCardService().getNameCard(NameCardID);

nc.setFirstName((String)request.getParameter("FirstName"));
nc.setMiddleName((String)request.getParameter("MiddleName"));
nc.setLastName((String)request.getParameter("LastName"));
nc.setCompanyName((String)request.getParameter("CompanyName"));
nc.setAddress((String)request.getParameter("Address"));
nc.setCity((String)request.getParameter("City"));
nc.setState((String)request.getParameter("State"));
nc.setPostCode((String)request.getParameter("PostCode"));
nc.setEmail((String)request.getParameter("Email"));
nc.setPhone((String)request.getParameter("Phone"));
nc.setMobile((String)request.getParameter("Mobile"));
nc.setBirthDate((String)request.getParameter("BirthDate"));

%>
<html>
<body>
<script>
<% if (nc.hasErrors()) { %>
     parent.errorMsg("<%=nc.getErrMsg()%>");
<% } else { 
     new NameCardService().saveNameCard(nc);
     if (setNameCardID) {
%>
       parent.setChoice('<%=nc.getNameCardID()%>','<%=nc.getLastName()%>, <%=nc.getFirstName()%>');
       parent.successClose();
<%   } else { %>
       parent.success();
<%   }
   } %>
</script>   
</body>
</html>