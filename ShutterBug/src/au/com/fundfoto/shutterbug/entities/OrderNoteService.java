package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;
import org.apache.log4j.*;

import au.com.fundfoto.shutterbug.util.DbUtil;

public class OrderNoteService {
	  
	private String SessionCode = null;
	
  static Logger logger = Logger.getLogger("OrderNoteService");

  public OrderNoteService() {
  }
  
  public void setSessionCode(String SessionCode) {
  	this.SessionCode = SessionCode;
  }
  
  public OrderNote getOrderNote (long OrderNoteID) {
	  OrderNote result = new OrderNote();
	  Connection con = null;
	  if (OrderNoteID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT O.OrderID, O.OrderNoteID, O.NoteSequence, O.NoteText, O.NoteDate, O.NameCardID, N.FirstName, N.LastName FROM OrderNote O " + 
        " INNER JOIN NameCard N ON N.NameCardID = O.NameCardID " +
        " WHERE O.OrderNoteID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,OrderNoteID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
      	  result = createOrderNote(rs);
        }
        rs.close();
        ps.close();
	    } catch (Exception e) {
	      logger.error("getOrderNote",e);
	    } finally {
        DbUtil.freeConnection(con);
      }
    } else {
      result.setdNoteDate(new java.sql.Date(new java.util.Date().getTime()));
      NameCard nc = new NameCardService().getNameCard(SessionCode);
      result.setNoteName(nc.getLastName() + ", " + nc.getFirstName());
      result.setNoteText("");
    }
    return result;
  }
  
  public boolean saveOrderNote(OrderNote on) {
    boolean result = false;
    Connection con = null;
	  try {
      String sql = null;
 	    if (on.getOrderNoteID()==0) {
	      sql = "INSERT INTO OrderNote (NoteText, NoteSequence, NoteDate, NameCardID, OrderID) VALUES (?,?,?,?,?)";
	    } else {
	      sql = "UPDATE OrderNote SET NoteText=? WHERE OrderNoteID=?";
	    }
 	    con = DbUtil.getConnection();
 	    PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setString(1,on.getNoteText());
      if (on.getOrderNoteID()!=0) {
        ps.setLong(2,on.getOrderNoteID());
      } else {
      	ps.setInt(2,on.getiNoteSequence());
      	ps.setDate(3,new java.sql.Date(new java.util.Date().getTime()));
      	NameCard nc = new NameCardService().getNameCard(SessionCode);
      	ps.setLong(4,nc.getNameCardID());
      	ps.setLong(5,on.getOrderID());
	  	}
      ps.executeUpdate();
      if (on.getOrderNoteID()==0) {
        long OrderNoteID = DbUtil.getGeneratedKey(ps);
        on.setOrderNoteID(OrderNoteID);
      }
      ps.close();
      result = true;
    } catch (Exception e) {
	    logger.warn("saveOrderNote() Could not update: "+e.getMessage());
	    result = false;
	  } finally {
		  DbUtil.freeConnection(con);
	  }
    return result;
  }
  
  public void deleteOrderNote (OrderNote on) {
	  Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "DELETE FROM OrderNote WHERE OrderNoteID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,on.getOrderNoteID());
      ps.executeUpdate();
      ps.close();
	  } catch (Exception e) {
	    logger.error("deleteOrderNote",e);
    } finally {
      DbUtil.freeConnection(con);
    }
  }
  
  public OrderNote[] getOrderNoteList(long OrderID) {
    Vector<OrderNote> result = new Vector<OrderNote>();
    Connection con = null;
 	  try {
      String sql = "SELECT O.OrderID, O.OrderNoteID, O.NoteSequence, O.NoteText, O.NoteDate, O.NameCardID, N.FirstName, N.LastName FROM OrderNote O " + 
        " INNER JOIN NameCard N ON N.NameCardID = O.NameCardID " +
        " WHERE O.OrderID = ? ORDER BY O.NoteSequence";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,OrderID);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createOrderNote(rs));
      }
      ps.close();
    } catch (Exception e) {
 	    logger.warn("getOrderNoteList() Could not update: "+e.getMessage());
 	  } finally {
 	  	DbUtil.freeConnection(con);
 	  }
    return (OrderNote[])result.toArray(new OrderNote[result.size()]);
  }
  
  private OrderNote createOrderNote(ResultSet rs) {
    OrderNote result = new OrderNote();
    try {
  	  result.setOrderNoteID(rs.getLong("OrderNoteID"));
      result.setOrderID(rs.getLong("OrderID"));
      result.setiNoteSequence(rs.getInt("NoteSequence"));
      result.setNoteText(rs.getString("NoteText"));
      result.setdNoteDate(rs.getDate("NoteDate"));
      result.setlNameCardID(rs.getLong("NameCardID"));
      result.setNoteName(rs.getString("LastName") + ", " +rs.getString("FirstName"));
    } catch (Exception e) {
   	  logger.warn("createOrderNote() Could not update: "+e.getMessage());
    }
    return result;
  }


}
