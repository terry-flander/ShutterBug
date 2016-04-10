package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class ReportParameter {
	  
  private long ReportID = 0;
  private long ParameterID = 0;
  private int iOrder = 0;
  private String Order = null;
  private String Code = null;
  private String Description = null;
  private String DataType = null;
  private String Validation = null;
  private String EnteredValue = null;
  private String ReportValue = null;
  private java.util.Date dReportValue = null;
  private Vector<String> errMsg = null;
	  
  public ReportParameter() {
  }
  
  public void setReportID (long ReportID) {
	  this.ReportID = ReportID;
  }
  
  public long getReportID() {
	  return this.ReportID;
  }
  
  public void setParameterID (long ParameterID) {
	  this.ParameterID = ParameterID;
  }
  
  public long getParameterID() {
	  return this.ParameterID;
  }
  
  public void setOrder(String Order) {
  try {
    if (Order==null || Order.length()==0) {
      Order = "0";
    }
    this.iOrder = Integer.parseInt(Order);
  } catch (Exception e) {
    addErrMsg("Order '"+Order+"' invalid.");
  }
  }
  
  public String getOrder() {
    return (this.Order!=null?this.Order:"");
  }
  
  public void setiOrder(int iOrder) {
    this.iOrder = iOrder;
    this.Order = String.valueOf(iOrder);
  }
  
  public int getiOrder() {
    return this.iOrder;
  }
  
  public void setCode(String Code) {
    this.Code = Code;
  }
  
  public String getCode() {
    return (this.Code!=null?this.Code:"");
  }

  public void setDescription(String Description) {
	  this.Description = Description;
  }
  
  public String getDescription() {
	  return (this.Description!=null?this.Description:"");
  }

  public void setDataType(String DataType) {
    this.DataType = DataType;
  }
  
  public String getDataType() {
    return (this.DataType!=null?this.DataType:"");
  }

  public void setValidation(String Validation) {
    this.Validation = Validation;
  }
  
  public String getValidation() {
    return (this.Validation!=null?this.Validation:"");
  }
  
  public void setEnteredValue(String EnteredValue) {
  	this.EnteredValue = EnteredValue;
  	if (this.DataType.equalsIgnoreCase("date")) {
  		if (EnteredValue!=null && EnteredValue.length()>0) {
		    DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		    df.setLenient(false);
		    try {
		      this.dReportValue = df.parse(EnteredValue);
	        df = new SimpleDateFormat("yyyy-MM-dd");
	        this.ReportValue = df.format(this.dReportValue);
		    } catch (Exception e) {
		      addErrMsg(getDescription() + " '"+EnteredValue+"' invalid.");
		    }
  		} 
  		// Blank or null date set to 'today'
  		else {
				DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				this.dReportValue = new java.util.Date();
				this.ReportValue = df.format(this.dReportValue);
  		}
  	} else {
  		this.ReportValue = EnteredValue;
  	}
  }
  
  public String getEnteredValue() {
  	return this.EnteredValue;
  }

  public void setReportValue(String ReportValue) {
  	this.ReportValue = ReportValue;
  }
  
  public Object getReportValue() {
	  return (this.ReportValue!=null?this.ReportValue:"");
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
  
  public String getParameterHTML() {
    String result = null;
    if (!this.DataType.equalsIgnoreCase("list")) {
      result = "<input type=\"text\" name=\""+ getCode() +"\">";
    } else {
      result = "<select name=\""+ getCode() +"\"><option value=\"\">All</option>" + OptionService.getHTMLOptionList(getValidation()) + "</select>";
    }
    return result;
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
