package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;

import au.com.fundfoto.shutterbug.util.DbUtil;
import org.apache.log4j.*;

public class OrderPaymentService {
	  
  static Logger logger = Logger.getLogger("OrderPaymentService");

  public OrderPaymentService() {
  }
  
  public OrderPayment getOrderPayment (long PaymentID) {
  	OrderPayment result = null;
  	Connection con = null;
  	if (PaymentID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = 
	        "SELECT OrderID, PaymentID, PaymentDate, Type, Amount, Note " +
	        " FROM OrderPayment " +
	        " WHERE PaymentID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,PaymentID);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
        	if (result==null) {
        		result = createOrderPayment(rs);
        	}
        }
        rs.close();
        ps.close();
      } catch (Exception e) {
      	logger.error("getOrderPayment() Error: " + e.getMessage());
      } finally {
        DbUtil.freeConnection(con);
      }
  	}
    return (result==null?new OrderPayment():result);
  }
  
  public boolean saveOrderPayment(OrderPayment op) {
    boolean result = false;
    Connection con = null;
    try {
    	boolean insertLine = op.getPaymentID()==0;
      String sql = null;
      if (insertLine) {
      	sql = "INSERT INTO OrderPayment (PaymentDate, Type, Amount, Note, OrderID) VALUES (?,?,?,?,?)";
      } else {
      	sql = "UPDATE OrderPayment SET PaymentDate=?,Type=?,Amount=?,Note=? WHERE PaymentID=?";
      }
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setDate(1,op.getdPaymentDate());
      ps.setString(2,op.getType());
      ps.setDouble(3,op.getdAmount());
      ps.setString(4,op.getNote());
      if (!insertLine) {
        ps.setLong(5,op.getPaymentID());
      } else {
        ps.setLong(5,op.getOrderID());
      }
      ps.executeUpdate();
      if (op.getPaymentID()==0) {
        long PaymentID = DbUtil.getGeneratedKey(ps);
        op.setPaymentID(PaymentID);
      }
      ps.close();
      
      result = true;
    } catch (Exception e) {
	    logger.warn("saveOrderPayment() Could not update: "+e.getMessage());
	    result = false;
    } finally {
    	DbUtil.freeConnection(con);
    }
    if (result) {
    	new OrderService().retotalOrder(op.getOrderID());
    }
    return result;
  }
  
  public boolean deleteOrderPayment(OrderPayment ol) {
    boolean result = false;
    Connection con = null;
    try {
      con = DbUtil.getConnection();
	    String sql = "DELETE FROM OrderPayment WHERE PaymentID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,ol.getPaymentID());
	    ps.executeUpdate();
      ps.close();
      result = true;
    } catch (Exception e) {
	    logger.warn("deleteOrderPayment() Could not delete: "+e.getMessage());
	    result = false;
    } finally {
    	DbUtil.freeConnection(con);
    }
    if (result) {
    	new OrderService().retotalOrder(ol.getOrderID());
    }
    return result;
  }
  
  public OrderPayment[] getOrderPaymentList(long OrderID) {
    Vector<OrderPayment> result = new Vector<OrderPayment>();
    Connection con = null;
    try {
      String sql = "SELECT OrderID, PaymentID, PaymentDate, Type, Amount, Note FROM OrderPayment WHERE OrderID=? ORDER BY PaymentID";
      con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,OrderID);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
    		result.add(createOrderPayment(rs));
      }
      ps.close();
    } catch (Exception e) {
    	logger.warn("getOrderPaymentList() Could not update: "+e.getMessage());
    	logger.error("getOrderPaymentList() Could not update",e);
    } finally {
    	DbUtil.freeConnection(con);
    }
    return (OrderPayment[])result.toArray(new OrderPayment[result.size()]);
  }
  
  private OrderPayment createOrderPayment(ResultSet rs) {
    OrderPayment result = new OrderPayment();
    try {
      result.setPaymentID(rs.getLong("PaymentID"));
      result.setOrderID(rs.getLong("OrderID"));
      result.setdPaymentDate(rs.getDate("PaymentDate"));
      result.setType(rs.getString("Type"));
      result.setNote(rs.getString("Note"));
      result.setdAmount(rs.getDouble("Amount"));
    } catch (Exception e) {
    	logger.warn("createOrderPayment() Could not create: "+e.getMessage());
    }
    return result;  
  }

}
