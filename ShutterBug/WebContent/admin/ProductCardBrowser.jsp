<%@ page import="au.com.fundfoto.shutterbug.entities.ProductCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ProductCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%
String SessionCode = (String)request.getParameter("SessionCode");
if (!NameLoginService.accessOK(SessionCode)) {
   response.sendRedirect("../login.html");
}
%>
<html>
<head>
  <title>Browse and Maintain Product Cards</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:700px;">
<table><tr><td style="border:none;">
	<fieldset>
	<legend>Products <a href="javascript:editProductCard(0,'Add')" style="font-family:Arial;"><img src="../images/add_icon.jpg" height="20px" title="Add New Product"></a></legend>
	<table>
	<caption>ProductCardBrowser</caption>
	<tr><th>&nbsp;</th><th>&nbsp;</th><th>Description</th><th>Type</th><th>Option List</th><th>Photo List</th><th>Cost</th><th>Price</th></tr>
	<%
	ProductCard[] pcs = new ProductCardService().getProductCardList();
	boolean odd = true;
	for (int i=0;i<pcs.length;i++) {
	  ProductCard pc = pcs[i]; 
	  String rowClass = (odd?"oddRow":"evenRow");
	  odd = !odd;
	%>
	<tr class="<%=rowClass%>">
    <td><a href="javascript:editProductCard('<%=pc.getProductID()%>','Edit')"><img src="../images/edit_icon.jpg" height="20px" title="Edit Product"></a></td>
    <td><a href="javascript:editProductCard('<%=pc.getProductID()%>','Delete')"><img src="../images/delete_icon.jpg" height="20px" title="Delete Product"></a></td>
		<td><%=pc.getProductDescription()%></td>
		<td><%=pc.getProductType()%></td>
		<td><%=pc.getOptionList()%></td>
		<td><%=pc.getPhotoList()%></td>
		<td><%=pc.getCost()%></td>
		<td><%=pc.getPrice()%></td>
	</tr>
	<%
	} %>
	</table>
	</fieldset>
</td></tr></table>
</div>
<script>
function editProductCard(ID,editMode) {
  var url = "ProductCardEdit-g.jsp?ProductCardID="+ID+"&editMode="+editMode;
  var name = "Product Card Edit";
  openWindow(url,name);
}
function browseOptions(ID) {
  location.href = "ProductOptionBrowser.jsp?ProductCardID="+ID+"&SessionCode=<%=SessionCode%>";
}
windowResize();
</script>
</body>
</html>

