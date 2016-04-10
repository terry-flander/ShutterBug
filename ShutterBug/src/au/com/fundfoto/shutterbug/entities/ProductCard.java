package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;

public class ProductCard {
	  
  private long ProductID = 0;
  private String ProductDescription = null;
  private String ProductType = null;
  private Vector<String> OptionList = null;
  private Vector<ProductPhoto> PhotoList = null;
  private double dCost = 0;
  private String Cost = null;
  private double dPrice = 0;
  private String Price = null;
  private String ProductImage = null;
  private Vector<String> errMsg = null;
	  
  public ProductCard() {
  }
  
  public void setProductID (long ProductID) {
	  this.ProductID = ProductID;
  }
  
  public long getProductID() {
	  return this.ProductID;
  }
  
  public void setProductDescription (String ProductDescription) {
  	if (ProductDescription==null || ProductDescription.length()==0) {
  		addErrMsg("Product Description may not be blank.");
  	} else {
  		this.ProductDescription = ProductDescription;
  	}
  }
  
  public String getProductDescription () {
    return this.ProductDescription;
  }
  
  public void setProductType (String ProductType) {
    this.ProductType = ProductType;
  }
  
  public String getProductType () {
    return this.ProductType;
  }
  
  public void setProductImage (String ProductImage) {
    this.ProductImage = ProductImage;
  }
  
  public String getProductImage () {
    return this.ProductImage;
  }
  
  public void setOptionList (String OptionList) {
    if (OptionList!=null && OptionList.length()>0) {
    	this.OptionList = new Vector<String>();
      String[] s = OptionList.split(";");
      for (int i=0;i<s.length;i++) {
    		this.OptionList.add(s[i]);
      }
    }
  }
  
  public String getOptionList () {
  	StringBuffer result = new StringBuffer();
    if (this.OptionList!=null && this.OptionList.size()>0) {
      for (int i=0;i<this.OptionList.size();i++) {
      	result.append(this.OptionList.get(i) + (i<this.OptionList.size() - 1?";":""));
      }
    }
    return result.toString();
  }
  
  public void setPhotoList (String PhotoList) {
    if (PhotoList!=null && PhotoList.length()>0) {
    	this.PhotoList = new Vector<ProductPhoto>();
      String[] s = PhotoList.split(";");
      for (int i=0;i<s.length;i++) {
      	String[] p = s[i].split(":");
      	if (p.length==2) {
      		this.PhotoList.add(new ProductPhoto(p[0],p[1]));
      	}
      }
    }
  }
  
  public String getPhotoList () {
  	StringBuffer result = new StringBuffer();
    if (this.PhotoList!=null && this.PhotoList.size()>0) {
      for (int i=0;i<this.PhotoList.size();i++) {
      	ProductPhoto op = this.PhotoList.get(i);
      	result.append(op.getPhotoPosition() + ":" + op.getPhotoSize() + (i<this.PhotoList.size() - 1?";":""));
      }
    }
    return result.toString();
  }
  
  public Vector<ProductPhoto> getProductPhotos() {
  	return this.PhotoList;
  }
  
  public void setCost(String Cost) {
  	this.Cost = Cost;
  	try {
  		this.dCost = Double.parseDouble(Cost);
  	} catch (Exception e){
  	}
  }
  
  public String getCost() {
  	return this.Cost;
  }
  
  public void setdCost(double dCost) {
  	this.dCost = dCost;
  	this.Cost = String.valueOf(dCost);
  }
  
  public double getdCost() {
  	return this.dCost;
  }
  
  public void setPrice(String Price) {
  	this.Price = Price;
  	try {
  		this.dPrice = Double.parseDouble(Price);
  	} catch (Exception e){
  	}
  }
  
  public String getPrice() {
  	return this.Price;
  }
  
  public void setdPrice(double dPrice) {
  	this.dPrice = dPrice;
  	this.Price = String.valueOf(dPrice);
  }
  
  public double getdPrice() {
  	return this.dPrice;
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
  
  class ProductPhoto {
    private String photoPosition = null;
    private String photoSize = null;
    
    public ProductPhoto (String photoPosition, String photoSize) {
    	this.photoPosition = photoPosition;
    	this.photoSize = photoSize;
    }
    
    public String getPhotoPosition() {
    	return this.photoPosition;
    }
    
    public String getPhotoSize() {
    	return this.photoSize;
    }
  }
}
