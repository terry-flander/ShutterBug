package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class JobSession {
	  
  private long JobCardID = 0;
  private long SessionID = 0;
  private String Name = null;
  private String Code = null;
  private String Description = null;
  private String SessionDate = null;
  private String StartTime = null;
  private String EndTime = null;
  private java.sql.Date dSessionDate = null;
  private java.sql.Time dStartTime = null;
  private java.sql.Time dEndTime = null;
  private Vector<String> errMsg = null;
	  
  public JobSession() {
  }
  
  public void setJobCardID (long JobCardID) {
	  this.JobCardID = JobCardID;
  }
  
  public long getJobCardID() {
	  return this.JobCardID;
  }
  
  public void setSessionID (long SessionID) {
	  this.SessionID = SessionID;
  }
  
  public long getSessionID() {
	  return this.SessionID;
  }
  
  public void setName(String Name) {
	  this.Name = Name;
  }
  
  public String getName() {
	  return (this.Name!=null?this.Name:"");
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

  public void setSessionDate(String SessionDate) {
  	if (SessionDate!=null && SessionDate.length()>0) {
	    DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
	    df.setLenient(false);
			try {
			  java.util.Date dt = df.parse(SessionDate);
			  this.dSessionDate = new java.sql.Date(dt.getTime());
			} catch (Exception e) {
			  addErrMsg("Session Date '"+SessionDate+"' invalid.");
			}
  	} else {
  		this.dSessionDate = null;
  	}
  	
  }
  
  public String getSessionDate() {
	  return (this.SessionDate!=null?this.SessionDate:"");
  }

  public void setStartTime(String StartTime) {
  	if (StartTime!=null && StartTime.length()>0) {
	    DateFormat df = new SimpleDateFormat("HH:mm");
	    df.setLenient(false);
	    try {
	      java.util.Date dt = df.parse(StartTime);
	      this.dStartTime = new java.sql.Time(dt.getTime());
	    } catch (Exception e) {
	      addErrMsg("Start Time '"+StartTime+"' invalid.");
	    }
  	} else {
  		this.dStartTime = null;
  	}
  }
  
  public String getStartTime() {
	  return (this.StartTime!=null?this.StartTime:"");
  }

  public void setEndTime(String EndTime) {
  	if (EndTime!=null && EndTime.length()>0) {
	  	DateFormat df = new SimpleDateFormat("HH:mm");
	    df.setLenient(false);
	    try {
	      java.util.Date dt = df.parse(EndTime);
	      this.dEndTime = new java.sql.Time(dt.getTime());
	      if (this.dEndTime.compareTo(this.dStartTime)<=0) {
	        addErrMsg("End Time must be after Start Time.");
	      }
	    } catch (Exception e) {
	      addErrMsg("End Time '"+EndTime +"' invalid.");
	    }
  	} else {
  		this.dEndTime = null;
  	}
  }
  
  public String getEndTime() {
	  return (this.EndTime!=null?this.EndTime:"");
  }

  public void setdSessionDate(java.sql.Date dSessionDate) {
	this.dSessionDate = dSessionDate;
	try {
      DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
      this.SessionDate = df.format(this.dSessionDate);
	} catch (Exception e) {
	  //
	}
  }
  
  public java.sql.Date getdSessionDate() {
	  return this.dSessionDate;
  }

  public void setdStartTime(java.sql.Time dStartTime) {
    this.dStartTime = dStartTime;
    try {
      DateFormat df = new SimpleDateFormat("HH:mm");
      this.StartTime = df.format(this.dStartTime);
    } catch (Exception e) {
      //
    }
  }
  
  public java.sql.Time getdStartTime() {
	  return this.dStartTime;
  }

  public void setdEndTime(java.sql.Time dEndTime) {
    this.dEndTime = dEndTime;
	try {
	  DateFormat df = new SimpleDateFormat("HH:mm");
	  this.EndTime = df.format(this.dEndTime);
	} catch (Exception e) {
	  //
	}
  }
  
  public java.sql.Time getdEndTime() {
	  return this.dEndTime;
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
