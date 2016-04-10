package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class OrderPayment {
	  
  private long OrderID = 0;
  private long PaymentID = 0;
  private String Type = null;
  private double dAmount = 0;
  private java.sql.Date dPaymentDate = new java.sql.Date(new java.util.Date().getTime());
  private String Note = "";
  private Vector<String> errMsg = null;
	  
  public OrderPayment() {
  }
  
  public void setOrderID (long OrderID) {
	  this.OrderID = OrderID;
  }
  
  public long getOrderID() {
	  return this.OrderID;
  }
  
  public void setPaymentID (long PaymentID) {
	  this.PaymentID = PaymentID;
  }
  
  public long getPaymentID() {
	  return this.PaymentID;
  }
  
  public void setType(String Type) {
  	this.Type = Type;
  }
  
  public String getType() {
  	return this.Type;
  }
  
  public void setNote(String Note) {
  	this.Note = Note;
  }
  
  public String getNote() {
  	return this.Note;
  }
  
  public void setPaymentDate(String PaymentDate) {
  	if (PaymentDate!=null && PaymentDate.length()>0) {
	  	DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
	    df.setLenient(false);
	    try {
	    	java.util.Date dt = df.parse(PaymentDate);
	    	this.dPaymentDate = new java.sql.Date(dt.getTime());
	    } catch (Exception e) {
	    	addErrMsg("Order Date '"+PaymentDate+"' invalid.");
	    }
  	} else {
  		this.dPaymentDate = null;
  	}
  }
  
  public String getPaymentDate() {
  	String result = null;
  	if (dPaymentDate!=null) {
	  	DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
	    try {
	    	result = df.format(dPaymentDate);
	    } catch (Exception e) {
	    }
  	}
	  return result;
  }

  public void setdPaymentDate(java.sql.Date dPaymentDate) {
		this.dPaymentDate = dPaymentDate;
  }
  
  public java.sql.Date getdPaymentDate() {
	  return this.dPaymentDate;
  }

  public void setdAmount(double dAmount) {
  	this.dAmount = dAmount;
  }
  
  public double getdAmount() {
  	return this.dAmount;
  }
  
  public void setAmount(String Amount) {
  	this.dAmount = 0;
		if (Amount!=null && Amount.length()>0) {
			try {
				this.dAmount = Double.parseDouble(Amount);
			} catch (Exception e) {
				addErrMsg("Amount invalid: " + Amount);
			}
		}
  }
  
  public String getAmount() {
  	return String.valueOf(this.dAmount);
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
