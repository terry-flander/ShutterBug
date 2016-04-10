package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class NameCard {
	  
  private long NameCardID = 0;
  private String FirstName = null;
  private String MiddleName = null;
  private String LastName = null;
  private String CompanyName = null;
  private String Address = null;
  private String City = null;
  private String State = null;
  private String PostCode = null;
  private String Email = null;
  private String Phone = null;
  private String Mobile = null;
  private String BirthDate = null;
  private java.sql.Date dBirthDate = null;
  private Vector<String> errMsg;
  	  
  public NameCard () {
  }
  
  public void setNameCardID (long NameCardID) {
	  this.NameCardID = NameCardID;
  }
  
  public long getNameCardID() {
	  return this.NameCardID;
  }
  
  public void setFirstName(String FirstName) {
	  this.FirstName = FirstName;
  }
  
  public String getFirstName() {
	  return (this.FirstName!=null?this.FirstName:"");
  }

  public void setMiddleName(String MiddleName) {
	  this.MiddleName = MiddleName;
  }
  
  public String getMiddleName() {
	  return (this.MiddleName!=null?this.MiddleName:"");
  }

  public void setLastName(String LastName) {
	  this.LastName = LastName;
  }
  
  public String getLastName() {
	  return (this.LastName!=null?this.LastName:"");
  }

  public void setCompanyName(String CompanyName) {
	  this.CompanyName = CompanyName;
  }
  
  public String getCompanyName() {
	  return (this.CompanyName!=null?this.CompanyName:"");
  }

  public void setAddress(String Address) {
	  this.Address = Address;
  }
  
  public String getAddress() {
	  return (this.Address!=null?this.Address:"");
  }

  public void setCity(String City) {
	  this.City = City;
  }
  
  public String getCity() {
	  return (this.City!=null?this.City:"");
  }

  public void setState(String State) {
	  this.State = State;
  }
  
  public String getState() {
	  return (this.State!=null?this.State:"");
  }

  public void setPostCode(String PostCode) {
	  this.PostCode = PostCode;
  }
  
  public String getPostCode() {
	  return (this.PostCode!=null?this.PostCode:"");
  }

  public void setEmail(String Email) {
	  this.Email = Email;
  }
  
  public String getEmail() {
	  return (this.Email!=null?this.Email:"");
  }

  public void setPhone(String Phone) {
	  this.Phone = Phone;
  }
  
  public String getPhone() {
	  return (this.Phone!=null?this.Phone:"");
  }

  public void setMobile(String Mobile) {
	  this.Mobile = Mobile;
  }
  
  public String getMobile() {
	  return (this.Mobile!=null?this.Mobile:"");
  }

  public void setBirthDate(String BirthDate) {
    DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
    df.setLenient(false);
    if (BirthDate!=null && BirthDate.length()>0) {
      try {
        java.util.Date dt = df.parse(BirthDate);
        this.dBirthDate = new java.sql.Date(dt.getTime());
      } catch (Exception e) {
        addErrMsg("Birth Date '"+BirthDate+"' invalid.");
      }
    }
  }
  
  public String getBirthDate() {
    return (this.BirthDate!=null?this.BirthDate:"");
  }

  public void setdBirthDate(java.sql.Date dBirthDate) {
    this.dBirthDate = dBirthDate;
    try {
      DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
      this.BirthDate = df.format(this.dBirthDate);
    } catch (Exception e) {
      //
    }
  }
	  
  public java.sql.Date getdBirthDate() {
    return this.dBirthDate;
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
