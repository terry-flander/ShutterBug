<html>
	<head>
		<title>FundFoto Order Form</title>
    <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
	</head>
	<body>
	<form action="PhotoOrder-p.jsp" method="POST">
	<table style="border:solid black 1px;">
	<tr><th>Product</th><th>Description</th><th align="right">Quantity</th><th align="right">Total</th></tr>
	<tr class="productRow"><td colspan="2"><a id="comboShow" href="JavaScript:showTable('combo')">Combo Framed Prints</a></td><td class="qtyTotal" id="comboQty"></td><td class="priceTotal" id="comboTotal"></td></tr>
  <tr id="comboRow" style="visibility:hidden">
    <td>&nbsp;</td>
    <td colspan="3">
      <table class="productDetail" id="comboTable"><tr><th>Qty</th><th>Frame Mould</th><th>Photo 1</th><th>Color?</th><th>Photo 2</th><th>Color?</th><th>Photo 3</th><th>Color?</th><th>Photo 4</th><th>Color?</th><th>&nbsp;</th></tr></table>
    </td>
  </tr>
  <tr class="productRow"><td colspan="2"><a id="quadShow" href="JavaScript:showTable('quad')">Quad Framed Prints</a></td><td class="qtyTotal" id="quadQty"></td><td class="priceTotal" id="quadTotal"></td></tr>
  <tr id="quadRow" style="visibility:hidden"><td>&nbsp;</td><td colspan="3"><table class="productDetail" id="quadTable"><tr><th>Qty</th><th>Size</th><th>Frame Mould</th><th>Photo 1</th><th>Color?</th><th>Photo 2</th><th>Color?</th><th>Photo 3</th><th>Color?</th><th>Photo 4</th><th>Color?</th><th>&nbsp;</th></tr></table></td></tr>
  <tr class="productRow"><td colspan="2"><a id="tripleShow" href="JavaScript:showTable('triple')">Triple Framed Prints</a></td><td class="qtyTotal" id="tripleQty"></td><td class="priceTotal" id="tripleTotal"></td></tr>
  <tr id="tripleRow" style="visibility:hidden"><td>&nbsp;</td><td colspan="3"><table class="productDetail" id="tripleTable"><tr><th>Qty</th><th>Size</th><th>Frame Mould</th><th>Photo 1</th><th>Color?</th><th>Photo 2</th><th>Color?</th><th>Photo 3</th><th>Color?</th><th>&nbsp;</th></tr></table></td></tr>
  <tr class="productRow"><td colspan="2"><a id="doubleShow" href="JavaScript:showTable('double')">Double Framed Prints</a></td><td class="qtyTotal" id="doubleQty"></td><td class="priceTotal" id="doubleTotal"></td></tr>
  <tr id="doubleRow" style="visibility:hidden"><td>&nbsp;</td><td colspan="3"><table class="productDetail" id="doubleTable"><tr><th>Qty</th><th>Size</th><th>Frame Mould</th><th>Photo 1</th><th>Color?</th><th>Photo 2</th><th>Color?</th><th>&nbsp;</th></tr></table></td></tr>
  <tr class="productRow"><td colspan="2"><a id="singleShow" href="JavaScript:showTable('single')">Single Framed Prints</a></td><td class="qtyTotal" id="singleQty"></td><td class="priceTotal" id="singleTotal"></td></tr>
  <tr id="singleRow" style="visibility:hidden"><td>&nbsp;</td><td colspan="3"><table class="productDetail" id="singleTable"><tr><th>Qty</th><th>Size</th><th>Frame Mould</th><th>Photo 1</th><th>Color?</th><th>&nbsp;</th></tr></table></td></tr>
  <tr class="productRow"><td colspan="2"><a id="canvasShow" href="JavaScript:showTable('canvas')">Canvas Prints</a></td><td class="qtyTotal" id="canvasQty"></td><td class="priceTotal" id="canvasTotal"></td></tr>
  <tr id="canvasRow" style="visibility:hidden"><td>&nbsp;</td><td colspan="3"><table class="productDetail" id="canvasTable"><tr><th>Qty</th><th>Size</th><th>Photo 1</th><th>Color?</th><th>&nbsp;</th></tr></table></td></tr>
  <tr class="productRow"><td colspan="2"><a id="looseShow" href="JavaScript:showTable('loose')">Loose Prints</a></td><td class="qtyTotal" id="looseQty"></td><td class="priceTotal" id="looseTotal"></td></tr>
  <tr id="looseRow" style="visibility:hidden"><td>&nbsp;</td><td colspan="3"><table class="productDetail" id="looseTable"><tr><th>Qty</th><th>Size</th><th>Mount?</th><th>Photo 1</th><th>Color?</th><th>&nbsp;</th></tr></table></td></tr>
  <tr class="productRow"><td colspan="2">Order Total</td><td class="qtyTotal" id="orderQty"></td><td class="priceTotal" id="orderTotal"></td></tr>
  </table>
  <input type="button" value="Recalculate" onClick="recalculate();">
  <input type="submit" value="Save">
	</form>
<SCRIPT>
var tables = ['combo','quad','triple','double','single','canvas','loose'];
var line = [1, 1, 1, 1, 1, 1, 1];
var fieldNames = ['qty_,mould_,photo_1,color_1,photo_2,color_2,photo_3,color_3,photo_4,color_4',
                  'qty_,sizeo_,mould_,photo_1,color_1,photo_2,color_2,photo_3,color_3,photo_4,color_4', 
                  'qty_,sizehv_,mould_,photo_1,color_1,photo_2,color_2,photo_3,color_3', 
                  'qty_,sizehv_,mould_,photo_1,color_1,photo_2,color_2', 
                  'qty_,sizes_,mould_,photo_1,color_1', 
                  'qty_,sizec_,photo_1,color_1', 
                  'qty_,sizel_,mount_,photo_1,color_1' 
                  ];
var fieldList = [  'qty_','sizel_','sizec_','sizes_','sizehv_','sizeo_','mould_','photo_1','photo_2','photo_3','photo_4','color_1','color_2', 'color_3', 'color_4', 'mount_'];
var fieldHTML = [	'<select name="qty_PXLN" id="qty_PXLN"><option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option><option>6</option><option>7</option><option>8</option><option>9</option><option>10</option></select>',
                '<select name="size_PXLN" id="size_PXLN"><option>-select-</option><option value="5X7">5 x 7</option><option value="6X9">6 x 9</option><option value="8X12">8 x 12</option><option value="10X15">10 x 15</option><option value="13X20">13 x 20</option><option value="20X30">20 x 30</option></select>',
                '<select name="size_PXLN" id="size_PXLN"><option>-select-</option><option value="10X15">10 x 15</option><option value="13X20">13 x 20</option><option value="20X30">20 x 30</option><option value="26X40">26 x 40</option></select>',
                '<select name="size_PXLN" id="size_PXLN"><option>-select-</option><option value="6X9">6 x 9</option><option value="8X12">8 x 12</option><option value="10X15">10 x 15</option><option value="13X20">13 x 20</option><option value="20X30">20 x 30</option><option value="26X40">26 x 40</option></select>',
                '<select name="size_PXLN" id="size_PXLN"><option>-select-</option><option value="6X9">6 x 9 Horizontal</option><option value="8X12">8 x 12 Horizontal</option><option value="6X9">6 x 9 Vertical</option><option value="8X12">8 x 12 Vertical</option></select>',
                '<select name="size_PXLN" id="size_PXLN"><option>-select-</option><option value="6X9">6 x 9</option><option value="8X12">8 x 12</option></select>',
                '<select name="mould_PXLN" id="mould_PXLN"><option>-select-</option><option value="WC">White - Classic</option><option value="BC">Black - Classic</option><option value="SC">Silver - Classic</option><option value="MC">Mocha - Classic</option><option value="WS">White - Slim Line</option><option value="BS">Black - Slim Line</option><option value="SS">Silver - Slim Line</option><option value="WS">Woodgrain - Slim Line</option><option value="CS">Charcoal - Slim Line</option></select>',
                '<select name="photo_1PXLN" id="photo_1PXLN">SHOTS</select>',
                '<select name="photo_2PXLN" id="photo_2PXLN">SHOTS</select>',
                '<select name="photo_3PXLN" id="photo_3PXLN">SHOTS</select>',
                '<select name="photo_4PXLN" id="photo_4PXLN">SHOTS</select>',
                '<select name="color_1PXLN" id="color_1PXLN"><option>-select-</option><option value="C">Colour</option><option value="B">B &amp; W</option></selection>',
                '<select name="color_2PXLN" id="color_2PXLN"><option>-select-</option><option value="C">Colour</option><option value="B">B &amp; W</option></selection>',
                '<select name="color_3PXLN" id="color_3PXLN"><option>-select-</option><option value="C">Colour</option><option value="B">B &amp; W</option></selection>',
                '<select name="color_4PXLN" id="color_4PXLN"><option>-select-</option><option value="C">Colour</option><option value="B">B &amp; W</option></selection>',
                '<select name="mount_PXLN" id="mount_PXLN"><option>-select-</option><option value="Y">Yes</option><option value="N">No</option></selection>'];
var priceList = [ ':445',
                  '6X9:465;8X12:675',
                  '6X9:375;8X12:575',
                  '6X9:255;8X12:375',
                  '6X9:150;8X12:200;10X15:260;13X20:465;20X30:685;26X40:935',
                  '10X15:265;13X20:425;20X30:685;26X40:885',
                  '5X7:65;6X9:65;8X12:95;10X15:145;13X20:285;20X30:445'];                
var shotList = '<option value="">-select-</option><option>FSTT0101</option><option>FSTT0102</option><option>FSTT0103</option><option>FSTT0103</option><option>FSTT0104</option><option>FSTT0105</option><option>FSTT0106</option><option>FSTT0107</option><option>FSTT0108</option><option>FSTT0109</option><option>FSTT0110</option>';
var loadData = 'combo=1:WS:FSTT0101:C:FST0102:B:FSTT0104:B:FSTT0104:C';

function showTable(tableName) {
  var t=document.getElementById(tableName+"Row");
	var a=document.getElementById(tableName+"Show");
  if (t.style.visibility=="visible") {
	  t.style.visibility = "hidden";
  } else {
	  t.style.visibility = "visible";
  }
}
function addRow(tableName) {
	  var t=document.getElementById(tableName+"Table");
	  var tableNo = getTableNo(tableName);
	  var fns = fieldNames[tableNo].split(",");
	  var n=t.insertRow(-1);
	  for (var i=0;i<fns.length;i++) {
		  var fieldName = fns[i];
		  var c=n.insertCell(-1);
		  c.style.verticalAlign = 'top';
		  var fieldHTML = getFieldHTML(fieldName);
		  fieldHTML = fieldHTML.replace(/PX/gi,tableName);
	    fieldHTML = fieldHTML.replace(/LN/gi,line[tableNo]+1);
	    fieldHTML = fieldHTML.replace(/SHOTS/gi,shotList);
		  c.innerHTML = fieldHTML;
    }
	  line[tableNo]++;
}
function init() {
	for (var tbl=0;tbl<tables.length;tbl++) {
		var tableName = tables[tbl];
	  var t=document.getElementById(tableName+"Table");
	  var n=t.insertRow(-1);
	  var fns = fieldNames[tbl].split(",");
	  for (var i=0;i<fns.length;i++) {
      var fieldName = fns[i];
	    var c=n.insertCell(-1);
	    c.style.verticalAlign = 'top';
      var fieldHTML = getFieldHTML(fieldName);
      fieldHTML = fieldHTML.replace(/PX/gi,tableName);
      fieldHTML = fieldHTML.replace(/LN/gi,1);
      fieldHTML = fieldHTML.replace(/SHOTS/gi,shotList);
      c.innerHTML = fieldHTML;
	  }
    c=n.insertCell(-1);
    c.style.verticalAlign = 'top';
    c.innerHTML = "<a href=\"JavaScript:addRow('" + tableName + "')\">Add</a>";
	}
	doDataLoad();
	recalculate();
}
function recalculate() {
	var orderQty = 0;
	var orderTotal = 0;
  for (var tbl=0;tbl<tables.length;tbl++) {
    var tableName = tables[tbl];
    var qtyTotal = 0;
    var priceTotal = 0;
    for (var i=1;i<=line[tbl];i++) {
      var qty = document.getElementById('qty_'+tableName+i).value;
      if (qty>0) {
        var size = '';
        if (tbl>0) {
          size = document.getElementById('size_'+tableName+i).value;
    	  }
        var prices = priceList[tbl].split(";");
        var price = 0;
        for (var j=0;j<prices.length && price==0;j++) {
        	var p = prices[j].split(":");
        	if (p[0]==size) {
        		price = p[1];
        	}
        }
        var mount = document.getElementById('mount_'+tableName+i);
        if (mount!=null && mount.value == "Y") {
            if (document.getElementById('photo_1'+tableName+i).value == "") {
        		  price = 15 * 1;
        	  } else {
        		  price = (price * 1) + (15 * 1);
        	  }
         
        }
        qtyTotal += (qty * 1);
        priceTotal += (price * 1) * qty;
      }
    }
    if (qtyTotal!=0) {
	    document.getElementById(tableName+"Qty").innerHTML = qtyTotal;
	    document.getElementById(tableName+"Total").innerHTML = '$' + priceTotal;
	    orderQty += qtyTotal;
	    orderTotal += priceTotal;
    } else {
	    document.getElementById(tableName+"Qty").innerHTML = '';
	    document.getElementById(tableName+"Total").innerHTML = '';
	  }
  }
  document.getElementById("orderQty").innerHTML = orderQty;
  document.getElementById("orderTotal").innerHTML = '$' + orderTotal;

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
  var prods = loadData.split(";");
  for (var i=0;i<prods.length;i++) {
    var f = prods[i].split("=");
     var tableName = f[0];
     f = f[1].split(":");
    var tableNo = getTableNo(tableName);
    var fields = fieldNames[tableNo].split(",");
    for (var j=0;j<f.length;j++) {
    	var fieldName = fields[j]+tableName+line[tableNo];
    	selectValueSet(fieldName, f[j]);
    }
    addRow(tableName);
  }
}
function selectValueSet(selectName, value) {
	selectObject = document.getElementById(selectName);
  for(var i=0; i<selectObject.length; i++) {
    if (selectObject[i].value==value) {
      selectObject.selectedIndex = i;
    }
  }
}
init();
</SCRIPT>
	</body>
</html>