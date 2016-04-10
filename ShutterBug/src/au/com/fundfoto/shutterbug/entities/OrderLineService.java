package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;

import au.com.fundfoto.shutterbug.util.DbUtil;
import org.apache.log4j.*;

public class OrderLineService {
	  
  static Logger logger = Logger.getLogger("OrderLineService");

  public OrderLineService() {
  }
  
  public OrderLine getOrderLine (long OrderLineID) {
  	OrderLine result = null;
  	Connection con = null;
  	if (OrderLineID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = 
	        "SELECT OL.ProductID,OL.OptionList,OL.Quantity,OL.Cost,OL.Price,OL.ExtendedPrice,OL.OrderID,OL.OrderLineID,PC.ProductDescription, " +
	        " OP.OrderPhotoID,OP.ShotID,OP.Quantity AS SHOT_QTY,OP.FrameOrder,OP.Color,OP.Size,SH.ShotName  " +
	        " FROM OrderLine OL" +
	        " INNER JOIN ProductCard PC ON PC.ProductID = OL.ProductID " +
	        " LEFT OUTER JOIN OrderPhoto OP ON OP.OrderLineID = OL.OrderLineID " +
          " LEFT OUTER JOIN Shot SH ON SH.ShotID = OP.ShotID " +
	        " WHERE OL.OrderLineID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,OrderLineID);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
        	if (result==null) {
        		result = createOrderLine(rs);
        	}
        	if (rs.getLong("OrderPhotoID")!=0) {
        		result.getPhotos().add(createOrderPhoto(rs));
        	}
        }
        rs.close();
        ps.close();
      } catch (Exception e) {
      	logger.error("getOrderLine() Error: " + e.getMessage());
      } finally {
        DbUtil.freeConnection(con);
      }
  	}
    return (result==null?new OrderLine():result);
  }
  
  public boolean saveOrderLine(OrderLine ol) {
    boolean result = false;
    Connection con = null;
    try {
    	boolean insertLine = ol.getOrderLineID()==0;
      String sql = null;
      if (insertLine) {
      	sql = "INSERT INTO OrderLine (ProductID,OptionList,Quantity,Cost,Price,ExtendedPrice,OrderID) VALUES (?,?,?,?,?,?,?)";
      } else {
      	sql = "UPDATE OrderLine SET ProductID=?,OptionList=?,Quantity=?,Cost=?,Price=?,ExtendedPrice=? WHERE OrderLineID=?";
      }
      double optionPrice = getOptionPrice(ol.getOptionList());
      // Get Product Configuration First
      ProductCard pc = new ProductCardService().getProductCard(ol.getlProductID());
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setLong(1,ol.getlProductID());
      ps.setString(2,ol.getOptionList());
      ps.setInt(3,ol.getiQuantity());
      ps.setDouble(4,pc.getdCost());
      ps.setDouble(5,pc.getdPrice() + optionPrice);
      ps.setDouble(6,(pc.getdPrice() + optionPrice) * ol.getiQuantity());
      if (!insertLine) {
        ps.setLong(7,ol.getOrderLineID());
      } else {
        ps.setLong(7,ol.getOrderID());
      }
      ps.executeUpdate();
      if (ol.getOrderLineID()==0) {
        long OrderLineID = DbUtil.getGeneratedKey(ps);
        ol.setOrderLineID(OrderLineID);
      }
      ps.close();
      
      // Now update Photos
      // Start by deleting any as this is easiest, but only if this is not an insert
      if (!insertLine) {
	      sql = "DELETE FROM OrderPhoto WHERE OrderLineID=?";
	      ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
	      ps.setLong(1,ol.getOrderLineID());
	      ps.executeUpdate();
      }
      sql = "INSERT INTO OrderPhoto (OrderLineID,ShotID,Quantity,Color,Size,FrameOrder) VALUES (?,?,?,?,?,?)";
	    ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
	    ps.setLong(1,ol.getOrderLineID());
      Vector<OrderPhoto> photos = ol.getPhotos();
	    for (int i=0;i<photos.size() && i<pc.getProductPhotos().size();i++) {
	    	ProductCard.ProductPhoto pp = pc.getProductPhotos().get(i);
        OrderPhoto photo = photos.get(i);
        ps.setLong(2,photo.getShotID());
        ps.setInt(3,(pc.getOptionList().indexOf("mould_")==-1?ol.getiQuantity():1));
        ps.setString(4,photo.getColor());
        ps.setString(5,pp.getPhotoSize());
        ps.setInt(6,i+1);
        ps.executeUpdate();
        long OrderPhotoID = DbUtil.getGeneratedKey(ps);
        photo.setOrderPhotoID(OrderPhotoID);
	    }
      ps.close();
      result = true;
    } catch (Exception e) {
	    logger.warn("saveOrderLine() Could not update: "+e.getMessage());
	    result = false;
    } finally {
    	DbUtil.freeConnection(con);
    }
    if (result) {
    	new OrderService().retotalOrder(ol.getOrderID());
    }
    return result;
  }
  
  private double getOptionPrice(String optionList) {
  	double result = 0;
  	String[] s = optionList.split(";");
  	for (int i=0;i<s.length;i++) {
  		String[] o = s[i].split(":");
  		if (o.length==2) {
  			try {
  				result += Double.parseDouble(OptionService.getOptionAttributes(o[0],o[1]));
  			} catch (Exception e) {
  				//
  			}
  		}
  	}
  	return result;
  }
  
  public boolean deleteOrderLine(OrderLine ol) {
    boolean result = false;
    Connection con = null;
    try {
      con = DbUtil.getConnection();
	    String sql = "DELETE FROM OrderPhoto WHERE OrderLineID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,ol.getOrderLineID());
	    ps.executeUpdate();
	    sql = "DELETE FROM OrderLine WHERE OrderLineID=?";
      ps = con.prepareStatement(sql);
      ps.setLong(1,ol.getOrderLineID());
	    ps.executeUpdate();
      ps.close();
      result = true;
    } catch (Exception e) {
	    logger.warn("deleteOrderLine() Could not delete: "+e.getMessage());
	    result = false;
    } finally {
    	DbUtil.freeConnection(con);
    }
    if (result) {
    	new OrderService().retotalOrder(ol.getOrderID());
    }
    return result;
  }
  
  public OrderLine[] getOrderLineList(long OrderID) {
    Vector<OrderLine> result = new Vector<OrderLine>();
    Connection con = null;
    try {
      String sql = 
	        "SELECT OL.ProductID,OL.OptionList,OL.Quantity,OL.Cost,OL.Price,OL.ExtendedPrice,OL.OrderID,OL.OrderLineID, PC.ProductDescription, " +
	        " OP.OrderPhotoID,OP.ShotID,OP.Quantity AS SHOT_QTY,OP.FrameOrder,OP.Color,OP.Size,SH.ShotName  " +
	        " FROM OrderLine OL" +
	        " INNER JOIN ProductCard PC ON PC.ProductID = OL.ProductID " +
          " LEFT OUTER JOIN OrderPhoto OP ON OP.OrderLineID = OL.OrderLineID " +
          " LEFT OUTER JOIN Shot SH ON SH.ShotID = OP.ShotID " +
	        " WHERE OL.OrderID=? ORDER BY OL.OrderLineID";
      con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,OrderID);
      ResultSet rs = ps.executeQuery();
      OrderLine ol = null;
      while (rs.next()) {
      	if (ol==null || rs.getLong("OrderLineID")!=ol.getOrderLineID()) {
      		ol = createOrderLine(rs);
      		result.add(ol);
      	}
      	if (rs.getLong("OrderPhotoID")!=0) {
      		ol.getPhotos().add(createOrderPhoto(rs));
      	}
      }
      ps.close();
    } catch (Exception e) {
    	logger.warn("getOrderLineList() Could not update: "+e.getMessage());
    	logger.error("getOrderLineList() Could not update",e);
    } finally {
    	DbUtil.freeConnection(con);
    }
    return (OrderLine[])result.toArray(new OrderLine[result.size()]);
  }
  
  private OrderLine createOrderLine(ResultSet rs) {
    OrderLine result = new OrderLine();
    try {
      result.setOrderLineID(rs.getLong("OrderLineID"));
      result.setOrderID(rs.getLong("OrderID"));
      result.setlProductID(rs.getLong("ProductID"));
      result.setOptionList(rs.getString("OptionList"));
      result.setProductDesc(rs.getString("ProductDescription"));
      result.setiQuantity(rs.getInt("Quantity"));
      result.setdCost(rs.getDouble("Cost"));
      result.setdPrice(rs.getDouble("Price"));
      result.setdExtendedPrice(rs.getDouble("ExtendedPrice"));
    } catch (Exception e) {
    	logger.warn("createOrderLine() Could not create: "+e.getMessage());
    }
    return result;  
  }

  private OrderPhoto createOrderPhoto(ResultSet rs) {
    OrderPhoto result = new OrderPhoto();
    try {
      result.setOrderPhotoID(rs.getLong("OrderPhotoID"));
      result.setShotID(rs.getLong("ShotID"));
      result.setQuantity(rs.getInt("SHOT_QTY"));
      result.setFrameOrder(rs.getInt("FrameOrder"));
      result.setSize(rs.getString("Size"));
      result.setColor(rs.getString("Color"));
      result.setShotName(rs.getString("ShotName"));
    } catch (Exception e) {
    	logger.warn("createOrderPhoto() Could not create: "+e.getMessage());
    }
    return result;  
  }

}
