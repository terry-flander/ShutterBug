package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;

public class OrderLine {
	  
  private long OrderID = 0;
  private long OrderLineID = 0;
  private long lProductID = 0;
  private String ProductDesc = null;
  private String OptionList = null;
  private int iQuantity = 0;
  private double dPrice = 0;
  private double dCost = 0;
  private double dExtendedPrice = 0;
  private Vector<OrderPhoto> photos = null;
  private Vector<String> errMsg = null;
	  
  public OrderLine() {
  	photos = new Vector<OrderPhoto>();
  }
  
  public void setOrderID (long OrderID) {
	  this.OrderID = OrderID;
  }
  
  public long getOrderID() {
	  return this.OrderID;
  }
  
  public void setOrderLineID (long OrderLineID) {
	  this.OrderLineID = OrderLineID;
  }
  
  public long getOrderLineID() {
	  return this.OrderLineID;
  }
  
  public void setOptionList(String OptionList) {
	  this.OptionList = OptionList;
  }
  
  public String getOptionList() {
	  return (this.OptionList!=null?this.OptionList:"");
  }

  public void setlProductID (long lProductID) {
	  this.lProductID = lProductID;
  }
  
  public long getlProductID() {
	  return this.lProductID;
  }
  
  public void setProductID (String ProductID) {
  	try {
  		this.lProductID = Long.parseLong(ProductID);
  	} catch (Exception e) {
  		//
  	}
  }
  
  public String getProductID() {
	  return String.valueOf(this.lProductID);
  }
  
  public void setProductDesc(String ProductDesc) {
  	this.ProductDesc = ProductDesc;
  }
  
  public String getProductDesc() {
  	return this.ProductDesc;
  }
  
  public void setiQuantity(int iQuantity) {
  	this.iQuantity = iQuantity;
  }
  
  public int getiQuantity() {
  	return this.iQuantity;
  }
  
  public void setQuantity(String Quantity) {
  	this.iQuantity = 0;
		if (Quantity!=null && Quantity.length()>0) {
			try {
				this.iQuantity = Integer.parseInt(Quantity);
			} catch (Exception e) {
				addErrMsg("Quantity invalid: " + Quantity);
			}
		}
  }
  
  public String getQuantity() {
  	return String.valueOf(this.iQuantity);
  }
  
  public void setdCost(double dCost) {
  	this.dCost = dCost;
  }
  
  public double getdCost() {
  	return this.dCost;
  }
  
  public void setCost(String Cost) {
  	this.dCost = 0;
		if (Cost!=null && Cost.length()>0) {
			try {
				this.dCost = Integer.parseInt(Cost);
			} catch (Exception e) {
				addErrMsg("Cost invalid: " + Cost);
			}
		}
  }
  
  public String getCost() {
  	return String.valueOf(this.dCost);
  }
  
  public void setdPrice(double dPrice) {
  	this.dPrice = dPrice;
  }
  
  public double getdPrice() {
  	return this.dPrice;
  }
  
  public void setPrice(String Price) {
  	this.dPrice = 0;
		if (Price!=null && Price.length()>0) {
			try {
				this.dPrice = Integer.parseInt(Price);
			} catch (Exception e) {
				addErrMsg("Price invalid: " + Price);
			}
		}
  }
  
  public String getPrice() {
  	return String.valueOf(this.dPrice);
  }
  
  public void setdExtendedPrice(double dExtendedPrice) {
  	this.dExtendedPrice = dExtendedPrice;
  }
  
  public double getdExtendedPrice() {
  	return this.dExtendedPrice;
  }
  
  public void setExtendedPrice(String ExtendedPrice) {
  	this.dExtendedPrice = 0;
		if (ExtendedPrice!=null && ExtendedPrice.length()>0) {
			try {
				this.dExtendedPrice = Integer.parseInt(ExtendedPrice);
			} catch (Exception e) {
				addErrMsg("ExtendedPrice invalid: " + ExtendedPrice);
			}
		}
  }
  
  public String getExtendedPrice() {
  	return String.valueOf(this.dExtendedPrice);
  }
  
  public void setPhotos(Vector<OrderPhoto> photos) {
  	this.photos = photos;
  }
  
  public Vector<OrderPhoto> getPhotos() {
  	return this.photos;
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
