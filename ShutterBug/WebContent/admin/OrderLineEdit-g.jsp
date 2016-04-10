<%@ page import="au.com.fundfoto.shutterbug.entities.OrderLine" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderPhoto" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderLineService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderSubject" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OrderSubjectService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.Shot" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ShotService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ProductCardService" %>
<%@ page import="java.util.Vector" %>

<%
  long OrderID = 0;  
  if (request.getParameter("OrderID") != null) {
     OrderID = Long.parseLong(request.getParameter("OrderID"));
  }
  long OrderLineID = 0;  
  if (request.getParameter("OrderLineID") != null) {
     OrderLineID = Long.parseLong(request.getParameter("OrderLineID"));
  }
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
     editMode = request.getParameter("editMode");
  }
  OrderLine ol = new OrderLineService().getOrderLine(OrderLineID);
  OrderSubject[] subs = new OrderSubjectService().getOrderSubjectList(OrderID);
  ShotService ss = new ShotService();
  StringBuffer shotList = new StringBuffer(100);
  for (int i=0;i<subs.length;i++) {
    OrderSubject os = (OrderSubject)subs[i];
    shotList.append(ss.getSubjectShotListHTML(os.getlSubjectID()));
  }
%>

<html>
<head>
  <title>Order Edit</title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:500px;">
<form name="OrderLineEdit" id="OrderLineEdit" action="OrderLineEdit-p.jsp" target="hiddenFrame" method="post">
<table><tr><td>
<table style="height:100%;">
<tr>
  <td>
    <fieldset>
    <legend><%=editMode%> Order Line</legend>
    <table>
    <tr><td class="messageBox" colspan="2" id="message"></td></tr>
    <tr><td class="inputLabel">OrderLineID : </td><td class="inputField"><%=(ol.getOrderLineID()==0?"New":ol.getOrderLineID())%></td></tr>
    <tr><td class="inputLabel">Product : </td><td class="inputField"><select name="ProductID" id="ProductID" onChange="setEnable()"><%=ProductCardService.getHTMLProductList()%></select></td></tr>
    <tr><td class="inputLabel">Quantity : </td><td class="inputField"><input type="text" name="Quantity" value="<%=ol.getQuantity()%>"></td></tr>
    </table>
    </fieldset>
    <fieldset>
    <legend>Options</legend>
    <table>
    <tr><th>Description</th><th>Selection</th></tr>
    <% Vector<String> v = ProductCardService.getProductOptions();
       for (int i=0;i<v.size();i++) {
         out.println((String)v.get(i));
       }
    %>
    </table>
    </fieldset>
    <fieldset>
    <legend>Photos</legend>
    <table>
    <tr><th>Order</th><th>Photo</th><th>Colour</th></tr>
    <% v = ProductCardService.getProductPhotos();
       for (int i=0;i<v.size();i++) {
         out.println(((String)v.get(i)).replaceAll("SUBJECT",shotList.toString()));
       }
    %>
    </table>
    </fieldset>
  </td>
  <td style="height:100%;vertical-align:top;">
    <fieldset style="height:100%;">
    <legend>Images</legend>
    <table>
    <tr><td><img id="productImage" src='../images/FundFotoLogo.jpg' width="150px"></td></tr>
    <tr><td><img id="mould_Image" src='../images/FundFotoLogo.jpg' width="150px"></td></tr>
    <tr><td><img id="mount_Image" src='../images/FundFotoLogo.jpg' width="150px"></td></tr>
    </table>
    </fieldset>
  </td>
</tr>
</table>
<table>
<tr>
  <td>
    <input type="button" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>" onClick="validate()">&nbsp;
    <input type="button" name="cancelButton" value="Cancel" onclick="cancel()">
    <input type="hidden" name="OrderID" value="<%=OrderID%>">
    <input type="hidden" name="OrderLineID" value="<%=OrderLineID%>">
    <input type="hidden" name="editMode" value="<%=editMode%>">
    <input type="hidden" name="allOptions" value="<%=ProductCardService.getAllOptions()%>">
    <input type="hidden" name="allPhotos" value="<%=ProductCardService.getAllPhotos()%>">
  </td>
</tr>
</table>
</td></tr></table>
</form>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</div>

<script>
function setEnable() {
  var ctrl = getControl();
  for (var i=0;i<allFields.length;i++) {
    var f = document.getElementById(allFields[i]);
    var c = document.getElementById(allFields[i].replace('photo','color'));
    if (ctrl.indexOf(allFields[i])!=-1) {
      f.style.visibility = 'visible';
   	  c.style.visibility = 'visible';
    } else {
      f.style.visibility = 'hidden';
      c.style.visibility = 'hidden';
    }
  }
  var img = document.getElementById('productImage');
  img.src = getImage();
  init();
}
function getControl() {
  var selectedid = 0;
  var id = document.getElementById('ProductID');
  if (id!=null) {
    for (var i=0; i < id.options.length; i++) {
    	if (id.options[i].value==id.value) {
        selectedid = i;
      }
    }
  }
  return controlList[selectedid];
}
function setOption(option) {
  var id = document.getElementById(option);
  var img = document.getElementById(option+"Image");
  if (id!=null && img!=null && id.value!='' && id.value!='N' && id.style.visibility=='visible') {
    img.src = "../images/" + id.value + ".jpg;";
  } else {
	  img.src = fundFotoLogo;
  }
}
function getImage() {
  var selectedid = 0;
  var id = document.getElementById('ProductID');
  if (id!=null) {
    for (var i=0; i < id.options.length; i++) {
      if (id.options[i].value==id.value) {
        selectedid = i;
      }
    }
  }
  return (productImageList[selectedid]!=""?'../images/' + productImageList[selectedid] + '.jpg':fundFotoLogo);
}
function init () {
<%
  String s[] = ol.getOptionList().split(";");
  for (int i=0;i<s.length;i++) {
  	String[] p = s[i].split(":");
  	if (p.length==2) {
  	  out.println("setSelect('"+ p[0] + "', '" + p[1] + "');");
  	}
  }
  Vector<OrderPhoto> ops = ol.getPhotos();
  for (int i=0;i<ops.size();i++) {
  	OrderPhoto op = ops.get(i);
    out.println("setSelect('photo"+ (i + 1) + "_', '" + op.getShotID() + "');");
    out.println("setSelect('color"+ (i + 1) + "_', '" + op.getColor() + "');");
  }
%>
setOption('mould_');
setOption('mount_');
}
function validate() {
	var ok = true;
  for (var i=0;i<allFields.length && ok;i++) {
    var f = document.getElementById(allFields[i]);
    var c = document.getElementById(allFields[i].replace('photo','color'));
    if ((f.style.visibility=='visible' && f.value=="") || (c.style.visibility=='visible' && c.value=="")) {
    	ok = false;
    }
  }
  if (ok) {
	  var f = document.getElementById('OrderLineEdit');
	  f.submit();
  } else {
	  alert("You must choose a value for all enabled fields.");
	  return;
  }
}
var fundFotoLogo = '../images/FundFotoLogo.jpg';
var allFields = '<%=ProductCardService.getAllOptions()%>,<%=ProductCardService.getAllPhotos()%>'.split(",");
<%
Vector<String> ctrl = ProductCardService.getProductControl();
out.println("var controlList=[");
for (int i=0;i<ctrl.size();i++) {
  out.println("'" + ctrl.get(i) + "'" + (i<ctrl.size() - 1?",":""));
}
out.println("];");
ctrl = ProductCardService.getAllProductImages();
out.println("var productImageList=[");
for (int i=0;i<ctrl.size();i++) {
  out.println("'" + ctrl.get(i) + "'" + (i<ctrl.size() - 1?",":""));
}
out.println("];");
%>
init();
setSelect('ProductID','<%=ol.getProductID()%>');;
setEnable();
windowResize();
setFocus("ProductID");
</script>
</body>
</html>

