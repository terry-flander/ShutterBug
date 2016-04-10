package au.com.fundfoto.shutterbug.entities;

public class OrderPhoto {
	private long OrderPhotoID = 0;
	private long ShotID = 0;
	private int frameOrder = 0;
	private int quantity = 0;
	private String color = null;
	private String size = null;
	private String shotName = null;
	
	public OrderPhoto () {
	}
	
	public void setOrderPhotoID(long OrderPhotoID) {
		this.OrderPhotoID = OrderPhotoID;
	}
	
	public long getOrderPhotoID() {
		return this.OrderPhotoID;
	}
	
	public void setShotID(long ShotID) {
		this.ShotID = ShotID;
	}
	
	public long getShotID() {
		return this.ShotID;
	}
	
	public void setFrameOrder(int frameOrder) {
		this.frameOrder = frameOrder;
	}
	
	public int getFrameOrder() {
		return this.frameOrder;
	}
	
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	
	public int getQuantity() {
		return this.quantity;
	}
	
	public void setColor(String color) {
		this.color = color;
	}
	
	public String getColor() {
		return this.color;
	}
	
	public void setSize(String size) {
		this.size = size;
	}
	
	public String getSize() {
		return this.size;
	}
	
	public void setShotName(String shotName) {
	  this.shotName = shotName;
	}
	
	public String getShotName() {
	  return this.shotName;
	}

	public String getShotNameBase() {
    String[] result = (this.shotName!=null?this.shotName:"").split("\\.");
    return result[0];
  }
	
}
