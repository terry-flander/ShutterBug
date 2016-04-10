package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class Order {
	  
  private long OrderID = 0;
  private String OrderNumber = null;
  private java.sql.Date dOrderDate = null;
  private String OrderStatus = null;
  private long lNameCardID = 0;
  private String BillToName = null;
  private double dTotalPrice = 0;
  private double dBalanceDue = 0;
  private Vector<String> errMsg = null;
	  
  public Order() {
  }
  
  public void setOrderID (long OrderID) {
	  this.OrderID = OrderID;
  }
  
  public long getOrderID() {
	  return this.OrderID;
  }
  
  public void setOrderNumber(String OrderNumber) {
  	this.OrderNumber = OrderNumber;
  }
  
  public String getOrderNumber() {
	  return (this.OrderNumber!=null?this.OrderNumber:"");
  }

  public void setOrderStatus(String OrderStatus) {
	  this.OrderStatus = OrderStatus;
  }
  
  public String getOrderStatus() {
	  return (this.OrderStatus!=null?this.OrderStatus:"");
  }

  public void setOrderDate(String OrderDate) {
  	if (OrderDate!=null && OrderDate.length()>0) {
	  	DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
	    df.setLenient(false);
	    try {
	    	java.util.Date dt = df.parse(OrderDate);
	    	this.dOrderDate = new java.sql.Date(dt.getTime());
	    } catch (Exception e) {
	    	addErrMsg("Order Date '"+OrderDate+"' invalid.");
	    }
  	} else {
  		this.dOrderDate = null;
  	}
  }
  
  public String getOrderDate() {
  	String result = null;
  	if (dOrderDate!=null) {
	  	DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
	    try {
	    	result = df.format(dOrderDate);
	    } catch (Exception e) {
	    }
  	}
	  return result;
  }

  public void setdOrderDate(java.sql.Date dOrderDate) {
		this.dOrderDate = dOrderDate;
  }
  
  public java.sql.Date getdOrderDate() {
	  return this.dOrderDate;
  }

  public void setlNameCardID (long lNameCardID) {
	  this.lNameCardID = lNameCardID;
  }
  
  public long getlNameCardID() {
	  return this.lNameCardID;
  }
  
  public void setNameCardID (String NameCardID) {
  	try {
	    this.lNameCardID = Long.parseLong(NameCardID);
    } catch (Exception e) {
	   	addErrMsg("NameCardID '"+NameCardID+"' invalid.");
    }
  	if (this.lNameCardID==0) {
  		addErrMsg("Bill To Name must be selected.");
  	}
  }
  
  public String getNameCardID() {
	  return String.valueOf(this.lNameCardID);
  }
  
  public void setBillToName(String BillToName) {
  	this.BillToName = BillToName;
  }
  
  public String getBillToName() {
  	return this.BillToName;
  }
  
  public void setdTotalPrice (double dTotalPrice) {
	  this.dTotalPrice = dTotalPrice;
  }
  
  public double getdTotalPrice() {
	  return this.dTotalPrice;
  }
  
  public void setTotalPrice (String TotalPrice) {
  	if (TotalPrice!=null && TotalPrice.length()>0) {
	    try {
	    	this.dTotalPrice = Double.parseDouble(TotalPrice);
	    } catch (Exception e) {
	    	addErrMsg("Total Price '"+TotalPrice+"' invalid.");
	    }
  	}
  }
  
  public String getTotalPrice() {
  	return String.valueOf(dTotalPrice);
  }
  
  public void setdBalanceDue (double dBalanceDue) {
	  this.dBalanceDue = dBalanceDue;
  }
  
  public double getdBalanceDue() {
	  return this.dBalanceDue;
  }
  
  public void setBalanceDue (String BalanceDue) {
  	if (BalanceDue!=null && BalanceDue.length()>0) {
	    try {
	    	this.dBalanceDue = Double.parseDouble(BalanceDue);
	    } catch (Exception e) {
	    	addErrMsg("Total Price '"+BalanceDue+"' invalid.");
	    }
  	}
  }
  
  public String getBalanceDue() {
  	return String.valueOf(dBalanceDue);
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
