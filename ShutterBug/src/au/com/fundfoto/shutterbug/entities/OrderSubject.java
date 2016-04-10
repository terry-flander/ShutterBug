package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;

public class OrderSubject {
	  
  private long OrderID = 0;
  private long OrderSubjectID = 0;
  private long lSubjectID = 0;
  private String SubjectCode = null;
  private String SubjectName = null;
  private Vector<String> errMsg = null;
	  
  public OrderSubject() {
  }
  
  public void setOrderID (long OrderID) {
	  this.OrderID = OrderID;
  }
  
  public long getOrderID() {
	  return this.OrderID;
  }
  
  public void setOrderSubjectID (long OrderSubjectID) {
	  this.OrderSubjectID = OrderSubjectID;
  }
  
  public long getOrderSubjectID() {
	  return this.OrderSubjectID;
  }
  
  public void setlSubjectID (long lSubjectID) {
	  this.lSubjectID = lSubjectID;
  }
  
  public long getlSubjectID() {
	  return this.lSubjectID;
  }
  
  public void setSubjectID(String SubjectID) {
  	try {
  		this.lSubjectID = Long.parseLong(SubjectID);
  	} catch (Exception e) {
  	}
  }
  
  public String getSubjectID() {
  	return String.valueOf(this.lSubjectID);
  }
  
  public void setSubjectName(String SubjectName) {
  	this.SubjectName = SubjectName;
  }
  
  public String getSubjectName() {
  	return this.SubjectName;
  }
  
  public void setSubjectCode(String SubjectCode) {
  	this.SubjectCode = SubjectCode;
  }
  
  public String getSubjectCode() {
  	return this.SubjectCode;
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
