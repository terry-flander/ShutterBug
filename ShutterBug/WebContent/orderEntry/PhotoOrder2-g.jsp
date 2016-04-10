<html>
	<head>
		<title>FundFoto Order Form</title>
    <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
	</head>
	<body>
	<form action="PhotoOrder-p.jsp" method="POST">
	<table style="border:solid black 1px;" id='itemTable'>
  <tr id="quadRow"><th>Item</th><th>Qty</th><th>Mount</th><th>Frame Mould</th><th>Photo 1<br>Color?</th><th>Photo 2<br>Color?</th><th>Photo 3<br>Color?</th><th>Photo 4<br>Color?</th></tr>
  </table>
  <input type="button" value="Add Row" onClick ="addRow();">
  <input type="button" value="Recalculate" onClick="recalculate();">
  <input type="submit" value="Save">
	</form>
<SCRIPT>
var tables = ['item','subject'];

var line = [1, 1];

var fieldNames = ['qty_,mould_,photo_1,color_1,photo_2,color_2,photo_3,color_3,photo_4,color_4',
                  'qty_,sizeo_,mould_,photo_1,color_1,photo_2,color_2,photo_3,color_3,photo_4,color_4', 
                  'qty_,sizehv_,mould_,photo_1,color_1,photo_2,color_2,photo_3,color_3', 
                  'qty_,sizehv_,mould_,photo_1,color_1,photo_2,color_2', 
                  'qty_,sizes_,mould_,photo_1,color_1', 
                  'qty_,sizec_,photo_1,color_1', 
                  'qty_,sizel_,mount_,photo_1,color_1' 
                  ];

var fieldNames = 'product_,qty_,mount_,mould_,photo_1,color_1,photo_2,color_2,photo_3,color_3,photo_4,color_4';

var fieldHTML = [	
                '<select name="product_LN" id="product_LN" onChange="setEnable(LN)">PRODUCTS</select>',
                '<select name="qty_LN" id="qty_LN"><option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option><option>6</option><option>7</option><option>8</option><option>9</option><option>10</option></select>',
                '<select name="mount_LN" id="mount_LN" style="visibility:hidden"><option>-select-</option><option value="Y">Yes</option><option value="N">No</option></selection>',
                '<select name="mould_LN" id="mould_LN" style="visibility:hidden"><option>-select-</option><option value="WC">White - Classic</option><option value="BC">Black - Classic</option><option value="SC">Silver - Classic</option><option value="MC">Mocha - Classic</option><option value="WS">White - Slim Line</option><option value="BS">Black - Slim Line</option><option value="SS">Silver - Slim Line</option><option value="WS">Woodgrain - Slim Line</option><option value="CS">Charcoal - Slim Line</option></select>',
                '<select name="photo_1LN" id="photo_1LN" style="visibility:hidden">SHOTS</select><br><select name="color_1LN" id="color_1LN" style="visibility:hidden"><option>-select-</option><option value="C">Colour</option><option value="B">B &amp; W</option></selection>',
                '<select name="photo_2LN" id="photo_2LN" style="visibility:hidden">SHOTS</select><br><select name="color_2LN" id="color_2LN" style="visibility:hidden"><option>-select-</option><option value="C">Colour</option><option value="B">B &amp; W</option></selection>',
                '<select name="photo_3LN" id="photo_3LN" style="visibility:hidden">SHOTS</select><br><select name="color_3LN" id="color_3LN" style="visibility:hidden"><option>-select-</option><option value="C">Colour</option><option value="B">B &amp; W</option></selection>',
                '<select name="photo_4LN" id="photo_4LN" style="visibility:hidden">SHOTS</select><br><select name="color_4LN" id="color_4LN" style="visibility:hidden"><option>-select-</option><option value="C">Colour</option><option value="B">B &amp; W</option></selection>'];

var productList = [ 
                   'Mount Only - 5 x 7',
                   'Mount Only - 6 x 9',
                   'Mount Only - 8 x 12',
                   'Mount Only - 10 x 15',
                   'Mount Only - 13 x 20',
                   'Mount Only - 20 x 30',
                   'Loose - 5 x 7',
                   'Loose - 6 x 9',
                   'Loose - 8 x 12',
                   'Loose - 10 x 15',
                   'Loose - 13 x 20',
                   'Loose - 20 x 30',
                   'Canvas - 10 x 15',
                   'Canvas - 13 x 20',
                   'Canvas - 20 x 30',
                   'Canvas - 26 x 40',
                   'Framed:Single - 6 x 9',
                   'Framed:Single - 8 x 12',
                   'Framed:Single - 10 x 15',
                   'Framed:Single - 13 x 20',
                   'Framed:Single - 20 x 30',
                   'Framed:Single - 26 x 40',
                   'Framed:Double:Vertical - 6 x 9',
                   'Framed:Double:Vertical - 8 x 12',
                   'Framed:Double:Horizontal - 6 x 9',
                   'Framed:Double:Horizontal - 8 x 12',
                   'Framed:Triple:Vertical - 6 x 9',
                   'Framed:Triple:Vertical - 8 x 12',
                   'Framed:Triple:Horizontal - 6 x 9',
                   'Framed:Triple:Horizontal - 8 x 12',
                   'Framed:Quad - 6 x 9',
                   'Framed:Quad - 8 x 12',
                   'Framed:Combo'
                ];

var controlList = [
                 '',
                 '',
                 '',
                 '',
                 '',
                 '',
                 'mount_,photo_1',
                 'mount_,photo_1',
                 'mount_,photo_1',
                 'mount_,photo_1',
                 'mount_,photo_1',
                 'mount_,photo_1',
                 'photo_1',
                 'photo_1',
                 'photo_1',
                 'photo_1',
                 'mould_,photo_1',
                 'mould_,photo_1',
                 'mould_,photo_1',
                 'mould_,photo_1',
                 'mould_,photo_1',
                 'mould_,photo_1',
                 'mould_,photo_1,photo_2',
                 'mould_,photo_1,photo_2',
                 'mould_,photo_1,photo_2',
                 'mould_,photo_1,photo_2',
                 'mould_,photo_1,photo_2,photo_3',
                 'mould_,photo_1,photo_2,photo_3',
                 'mould_,photo_1,photo_2,photo_3',
                 'mould_,photo_1,photo_2,photo_3',
                 'mould_,photo_1,photo_2,photo_3,photo_4',
                 'mould_,photo_1,photo_2,photo_3,photo_4',
                 'mould_,photo_1,photo_2,photo_3,photo_4'
                 ];
                 
var priceList = [
                 '15',
                 '15',
                 '15',
                 '15',
                 '15',
                 '15',
                 '65',
                 '65',
                 '95',
                 '145',
                 '285',
                 '445',
                 '265',
                 '425',
                 '685',
                 '885',
                 '150',
                 '200',
                 '260',
                 '465',
                 '685',
                 '935',
                 '255',
                 '375',
                 '255',
                 '375',
                 '375',
                 '575',
                 '375',
                 '575',
                 '465',
                 '675',
                 '445'
                 ];
                 
var shotList = '<option value="">-select-</option><option>FSTT0101</option><option>FSTT0102</option><option>FSTT0103</option><option>FSTT0103</option><option>FSTT0104</option><option>FSTT0105</option><option>FSTT0106</option><option>FSTT0107</option><option>FSTT0108</option><option>FSTT0109</option><option>FSTT0110</option>';
var loadData = 'combo=1:WS:FSTT0101:C:FST0102:B:FSTT0104:B:FSTT0104:C';
var line = 1;
var productListHTML = '';
function addRow(tableName, firstTime) {
  var t=document.getElementById(tableName + "Table");
  var tableNo = getTableNo(tableName);
  var fns = fieldNames[tableNo].split(",");
  var n=t.insertRow(-1);
  line++;
  for (var i=0;i<fns.length;i++) {
	    var c=n.insertCell(-1);
	    c.style.verticalAlign = 'top';
      var fieldName = fns[i];
      var f = getFieldHTML(fieldName);
	    f = f.replace(/PRODUCTS/gi,"<option value=''>-choose-</option>"+productListHTML);
	    f = f.replace(/LN/gi,line);
	    f = f.replace(/SHOTS/gi,shotList);
	    c.innerHTML = f;
  }
  if (firstTime) {
    c=n.insertCell(-1);
    c.style.verticalAlign = 'top';
    c.innerHTML = "<a href=\"JavaScript:addRow('" + tableName + "')\">Add</a>";
  }
}
function init() {
	builtProductOptions();
	for (var tbl=0;tbl<tables.length;tbl++) {
	  var tableName = tables[tbl];
	  addRow(tableName, true);
	}
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
function setEnable(lineNumber) {
	var c = document.getElementById('product_'+lineNumber).value;
	if (c!==-1) {
		var control = controlList[c];
    f = document.getElementById('mount_'+lineNumber);
    if (control.indexOf("M")!=-1) {
      f.style.visibility = 'visible';
    } else {
      f.style.visibility = 'hidden';
    }
    f = document.getElementById('mould_'+lineNumber);
    if (control.indexOf("F")!=-1) {
      f.style.visibility = 'visible';
    } else {
      f.style.visibility = 'hidden';
    }
    f = document.getElementById('photo_1'+lineNumber);
    if (control.indexOf("1")!=-1) {
      f.style.visibility = 'visible';
    } else {
      f.style.visibility = 'hidden';
    }
    f = document.getElementById('color_1'+lineNumber);
    if (control.indexOf("1")!=-1) {
      f.style.visibility = 'visible';
    } else {
      f.style.visibility = 'hidden';
    }
    f = document.getElementById('photo_2'+lineNumber);
    if (control.indexOf("2")!=-1) {
      f.style.visibility = 'visible';
    } else {
      f.style.visibility = 'hidden';
    }
    f = document.getElementById('color_2'+lineNumber);
    if (control.indexOf("2")!=-1) {
      f.style.visibility = 'visible';
    } else {
      f.style.visibility = 'hidden';
    }
    f = document.getElementById('photo_3'+lineNumber);
    if (control.indexOf("3")!=-1) {
      f.style.visibility = 'visible';
    } else {
      f.style.visibility = 'hidden';
    }
    f = document.getElementById('color_3'+lineNumber);
    if (control.indexOf("3")!=-1) {
      f.style.visibility = 'visible';
    } else {
      f.style.visibility = 'hidden';
    }
    f = document.getElementById('photo_4'+lineNumber);
    if (control.indexOf("4")!=-1) {
      f.style.visibility = 'visible';
    } else {
      f.style.visibility = 'hidden';
    }
    f = document.getElementById('color_4'+lineNumber);
    if (control.indexOf("4")!=-1) {
      f.style.visibility = 'visible';
    } else {
      f.style.visibility = 'hidden';
    }
	}
}
function buildProductOptions() {
	for (var i=0;i<productList.length;i++) {
	  productListHTML += '<option value="' + controlList[i] + '">' + productList[i] + '</option>';
	}
}
init();
</SCRIPT>
	</body>
</html>