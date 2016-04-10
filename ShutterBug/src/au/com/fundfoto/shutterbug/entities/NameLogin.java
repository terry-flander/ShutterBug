package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class NameLogin {
	  
  private long NameLoginID = 0;
  private long NameCardID = 0;
  private String LoginID = null;
  private String LoginPassword = null;
  private String Status = null;
  private String AccessLevel = null;
  private String DateCreated = null;
  private String LastLogin = null;
  private java.sql.Timestamp dDateCreated = null;
  private java.sql.Timestamp dLastLogin = null;
  private String SessionCode = null;
  private Vector<String> errMsg = null;
	  
  public NameLogin() {
  }
  
  public void setNameLoginID (long NameLoginID) {
	  this.NameLoginID = NameLoginID;
  }
  
  public long getNameLoginID() {
	  return this.NameLoginID;
  }
  
  public void setNameCardID (long NameCardID) {
	  this.NameCardID = NameCardID;
  }
  
  public long getNameCardID() {
	  return this.NameCardID;
  }
  
  public void setLoginID(String LoginID) {
	  this.LoginID = LoginID;
  }
  
  public String getLoginID() {
	  return (this.LoginID!=null?this.LoginID:"");
  }

  public void setLoginPassword(String LoginPassword) {
	  this.LoginPassword = LoginPassword;
  }
  
  public String getLoginPassword() {
	  return (this.LoginPassword!=null?this.LoginPassword:"");
  }

  public void setStatus(String Status) {
    this.Status = Status;
  }
  
  public String getStatus() {
    return (this.Status!=null?this.Status:"");
  }

  public void setAccessLevel(String AccessLevel) {
    this.AccessLevel = AccessLevel;
  }
  
  public String getAccessLevel() {
    return (this.AccessLevel!=null?this.AccessLevel:"");
  }

  public void setDateCreated(String DateCreated) {
    DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
    df.setLenient(false);
    try {
      java.util.Date dt = df.parse(DateCreated);
      this.dDateCreated = new java.sql.Timestamp(dt.getTime());
    } catch (Exception e) {
      addErrMsg("Date Created'"+DateCreated+"' invalid.");
    }
  }
  
  public String getDateCreated() {
    return (this.DateCreated!=null?this.DateCreated:"");
  }

  public void setdDateCreated(java.sql.Timestamp dDateCreated) {
    this.dDateCreated = dDateCreated;
    try {
      DateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
      this.DateCreated = df.format(this.dDateCreated);
    } catch (Exception e) {
      //
    }
  }
  
  public java.sql.Timestamp getdDateCreated() {
    return this.dDateCreated;
  }

  public void setLastLogin(String LastLogin) {
    DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
    df.setLenient(false);
    try {
      java.util.Date dt = df.parse(LastLogin);
      this.dLastLogin = new java.sql.Timestamp(dt.getTime());
    } catch (Exception e) {
      addErrMsg("Last Login Date '"+LastLogin+"' invalid.");
    }
  }
  
  public String getLastLogin() {
    return (this.LastLogin!=null?this.LastLogin:"");
  }

  public void setdLastLogin(java.sql.Timestamp dLastLogin) {
    this.dLastLogin = dLastLogin;
    try {
      DateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
      this.LastLogin = df.format(this.dLastLogin);
    } catch (Exception e) {
      //
    }
  }
  
  public java.sql.Timestamp getdLastLogin() {
    return this.dLastLogin;
  }

  public void setSessionCode(String SessionCode) {
    this.SessionCode = SessionCode;
  }
  
  public String getSessionCode() {
    return (this.SessionCode!=null?this.SessionCode:"");
  }

  private void addErrMsg(String msg) {
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
