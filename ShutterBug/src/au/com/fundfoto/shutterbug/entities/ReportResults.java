package au.com.fundfoto.shutterbug.entities;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Vector;

public class ReportResults {
	  
  private long ReportID = 0;
  private long ResultsID = 0;
  private String Parameters = null;
  private String FileName = null;
  private long lRunByID = 0;
  private String RunByID = null;
  private java.sql.Timestamp dRunTime = null;
  private String RunTime = null;
  private String RunByName = null;
  private Vector<String> errMsg = null;
	  
  public ReportResults() {
  }
  
  public void setReportID (long ReportID) {
	  this.ReportID = ReportID;
  }
  
  public long getReportID() {
	  return this.ReportID;
  }
  
  public void setResultsID (long ResultsID) {
	  this.ResultsID = ResultsID;
  }
  
  public long getResultsID() {
	  return this.ResultsID;
  }
  
  public void setParameters(String Parameters) {
    this.Parameters = Parameters;
  }
  
  public String getParameters() {
    return (this.Parameters!=null?this.Parameters:"");
  }

  public void setFileName(String FileName) {
	  this.FileName = FileName;
  }
  
  public String getFileName() {
	  return (this.FileName!=null?this.FileName:"");
  }

  public void setlRunByID (long lRunByID) {
    this.lRunByID = lRunByID;
    this.RunByID = String.valueOf(lRunByID);
  }
  
  public long getlRunByID() {
    return this.lRunByID;
  }
  
  public void setRunByID (String RunByID) {
    this.RunByID = RunByID;
  try {
      this.lRunByID = Long.parseLong(RunByID);
  } catch (Exception e) {
    //
  }
  }
  
  public String getRunByName() {
    return (this.RunByName!=null?this.RunByName:"system");
  }
  
  public void setRunByName(String RunByName) {
    this.RunByName = RunByName;
  }
  
  public String getRunByID() {
    return (this.RunByID!=null?this.RunByID:"0");
  }
  
  public void setRunTime(String RunTime) {
    DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
    df.setLenient(false);
    try {
      java.util.Date dt = df.parse(RunTime);
      this.dRunTime = new java.sql.Timestamp(dt.getTime());
    } catch (Exception e) {
      addErrMsg("Job Date '"+RunTime+"' invalid.");
    }
  }
  
  public String getRunTime() {
    return (this.RunTime!=null?this.RunTime:"");
  }

  public void setdRunTime(java.sql.Timestamp dRunTime) {
    this.dRunTime = dRunTime;
    try {
      DateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
      this.RunTime = df.format(this.dRunTime);
    } catch (Exception e) {
      //
    }
  }
  
  public java.sql.Timestamp getdRunTime() {
    return this.dRunTime;
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
