<%@ page import="au.com.fundfoto.shutterbug.entities.ProductCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ProductCardService" %>
<%
long ProductCardID = 0;
if (request.getParameter("ProductCardID") != null) {
  ProductCardID = Long.parseLong(request.getParameter("ProductCardID"));
}
String editMode = "";
if (request.getParameter("editMode") != null) {
  editMode = (String)request.getParameter("editMode");
}

ProductCard pc = new ProductCardService().getProductCard(ProductCardID);

pc.setProductDescription((String)request.getParameter("ProductDescription"));
pc.setProductImage((String)request.getParameter("ProductImage"));
pc.setProductType((String)request.getParameter("ProductType"));
pc.setCost((String)request.getParameter("Cost"));
pc.setPrice((String)request.getParameter("Price"));

StringBuffer optionList = new StringBuffer();
int i = 1;
while (request.getParameter("option_"+i)!=null) {
	if (optionList.length()>0) {
		optionList.append(";");
	}
	if ((String)request.getParameter("option_"+i)!="") {
	  optionList.append((String)request.getParameter("option_"+i));
	}
	i++;
}
pc.setOptionList(optionList.toString());
StringBuffer photoList = new StringBuffer();
i = 1;
while (request.getParameter("position_"+i)!=null) {
  if (photoList.length()>0) {
    photoList.append(";");
  }
  if ((String)request.getParameter("position_"+i)!="") {
    photoList.append((String)request.getParameter("position_"+i)+":"+(String)request.getParameter("size_"+i));
  }
  i++;
}
pc.setPhotoList(photoList.toString());

%>
<html>
<body>
<script>
<% if (!pc.hasErrors() && editMode.equals("Delete")) {
     new ProductCardService().deleteProductCard(pc);
   } else {
     new ProductCardService().saveProductCard(pc);
   }
   if (pc.hasErrors()) { 
%>
     parent.errorMsg("<%=pc.getErrMsg()%>");
<% } else { %>
    parent.success();
<% } %>
</script>   
</body>
</html>