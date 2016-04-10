<%@ page import="au.com.fundfoto.shutterbug.entities.OrderLine" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderPhoto" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderLineService" %>
<%@ page import="java.util.Vector" %>
<%
long OrderLineID = 0;
if (request.getParameter("OrderLineID") != null) {
  OrderLineID = Long.parseLong(request.getParameter("OrderLineID"));
}
long OrderID = 0;
if (request.getParameter("OrderID") != null) {
  OrderID = Long.parseLong(request.getParameter("OrderID"));
}
String editMode = "";
if (request.getParameter("editMode") != null) {
  editMode = (String)request.getParameter("editMode");
}
String allOptions = "";
if (request.getParameter("allOptions") != null) {
  allOptions = (String)request.getParameter("allOptions");
}
String allPhotos = "";
if (request.getParameter("allPhotos") != null) {
  allPhotos = (String)request.getParameter("allPhotos");
}

OrderLineService ols = new OrderLineService();
OrderLine ol = ols.getOrderLine(OrderLineID);

ol.setOrderID(OrderID);
ol.setProductID((String)request.getParameter("ProductID"));
ol.setQuantity((String)request.getParameter("Quantity"));

StringBuffer optionList = new StringBuffer();
String[] s = allOptions.split(",");
for (int i=0;i<s.length;i++) {
	if (request.getParameter(s[i])!=null) {
		if (optionList.length()>0) {
			optionList.append(";");
		}
	  optionList.append(s[i]+":"+(String)request.getParameter(s[i]));
	}
}
ol.setOptionList(optionList.toString());

Vector<OrderPhoto> photoList = new Vector<OrderPhoto>();
s = allPhotos.split(",");
for (int i=0;i<s.length;i++) {
  if (request.getParameter(s[i])!=null) {
    long shotID = Long.parseLong((String)request.getParameter(s[i]));
    String color = request.getParameter(s[i].replaceAll("photo","color"));
  	OrderPhoto of = new OrderPhoto();
  	of.setShotID(shotID);
  	of.setColor(color);
  	photoList.add(of);
  }
}
ol.setPhotos(photoList);
%>
<html>
<body>
<script>
<% if (ol.hasErrors()) { %>
     parent.errorMsg("<%=ol.getErrMsg()%>");
<% } else { 
	  if (editMode.equals("Delete")) {
	    ols.deleteOrderLine(ol);	    
	  } else {
	    ols.saveOrderLine(ol);
	  }
%>
     parent.success();
<% } %>
</script>   
</body>
</html>