package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;

public class Selection {
	  
  private long SelectionID = 0;
  private String SelectionCode = null;
  private String Description = null;
  private Vector<String> errMsg;
  	  
  public Selection () {
  }
  
  public void setSelectionID (long SelectionID) {
	  this.SelectionID = SelectionID;
  }
  
  public long getSelectionID() {
	  return this.SelectionID;
  }
  
  public void setSelectionCode(String SelectionCode) {
	  this.SelectionCode = SelectionCode;
  }
  
  public String getSelectionCode() {
	  return (this.SelectionCode!=null?this.SelectionCode:"");
  }

  public void setDescription(String Description) {
	  this.Description = Description;
  }
  
  public String getDescription() {
	  return (this.Description!=null?this.Description:"");
  }

  public void addErrMsg(String msg) {
    if (this.errMsg==null) {
    	this.errMsg = new Vector<String>();
    }
    this.errMsg.add(msg);
  }
  
  public boolean hasErrors() {
	return this.errMsg!=null;
  }
  
  public String getErrMsg() {
    StringBuffer result = new StringBuffer();
    if (this.errMsg!=null) {
      for (int i=0;i<this.errMsg.size();i++) {
        result.append(this.errMsg.get(i) + "<br />");
      }
    }
    return result.toString();
  }
}
