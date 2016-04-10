package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;
import org.apache.log4j.*;

import au.com.fundfoto.shutterbug.util.DbUtil;
import au.com.fundfoto.shutterbug.util.StringUtil;

public class OrderService {

	static Logger logger = Logger.getLogger("OrderService");

	private String orderFilter = "";
	private String orderStatus = "";
	private String errMsg = null;
	  
  public OrderService() {
  }
  
  public void setOrderFilter(String orderFilter, String orderStatus) {
    this.orderFilter = orderFilter.replaceAll("[^\\p{L}\\p{N} ]", "").toUpperCase() + "%";
    this.orderStatus = orderStatus;
  }
  
  public Order getOrder (long OrderID) {
    Order result = new Order();
    Connection con = null;
	  if (OrderID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT OrderID, OrderNumber, OrderDate, OrderStatus, TotalPrice, BalanceDue, O.NameCardID, N.FirstName, N.LastName FROM OrderCard O " +
          " LEFT OUTER JOIN NameCard N ON N.NameCardID = O.NameCardID WHERE O.OrderID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,OrderID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
      	  result = createOrder(rs);
        }
        rs.close();
        ps.close();
	    } catch (Exception e) {
	      e.printStackTrace();
      } finally {
        DbUtil.freeConnection(con);
      }
	  } else {
	  	// Set date = today and status = 'New'; Could also auto-allocate Order number based on something?
	  	result.setdOrderDate(new java.sql.Date(new java.util.Date().getTime()));
	  	result.setOrderStatus("New");
	  }
    return result;
  }
  
  public synchronized boolean saveOrder(Order or) {
    boolean result = false;
    Connection con = null;
    
    // OrderNumber may not be blank before insert, however if blank will be assigned automatically.
    if (or.getOrderID()==0 && or.getOrderNumber().length()==0) {
    	or.setOrderNumber(newOrderNumber());
    }
    // Order Number uniqueness required before save
    if (!orderNumberExists(or.getOrderID(), or.getOrderNumber())) {
      long oldNameCardID = 0;
		  try {
		  	if (or.getOrderID()!=0) {
		  		oldNameCardID = getOrder(or.getOrderID()).getlNameCardID();
		  	}
	      String sql = null;
	   	  if (or.getOrderID()==0) {
	  	    sql = "INSERT INTO OrderCard (OrderNumber, OrderDate, OrderStatus, TotalPrice, BalanceDue, NameCardID) VALUES (?,?,?,?,?,?)";
	  	  } else {
	  	    sql = "UPDATE OrderCard SET OrderNumber=?, OrderDate=?, OrderStatus=?, TotalPrice=?, BalanceDue=?, NameCardID=? WHERE OrderID=?";
	  	  }
	   	  con = DbUtil.getConnection();
	   	  PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
	      ps.setString(1,or.getOrderNumber());
	      ps.setDate(2,or.getdOrderDate());
	      ps.setString(3,or.getOrderStatus());
	      ps.setDouble(4,or.getdTotalPrice());
	      ps.setDouble(5,or.getdBalanceDue());
	      ps.setLong(6,or.getlNameCardID());
	      if (or.getOrderID()!=0) {
	        ps.setLong(7,or.getOrderID());
	      }
	      ps.executeUpdate();
	      if (or.getOrderID()==0) {
	        long OrderID = DbUtil.getGeneratedKey(ps);
	        or.setOrderID(OrderID);
	      }
	      ps.close();
      // Remove any old name relation links for this Order
	      if (oldNameCardID!=0) {
		      sql = "DELETE FROM NameRelation WHERE ParentType=? AND ParentID=? AND ChildID=? AND RelationType=?";
	     	  ps = con.prepareStatement(sql);
	   	    ps.setLong(1,NameRelation.ORDER_TYPE);
	   	    ps.setLong(2,or.getlNameCardID());
	   	    ps.setLong(3,oldNameCardID);
    	    ps.setString(4,OptionService.getOptionValue("Setup","BillToRelationType"));
	   	    ps.executeUpdate();
	      }
	      result = true;
	    } catch (Exception e) {
		    logger.warn("saveOrder() Could not update: "+e.getMessage());
		    result = false;
		  } finally {
			  DbUtil.freeConnection(con);
	    }
      // Add Name Relation link
		  if (result) {
	      // Add Name Relation link
	      NameRelationService nrs = new NameRelationService();
	      NameRelation nr = nrs.getNameRelation(0);
	      nr.setParentType(NameRelation.ORDER_TYPE);
	      nr.setlParentID(or.getOrderID());
	      nr.setlChildID(or.getlNameCardID());
	      nr.setRelationType(OptionService.getOptionValue("Setup","BillToRelationType"));
	      nrs.saveNameRelation(nr);
		  }
    } else {
    	this.errMsg = "Order Number already exists: " + or.getOrderNumber();
    }
    return result;
  }
  
  public boolean deleteOrder(Order or) {
    boolean result = false;
    Connection con = null;
    try {
      logger.warn("deleteOrder() orderID="+or.getOrderID());
      con = DbUtil.getConnection();
      // First delete any Photos
      String sql = "DELETE FROM OrderPhoto WHERE OrderLineID IN (SELECT OrderLineID FROM OrderLine WHERE OrderID=?)";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,or.getOrderID());
      ps.executeUpdate();
      
      // Next delete order lines
      sql = "DELETE FROM OrderLine WHERE OrderID=?";
      ps = con.prepareStatement(sql);
      ps.setLong(1,or.getOrderID());
      ps.executeUpdate();
      
      // Next delete order notes
      sql = "DELETE FROM OrderNote WHERE OrderID=?";
      ps = con.prepareStatement(sql);
      ps.setLong(1,or.getOrderID());
      ps.executeUpdate();
      
      // Next delete order subjects
      sql = "DELETE FROM OrderSubject WHERE OrderID=?";
      ps = con.prepareStatement(sql);
      ps.setLong(1,or.getOrderID());
      ps.executeUpdate();
      
      // Last delete order itself
      sql = "DELETE FROM OrderCard WHERE OrderID=?";
      ps = con.prepareStatement(sql);
      ps.setLong(1,or.getOrderID());
      ps.executeUpdate();
      ps.close();
      result = true;
      
    } catch (Exception e) {
      logger.warn("deleteOrder() Could not delete: "+e.getMessage());
      result = false;
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
  
  public static boolean orderNumberExists(long OrderID, String OrderNumber) {
    boolean result = false;
    Connection con = null;
    try {
      con = DbUtil.getConnection();
      // First delete any Photos
      String sql = "SELECT OrderID FROM OrderCard WHERE OrderNumber=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setString(1,OrderNumber);
      ResultSet rs = ps.executeQuery();
      result = rs.next() && rs.getLong("OrderID")!=OrderID;
    } catch (Exception e) {
      logger.warn("orderExists() Could not select: "+e.getMessage());
      result = false;
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
  
  public Order[] getOrderList() {
    Vector<Order> result = new Vector<Order>();
    Connection con = null;
 	  try {
      String sql = "SELECT OrderID, OrderNumber, OrderDate, OrderStatus, TotalPrice, BalanceDue, O.NameCardID, N.FirstName, N.LastName FROM OrderCard O " +
        " LEFT OUTER JOIN NameCard N ON N.NameCardID = O.NameCardID ";
      if (this.orderFilter.length()>0 || this.orderStatus.length()>0) {
      	sql += " WHERE ";
      }
      if (this.orderFilter.length()>0) {
        sql += " (UPPER(N.FirstName) like '" + this.orderFilter 
        		+ "' OR UPPER(N.LastName) like '" + this.orderFilter 
        		+ "' OR UPPER(N.CompanyName) like '" + this.orderFilter
        		+ "' OR UPPER(O.OrderNumber) like '" + this.orderFilter + "') ";
      }
      if (this.orderFilter.length()>0 && this.orderStatus.length()>0) {
      	sql += " AND ";
      }
      if (this.orderStatus.length()>0) {
        sql += " (O.OrderStatus = '" + this.orderStatus + "' OR '" + this.orderStatus + "' = '')";
      }
 	    sql += " ORDER BY OrderNumber";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createOrder(rs));
      }
      ps.close();
    } catch (Exception e) {
 	    logger.warn("getOrderList() Could not update: "+e.getMessage());
 	  } finally {
 		  DbUtil.freeConnection(con);
 	  }
    return (Order[])result.toArray(new Order[result.size()]);
  }
  
  public void retotalOrder (long OrderID) {
    Connection con = null;
    boolean ok = false;
    double tot = 0;
    double pmt = 0;
  	Order oc = getOrder(OrderID);
    try {
      con = DbUtil.getConnection();
      String sql = "SELECT SUM(Quantity * Price) AS EXTQTY FROM OrderLine WHERE OrderID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,OrderID);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
    	  tot = rs.getDouble("EXTQTY");
      }
      sql = "SELECT SUM(Amount) AS PMT FROM OrderPayment WHERE OrderID=?";
      ps = con.prepareStatement(sql);
      ps.setLong(1,OrderID);
      rs = ps.executeQuery();
      if (rs.next()) {
    	  pmt = rs.getDouble("PMT");
      }
      rs.close();
      ps.close();
      ok = true;
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DbUtil.freeConnection(con);
    }
    if (ok) {
    	oc.setdTotalPrice(tot);
    	oc.setdBalanceDue(tot - pmt);
    	saveOrder(oc);
    }
  }
  
  private String newOrderNumber() {
  	String result = null;
    Connection con = null;
    try {
      con = DbUtil.getConnection();
    	String orderFormat = OptionService.getOptionValue("Setup","OrderFormat");
    	String formatPrefix = StringUtil.getFormatPrefix(orderFormat);
      String sql = "SELECT OrderNumber FROM OrderCard WHERE OrderNumber LIKE ? ORDER BY OrderNumber DESC LIMIT 1";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setString(1,formatPrefix + "%");
      ResultSet rs = ps.executeQuery();
      long nextNumber = 0;
      if (rs.next()) {
    	  nextNumber = StringUtil.parseNumber(rs.getString("OrderNumber"),orderFormat);
      }
      rs.close();
      ps.close();
      result = StringUtil.formatNumber(nextNumber + 1,orderFormat);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DbUtil.freeConnection(con);
    }
  	return result;
  }
  
  public int countOrders(String JobCode) {
    int result = 0;
    Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "SELECT COUNT(*) FROM OrderCard WHERE OrderNumber LIKE ?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setString(1,JobCode + "%");
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
        result = rs.getInt(1);
      }
      rs.close();
      ps.close();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
  
  private Order createOrder(ResultSet rs) {
    Order result = new Order();
    try {
      result.setOrderID(rs.getLong("OrderID"));
      result.setOrderNumber(rs.getString("OrderNumber"));
      result.setdOrderDate(rs.getDate("OrderDate"));
      result.setOrderStatus(rs.getString("OrderStatus"));
      result.setdTotalPrice(rs.getDouble("TotalPrice"));
      result.setdBalanceDue(rs.getDouble("BalanceDue"));
      result.setlNameCardID(rs.getLong("NameCardID"));
      result.setBillToName(rs.getString("LastName") + ", " +rs.getString("FirstName"));
    } catch (Exception e) {
      logger.warn("createOrder() Unable to create Order");
    }
    return result;
  }
  
  public String getErrMsg() {
  	return this.errMsg;
  }

}
