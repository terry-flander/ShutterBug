package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;

public class Shot {
	  
  private long SubjectID = 0;
  private long ShotID = 0;
  private int ShotNo = 0;
  private String ShotName = null;
  private String OriginalName = null;
  private String OriginalDirectory = null;
  private Vector<String> errMsg = null;
	  
  public Shot() {
  }
  
  public void setSubjectID (long SubjectID) {
	  this.SubjectID = SubjectID;
  }
  
  public long getSubjectID() {
	  return this.SubjectID;
  }
  
  public void setShotID (long ShotID) {
	  this.ShotID = ShotID;
  }
  
  public long getShotID() {
	  return this.ShotID;
  }
  
  public void setShotNo (int ShotNo) {
	  this.ShotNo = ShotNo;
  }
  
  public int getShotNo() {
	  return this.ShotNo;
  }
  
  public void setShotName(String ShotName) {
	  this.ShotName = ShotName;
  }
  
  public String getShotName() {
    return (this.ShotName!=null?this.ShotName:"");
  }

  public String getShotNameBase() {
    String[] result = (this.ShotName!=null?this.ShotName:"").split("\\.");
    return result[0];
  }

  public void setOriginalName(String OriginalName) {
	  this.OriginalName = OriginalName;
  }
  
  public String getOriginalName() {
	  return (this.OriginalName!=null?this.OriginalName:"");
  }

  public void setOriginalDirectory(String OriginalDirectory) {
	  this.OriginalDirectory = OriginalDirectory;
  }
  
  public String getOriginalDirectory() {
	  return (this.OriginalDirectory!=null?this.OriginalDirectory:"");
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
