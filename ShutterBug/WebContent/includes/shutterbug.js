function errorMsg(msg) {
  var f = document.getElementById("message");
  if (msg=='') {
    f.style = "border:none;";
	f.innerHTML = '';
  } else {
    f.style = "border:red solid 1px;";
    f.innerHTML = msg;
  }
}

function success() {
  window.opener.location.href = window.opener.location.href;
  self.close();
}

function deleteSuccess(parentPage) {
  window.opener.location.href = parentPage;
  self.close();
}

function successClose() {
  self.close();
}

function processSuccess() {
  location.href = location.href;
  self.close();
}

function reset(fieldList,focusID) {
  errorMsg('');
  var fl = fieldList.split(",");
  for (var i=0;i<fl.length;i++) {
    var f = document.getElementById(fl[i]);
    f.value = "";
  }
  setFocus(focusID); 
  window.opener.location.href = window.opener.location.href;
}

function cancel() {
  self.close();
}

function setSelect(selectID, selectedValue) {
  var id = document.getElementById(selectID);
  if (id!=null) {
    var selectedid = 0;
    for (var i=0; i < id.options.length; i++) {
	  if (id.options[i].value==selectedValue) {
	    selectedid = i;
	  }
	}
	id.options[selectedid].selected=true;
  }
}

function openWindow(url, name) {
  var myleft=0;
  var mytop=0;
  var ieWidthPad=6;
  var ieHeightPad=63;
  if (navigator.appName=="Netscape")  {
    myleft=window.screenX+window.outerWidth / 2;
    mytop=window.screenY+window.outerHeight / 2;
  } else if (navigator.appName.indexOf("Microsoft")!=-1) {
    myleft=window.screenLeft + document.body.offsetWidth - ieWidthPad - 0;
    mytop=window.screenTop + document.documentElement.clientHeight - ieHeightPad - 0;
  }
  settings="width=400,height=600,top=" + mytop + ", left=" + myleft + ",location=no,scrollbars=no,directories=no,status=no,menubar=no,toolbar=no,resizable=yes";
  var win=window.open(url,name,settings);
  win.focus();
}

function windowResize() {
  var width = document.getElementById("resizeDiv").offsetWidth ;
  var height = document.getElementById("resizeDiv").offsetHeight ;
  window.resizeTo(width+20,height+100);
}

function setFocus(ID) {
  if (ID!="") {
    var f = document.getElementById(ID);
    if (f!=null) { 
	    f.focus();
    }
  }
}

