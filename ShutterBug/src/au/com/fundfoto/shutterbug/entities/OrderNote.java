package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class OrderNote {
	  
  private long OrderID = 0;
  private long OrderNoteID = 0;
  private int iNoteSequence = 0;
  private String NoteText = null;
  private java.sql.Date dNoteDate = null;
  private long lNameCardID = 0;
  private String NoteName = null;
  private Vector<String> errMsg = null;
	  
  public OrderNote() {
  }
  
  public void setOrderID (long OrderID) {
	  this.OrderID = OrderID;
  }
  
  public long getOrderID() {
	  return this.OrderID;
  }
  
  public void setOrderNoteID (long OrderNoteID) {
	  this.OrderNoteID = OrderNoteID;
  }
  
  public long getOrderNoteID() {
	  return this.OrderNoteID;
  }
  
  public void setlNameCardID (long lNameCardID) {
	  this.lNameCardID = lNameCardID;
  }
  
  public long getlNameCardID() {
	  return this.lNameCardID;
  }
  
  public void setNoteName(String NoteName) {
  	this.NoteName = NoteName;
  }
  
  public String getNoteName() {
  	return this.NoteName;
  }
  
  public void setiNoteSequence (int iNoteSequence) {
	  this.iNoteSequence = iNoteSequence;
  }
  
  public int getiNoteSequence() {
	  return this.iNoteSequence;
  }
  
  public void setNoteText(String NoteText) {
  	this.NoteText = NoteText;
  }
  
  public String getNoteText() {
  	return this.NoteText;
  }
  
  public void setNoteDate(String NoteDate) {
		if (NoteDate!=null && NoteDate.length()>0) {
	  	DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
	    df.setLenient(false);
	    try {
	    	java.util.Date dt = df.parse(NoteDate);
	    	this.dNoteDate = new java.sql.Date(dt.getTime());
	    } catch (Exception e) {
	    	addErrMsg("Order Date '"+NoteDate+"' invalid.");
	    }
		} else {
			this.dNoteDate = null;
		}
	}
	
	public String getNoteDate() {
		String result = null;
		if (dNoteDate!=null) {
	  	DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
	    try {
	    	result = df.format(dNoteDate);
	    } catch (Exception e) {
	    }
		}
	  return result;
	}
	
	public void setdNoteDate(java.sql.Date dNoteDate) {
		this.dNoteDate = dNoteDate;
	}
	
	public java.sql.Date getdNoteDate() {
	  return this.dNoteDate;
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
