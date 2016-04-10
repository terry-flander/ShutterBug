package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;
import org.apache.log4j.*;

import au.com.fundfoto.shutterbug.util.DbUtil;

public class OrderSubjectService {
	  
  static Logger logger = Logger.getLogger("OrderSubjectService");

  public OrderSubjectService() {
  }
  
  public OrderSubject getOrderSubject (long OrderSubjectID) {
	  OrderSubject result = new OrderSubject();
	  Connection con = null;
	  if (OrderSubjectID!=0) {
      try {
        con = DbUtil.getConnection();
	      String sql = "SELECT OS.OrderID, OS.OrderSubjectID, OS.SubjectID, SU.SubjectCode, SU.FirstName, SU.LastName FROM OrderSubject OS " + 
	        " INNER JOIN Subject SU ON SU.SubjectID = OS.SubjectID " +
	        " WHERE Os.OrderSubjectID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,OrderSubjectID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
      	  result = createOrderSubject(rs);
        }
        rs.close();
        ps.close();
	    } catch (Exception e) {
	      logger.error("getOrderSubject",e);
	    } finally {
        DbUtil.freeConnection(con);
      }
    }
    return result;
  }
  
  public boolean saveOrderSubject(OrderSubject on, boolean mergeOrders) {
    boolean result = false;
    Connection con = null;
	  try {
	    if (mergeOrders) {
	      mergeSubjectOrders(on);
	    }
      String sql = null;
 	    if (on.getOrderSubjectID()==0) {
	      sql = "INSERT INTO OrderSubject (SubjectID, OrderID) VALUES (?,?)";
	    } else {
	      sql = "UPDATE OrderSubject SET SubjectID=? WHERE OrderSubjectID=?";
	    }
 	    con = DbUtil.getConnection();
 	    PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setLong(1,on.getlSubjectID());
      if (on.getOrderSubjectID()!=0) {
        ps.setLong(2,on.getOrderSubjectID());
      } else {
        ps.setLong(2,on.getOrderID());
      }
      logger.info("SubjectID="+on.getSubjectID()+" OrderID="+on.getOrderID());
      ps.executeUpdate();
      if (on.getOrderSubjectID()==0) {
        long OrderSubjectID = DbUtil.getGeneratedKey(ps);
        on.setOrderSubjectID(OrderSubjectID);
      }
      ps.close();
      result = true;
    } catch (Exception e) {
	    logger.warn("saveOrderSubject() Could not update: "+e.getMessage());
	    result = false;
	  } finally {
		  DbUtil.freeConnection(con);
	  }
    return result;
  }
  
  private void mergeSubjectOrders(OrderSubject on) {
    Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "UPDATE OrderCard SET TotalPrice=0,BalanceDue=0 WHERE OrderID IN (SELECT OrderID FROM OrderSubject WHERE SubjectID=?) AND OrderStatus='New'";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,on.getlSubjectID());
      ps.executeUpdate();
      sql = "UPDATE OrderLine OL SET OL.OrderID=? WHERE OL.OrderID IN (SELECT OrderID FROM OrderSubject WHERE SubjectID=?) AND EXISTS (SELECT 1 FROM OrderCard OC WHERE OC.OrderID = OL.OrderID AND OrderStatus='New')";
      ps = con.prepareStatement(sql);
      ps.setLong(1,on.getOrderID());
      ps.setLong(2,on.getlSubjectID());
      ps.executeUpdate();
      ps.close();
      logger.info("Merge: SubjectID="+on.getSubjectID()+" OrderID="+on.getOrderID());
    } catch (Exception e) {
      logger.error("deleteOrderSubject",e);
    } finally {
      DbUtil.freeConnection(con);
    }
  }
  
  public void deleteOrderSubject (OrderSubject on) {
	  Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "DELETE FROM OrderSubject WHERE OrderSubjectID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,on.getOrderSubjectID());
      ps.executeUpdate();
      ps.close();
	  } catch (Exception e) {
	    logger.error("deleteOrderSubject",e);
    } finally {
      DbUtil.freeConnection(con);
    }
  }
  
  public OrderSubject[] getOrderSubjectList(long OrderID) {
    Vector<OrderSubject> result = new Vector<OrderSubject>();
    Connection con = null;
 	  try {
      String sql = "SELECT OS.OrderID, OS.OrderSubjectID, OS.SubjectID, SU.SubjectCode, SU.FirstName, SU.LastName FROM OrderSubject OS " + 
        " INNER JOIN Subject SU ON SU.SubjectID = OS.SubjectID " +
        " WHERE OS.OrderID = ? ORDER BY SU.LastName, SU.FirstName";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,OrderID);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createOrderSubject(rs));
      }
      ps.close();
    } catch (Exception e) {
 	    logger.warn("getOrderSubjectList() Could not update: "+e.getMessage());
 	  } finally {
 	  	DbUtil.freeConnection(con);
 	  }
    return (OrderSubject[])result.toArray(new OrderSubject[result.size()]);
  }
  
  private OrderSubject createOrderSubject(ResultSet rs) {
    OrderSubject result = new OrderSubject();
    try {
  	  result.setOrderSubjectID(rs.getLong("OrderSubjectID"));
      result.setOrderID(rs.getLong("OrderID"));
      result.setlSubjectID(rs.getLong("SubjectID"));
      result.setSubjectCode(rs.getString("SubjectCode"));
      result.setSubjectName(rs.getString("LastName") + ", " +rs.getString("FirstName"));
    } catch (Exception e) {
   	  logger.warn("createOrderSubject() Could not update: "+e.getMessage());
    }
    return result;
  }


}
