package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;

public class NameRelation {
  
  public static final int NAME_TYPE = 0;
  public static final int JOB_TYPE = 1;
  public static final int SESSION_TYPE = 2;
  public static final int SUBJECT_TYPE = 3;
  public static final int ORDER_TYPE = 4;
	  
  private long RelationID = 0;
  private int ParentType = 0;
  private long lParentID = 0;
  private long lChildID = 0;
  private String ParentID = null;
  private String ChildID = null;
  private String RelationType = null;
  private String ChildName = null;
  private Vector<String> errMsg;
  	  
  public NameRelation () {
  }
  
  public void setRelationID (long RelationID) {
	  this.RelationID = RelationID;
  }
  
  public long getRelationID() {
	  return this.RelationID;
  }
  
  public void setParentType (int ParentType) {
    this.ParentType = ParentType;
  }
  
  public int getParentType() {
    return this.ParentType;
  }
  
  public void setlParentID (long lParentID) {
    this.lParentID = lParentID;
    this.ParentID = String.valueOf(lParentID);
  }
  
  public long getlParentID() {
    return this.lParentID;
  }
  
  public void setParentID (String ParentID) {
    this.ParentID = ParentID;
	try {
      this.lParentID = Long.parseLong(ParentID);
	} catch (Exception e) {
	  //
	}
  }
  
  public String getParentID() {
	  return (this.ParentID!=null?this.ParentID:"0");
  }
  
  public void setlChildID (long lChildID) {
	  this.lChildID = lChildID;
	  this.ChildID = String.valueOf(lChildID);
  }
  
  public long getlChildID() {
	  return this.lChildID;
  }
  
  public void setChildID (String ChildID) {
    this.ChildID = ChildID;
	try {
      this.lChildID = Long.parseLong(ChildID);
	} catch (Exception e) {
	  //
	}
  }
  
  public String getChildID() {
	  return (this.ChildID!=null?this.ChildID:"0");
  }
  
  public void setRelationType(String RelationType) {
	  this.RelationType = RelationType;
  }
  
  public String getRelationType() {
	  return (this.RelationType!=null?this.RelationType:"");
  }

  public void setChildName(String ChildName) {
	  this.ChildName = ChildName;
  }
  
  public String getChildName() {
	  return (this.ChildName!=null?this.ChildName:"");
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
