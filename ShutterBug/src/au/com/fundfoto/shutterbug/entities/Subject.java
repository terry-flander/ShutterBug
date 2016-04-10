package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;

public class Subject {
	  
  private long SubjectID = 0;
  private long SessionID = 0;
  private long NameCardID = 0;
  private long PhotographerID = 0;
  private String SubjectCode = null;
  private String FirstSubjectName = null;
  private String Photographer = null;
  private String FirstShot = null;
  private String LastShot = null;
  private String Status = null;
  private String Note = null;
  private int iFirstShot = 0;
  private int iLastShot = 0;
  private long lMountShotID = 0;
  private String ShotName = null;
  private String ContactName = null;
  private String ContactNumber = null;
  private Vector<String> errMsg = null;
	  
  public Subject() {
  }
  
  public void setSubjectID (long SubjectID) {
	  this.SubjectID = SubjectID;
  }
  
  public long getSubjectID() {
	  return this.SubjectID;
  }
  
  public void setSessionID (long SessionID) {
	  this.SessionID = SessionID;
  }
  
  public long getSessionID() {
	  return this.SessionID;
  }
  
  public void setNameCardID (long NameCardID) {
	  this.NameCardID = NameCardID;
  }
  
  public long getNameCardID() {
	  return this.NameCardID;
  }
  
  public void setPhotographerID (long PhotographerID) {
	  this.PhotographerID = PhotographerID;
  }
  
  public long getPhotographerID() {
	  return this.PhotographerID;
  }
  
  public void setSubjectCode(String SubjectCode) {
	  this.SubjectCode = SubjectCode;
  }
  
  public String getSubjectCode() {
	  return (this.SubjectCode!=null?this.SubjectCode:"");
  }

  public void setFirstSubjectName(String FirstSubjectName) {
	  this.FirstSubjectName = FirstSubjectName;
  }
  
  public String getFirstSubjectName() {
	  return (this.FirstSubjectName!=null?this.FirstSubjectName:"");
  }

  public void setPhotographer(String Photographer) {
	  this.Photographer = Photographer;
  }
  
  public String getPhotographer() {
	  return (this.Photographer!=null?this.Photographer:"");
  }

  public void setFirstShot(String FirstShot) {
	try {
	  if (FirstShot==null || FirstShot.length()==0) {
	    FirstShot = "0";
	  }
	  this.iFirstShot = Integer.parseInt(FirstShot);
	} catch (Exception e) {
	  addErrMsg("First Shot '"+FirstShot+"' invalid.");
	}
  }
  
  public String getFirstShot() {
    return (this.FirstShot!=null?this.FirstShot:"");
  }
  
  public void setiFirstShot(int iFirstShot) {
    this.iFirstShot = iFirstShot;
    this.FirstShot = String.valueOf(iFirstShot);
  }
  
  public int getiFirstShot() {
    return this.iFirstShot;
  }
  
  public void setLastShot(String LastShot) {
		try {
		  if (LastShot==null || LastShot.length()==0) {
		    LastShot = "0";
		  }
		  this.iLastShot = Integer.parseInt(LastShot);
		} catch (Exception e) {
		  addErrMsg("Last Shot '"+LastShot+"' invalid.");
		}
  }
  
  public String getLastShot() {
    return (this.LastShot!=null?this.LastShot:"");
  }
  
  public void setiLastShot(int iLastShot) {
    this.iLastShot = iLastShot;
    this.LastShot = String.valueOf(iLastShot);
  }
  
  public int getiLastShot() {
    return this.iLastShot;
  }
  
  public void setlMountShotID (long lMountShotID) {
	  this.lMountShotID = lMountShotID;
  }
  
  public long getlMountShotID() {
	  return this.lMountShotID;
  }
  
  public void setMountShotID(String MountShotID) {
		try {
		  this.lMountShotID = Long.parseLong(MountShotID);
		} catch (Exception e) {
		  addErrMsg("Mount Shot '"+MountShotID+"' invalid.");
		}
  }
  
  public String getMountShotID() {
  	return String.valueOf(this.lMountShotID);
  }
  
  public void setStatus(String Status) {
    this.Status = Status;
  }
  
  public String getStatus() {
    return (this.Status!=null?this.Status:"");
  }

  public void setShotName(String ShotName) {
    this.ShotName = ShotName;
  }
  
  public String getShotName() {
    return (this.ShotName!=null?this.ShotName:"");
  }

  public void setNote(String Note) {
    this.Note = Note;
  }
  
  public String getNote() {
    return (this.Note!=null?this.Note:"");
  }

  public void setContactName(String ContactName) {
    this.ContactName = ContactName;
  }
  
  public String getContactName() {
    return (this.ContactName!=null?this.ContactName:"");
  }

  public void setContactNumber(String ContactNumber) {
    this.ContactNumber = ContactNumber;
  }
  
  public String getContactNumber() {
    return (this.ContactNumber!=null?this.ContactNumber:"");
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
