package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;

public class Report {
	  
  private long ReportID = 0;
  private String Description = null;
  private String Title = null;
  private String JasperFile = null;
  private String Comments = null;
  private Vector<String> errMsg = null;
	  
  public Report() {
  }
  
  public void setReportID (long ReportID) {
	  this.ReportID = ReportID;
  }
  
  public long getReportID() {
	  return this.ReportID;
  }
  
  public void setDescription(String Description) {
    this.Description = Description;
  }
  
  public String getDescription() {
    return (this.Description!=null?this.Description:"");
  }

  public void setTitle(String Title) {
	  this.Title = Title;
  }
  
  public String getTitle() {
	  return (this.Title!=null?this.Title:"");
  }

  public void setJasperFile(String JasperFile) {
	  this.JasperFile = JasperFile;
  }
  
  public String getJasperFile() {
	  return (this.JasperFile!=null?this.JasperFile:"");
  }

  public void setComments(String Comments) {
	  this.Comments = Comments;
  }
  
  public String getComments() {
	  return (this.Comments!=null?this.Comments:"");
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
