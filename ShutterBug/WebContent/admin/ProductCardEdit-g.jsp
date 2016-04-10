<%@ page import="au.com.fundfoto.shutterbug.entities.ProductCard" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ProductCardService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService" %>

<%
  long ProductCardID = 0;  
  if (request.getParameter("ProductCardID") != null) {
     ProductCardID = Long.parseLong(request.getParameter("ProductCardID"));
  }
  ProductCard jc = new ProductCardService().getProductCard(ProductCardID);
  String productOptionsHTML = OptionService.getHTMLOptionList("ProductOptions");
  String photoSizesHTML = OptionService.getHTMLOptionList("size_");
  String productPhotosHTML = OptionService.getHTMLOptionList("ProductPhotos");
  String editMode = "";  
  if (request.getParameter("editMode") != null) {
     editMode = (String)request.getParameter("editMode");
  }
%>

<html>
  <head>
  <title>Job Card <%=editMode%></title>
  <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
  <script src="../includes/shutterbug.js"></script>
</head>
<body>
<div id="resizeDiv" style="width:400px;">
<form name="ProductCardEdit" id="ProductCardEdit" action="ProductCardEdit-p.jsp" target="hiddenFrame" method="post">
<table>
<tr><td>
  <fieldset>
  <legend><%=editMode%> Product Card</legend>
    <table>
    <tr><td class="messageBox" colspan="2" id="message"></td></tr>
    <tr><td class="inputLabel">Product Card ID : </td><td class="inputField"><%=(jc.getProductID()==0?"New":jc.getProductID())%></td></tr>
    <tr><td class="inputLabel">Description : </td><td class="inputField"><input type="text" name="ProductDescription" id="ProductDescription" value="<%=jc.getProductDescription()%>"></td></tr>
    <tr><td class="inputLabel">Image : </td><td class="inputField"><input type="text" name="ProductImage" id="ProductImage" value="<%=jc.getProductImage()%>"></td></tr>
    <tr><td class="inputLabel">Type : </td><td class="inputField"><select name="ProductType" id="Type"><%=OptionService.getHTMLOptionList("ProductTypes")%></select></td></tr>
    <tr><td class="inputLabel">Cost : </td><td class="inputField"><input type="text" style="width:200px;" name="Cost" value="<%=jc.getCost()%>"></td></tr>
    <tr><td class="inputLabel">Price : </td><td class="inputField"><input type="text" style="width:200px;" name="Price" value="<%=jc.getPrice()%>"></td></tr>
    <tr><td colspan="2">
    </table>
  </fieldset>
  <fieldset>
    <legend>Options: <a href="JavaScript:addRow('option')"><img src="../images/add_icon.jpg" height="20px" title="Add Option"></a></legend>
    <table id='optionTable'>
    <tr id="optionRow"><th>Option</th></tr>
    </table>
  </fieldset>
  <fieldset>
    <legend>Photos:  <a href="JavaScript:addRow('photo')"><img src="../images/add_icon.jpg" height="20px" title="Add Photo"></a></legend>
    <table id='photoTable'>
    <tr id="photoRow"><th>Position</th><th>Size</th></tr>
    </table>
  </fieldset>
</td></tr>
<tr><td>
  <input type="submit" name="saveButton" value="<%=(editMode.equals("Edit")?"Save":editMode)%>">&nbsp;
  <input type="button" name="submitter" value="Cancel" onclick="cancel()">
  <input type="hidden" name="ProductCardID" value="<%=jc.getProductID()%>">
  <input type="hidden" name="editMode" value="<%=editMode%>">
</td></tr>
</table>
<iframe name="hiddenFrame" class="hiddenFrame"></iframe>
</form>
</div>
<script>
var loadData = ['option=<%=jc.getOptionList()%>',
                'photo=<%=jc.getPhotoList()%>'];
var tables = ['option','photo'];
var line = [0, 0];
var fieldNames = 
	['option_',
	 'position_,size_'];
var fieldList = 
	['option_','position_','size_'];
var fieldHTML = 
	['<select name="option_LN" id="option_LN"><option value="">-select-</option><%=productOptionsHTML%></selection>',
   '<select name="position_LN" id="position_LN"><option value="">0</option><%=productPhotosHTML%></select>',
   '<select name="size_LN" id="size_LN"><option value="">-select-</option><%=photoSizesHTML%></select>'];
function addRow(tableName) {
   var t=document.getElementById(tableName+"Table");
   var tableNo = getTableNo(tableName);
   line[tableNo]++;
   var fns = fieldNames[tableNo].split(",");
   var n=t.insertRow(-1);
   for (var i=0;i<fns.length;i++) {
     var fieldName = fns[i];
     var c=n.insertCell(-1);
     c.style.verticalAlign = 'top';
     var fieldHTML = getFieldHTML(fieldName);
     fieldHTML = fieldHTML.replace(/LN/gi,line[tableNo]);
     c.innerHTML = fieldHTML;
   }
}
function init() {
  doDataLoad();
  setSelect("Type","<%=jc.getProductType()%>");
  setFocus("ProductDescription")
  windowResize();
}
function getTableNo(tableName) {
  var result = -1;
  for (var i=0;i<tables.length && result==-1;i++) {
   if (tableName==tables[i]) {
      result = i;
    }
  }
  return result;
}
function getFieldHTML(fieldName) {
  var result = '';
  for (var i=0;i<fieldList.length && result=='';i++) {
    if (fieldName==fieldList[i]) {
        result = fieldHTML[i];
    }
  }
  return result;
}
function doDataLoad() {
	for (var i=0;i<loadData.length;i++) {
		var f = loadData[i].split("=");
	  var tableName = f[0];
    var tableNo = getTableNo(tableName);
    var rows = f[1].split(";");
    for (var j=0;j<rows.length;j++) {
      addRow(tableName);
      var c = rows[j].split(":");
      var fields = fieldNames[tableNo].split(",");
      for (var k=0;k<c.length;k++) {
        var fieldName = fields[k]+line[tableNo];
        selectValueSet(fieldName, c[k]);
      }
    }
  }
}
function selectValueSet(selectName, value) {
  try{
    selectObject = document.getElementById(selectName);
    if (selectObject!=null) {
	    for (var i=0; i<selectObject.length; i++) {
	      if (selectObject[i].value==value) {
	        selectObject.selectedIndex = i;
	      }
	    }
	    selectObject.value = value;
    }
  } catch (e) {
    //alert("Could not set: "+selectName+" to "+value);
  }
}
init();
</script>

</body>
</html>
