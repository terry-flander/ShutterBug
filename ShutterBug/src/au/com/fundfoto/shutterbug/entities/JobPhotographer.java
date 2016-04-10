package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;

public class JobPhotographer {
	  
  private long JobCardID = 0;
  private long JobPhotographerID = 0;
  private long NameCardID = 0;
  private String PhotographerName = null;
  private String Directory = null;
  private String Format = null;
  private String PhotographerInitials = null;
  private Vector<String> errMsg = null;
	  
  public JobPhotographer() {
  }
  
  public void setJobCardID (long JobCardID) {
	  this.JobCardID = JobCardID;
  }
  
  public long getJobCardID() {
	  return this.JobCardID;
  }
  
  public void setJobPhotographerID (long JobPhotographerID) {
	  this.JobPhotographerID = JobPhotographerID;
  }
  
  public long getJobPhotographerID() {
	  return this.JobPhotographerID;
  }
  
  public void setNameCardID (long NameCardID) {
	  this.NameCardID = NameCardID;
  }
  
  public long getNameCardID() {
	  return this.NameCardID;
  }
  
  public void setDirectory(String Directory) {
	  this.Directory = Directory;
	  if (this.Directory==null || this.Directory.length()==0) {
	    addErrMsg("Directory may not be blank");
	  }
  }
  
  public String getDirectory() {
	  return (this.Directory!=null?this.Directory:"");
  }

  public void setPhotographerName(String PhotographerName) {
	  this.PhotographerName = PhotographerName;
  }
  
  public String getPhotographerName() {
	  return (this.PhotographerName!=null?this.PhotographerName:"");
  }

  public void setFormat(String Format) {
	  this.Format = (Format!=null?Format.trim():"");
    if (this.Format==null || this.Format.length()==0) {
      addErrMsg("Format may not be blank");
    } else if (this.Format.indexOf("###")==-1) {
      addErrMsg("Format must include position for at least three digits (###).");
    }
  }
  
  public String getFormat() {
	  return (this.Format!=null?this.Format:"");
  }
  
  public void setPhotographerInitials(String PhotographerInitials) {
  	this.PhotographerInitials = PhotographerInitials;
  }
  
  public String getPhotographerInitials() {
  	return this.PhotographerInitials;
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
  
  public void clearErrors() {
    this.errMsg = null;
  }
}
