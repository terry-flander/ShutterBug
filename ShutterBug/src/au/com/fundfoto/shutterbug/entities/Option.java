package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;

public class Option {
	  
  private long OptionID = 0;
  private long SelectionID = 0;
  private String OptionName = null;
  private String OptionValue = null;
  private String OptionAttributes = null;
  private Vector<String> errMsg = null;
	  
  public Option() {
  }
  
  public void setOptionID (long OptionID) {
	  this.OptionID = OptionID;
  }
  
  public long getOptionID() {
	  return this.OptionID;
  }
  
  public void setSelectionID (long SelectionID) {
	  this.SelectionID = SelectionID;
  }
  
  public long getSelectionID() {
	  return this.SelectionID;
  }
  
  public void setOptionName(String OptionName) {
	  this.OptionName = OptionName;
  }
  
  public String getOptionName() {
	  return (this.OptionName!=null?this.OptionName:"");
  }

  public void setOptionValue(String OptionValue) {
	  this.OptionValue = OptionValue;
  }
  
  public String getOptionValue() {
	  return (this.OptionValue!=null?this.OptionValue:"");
  }

  public void setOptionAttributes(String OptionAttributes) {
	  this.OptionAttributes = OptionAttributes;
  }
  
  public String getOptionAttributes() {
	  return (this.OptionAttributes!=null?this.OptionAttributes:"");
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
