package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;

import au.com.fundfoto.shutterbug.util.DbUtil;
import org.apache.log4j.*;

public class SelectionService {
	  
  static Logger logger = Logger.getLogger("SelectionService");

  public SelectionService() {
  }
  
  public Selection getSelection (long SelectionID) {
	Selection result = new Selection();
	Connection con = null;
	if (SelectionID!=0) {
    try {
      con = DbUtil.getConnection();
      String sql = "SELECT * FROM Selection WHERE SelectionID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,SelectionID);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
    	  result = createSelection(rs);
      }
      rs.close();
      ps.close();
    } catch (Exception e) {
      logger.error("getSelection()",e);
    } finally {
      DbUtil.freeConnection(con);
    }
	}
    return result;
  }
  
  public boolean saveSelection(Selection se) {
    boolean result = false;
    Connection con = null;
		try {
	      String sql = null;
	 	  if (se.getSelectionID()==0) {
		    sql = "INSERT INTO Selection (SelectionCode,Description) VALUES (?,?)";
		  } else {
		    sql = "UPDATE Selection SET SelectionCode=?,Description=? WHERE SelectionID=?";
		  }
	 	  con = DbUtil.getConnection();
	 	  PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setString(1,se.getSelectionCode());
      ps.setString(2,se.getDescription());
      if (se.getSelectionID()!=0) {
        ps.setLong(3,se.getSelectionID());
      }
      ps.executeUpdate();
      if (se.getSelectionID()==0) {
        long SelectionID = DbUtil.getGeneratedKey(ps);
        se.setSelectionID(SelectionID);
      }
      ps.close();
      result = true;
		} catch (Exception e) {
	    logger.warn("saveSelection() Could not update: "+e.getMessage());
	    result = false;
		} finally {
			DbUtil.freeConnection(con);
		}
    return result;
  }
  
  public Selection[] getSelectionList() {
    Vector<Selection> result = new Vector<Selection>();
    Connection con = null;
    try {
      String sql = "SELECT SelectionID,SelectionCode,Description FROM Selection ORDER BY SelectionCode";
      con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createSelection(rs));
      }
      ps.close();
    } catch (Exception e) {
    	logger.warn("getSelectionList() Could not update: "+e.getMessage());
	 	} finally {
	 		DbUtil.freeConnection(con);
	 	}
    return (Selection[])result.toArray(new Selection[result.size()]);
  }

  private Selection createSelection(ResultSet rs) {
		Selection result = new Selection();
		try {
		  result.setSelectionID(rs.getLong("SelectionID"));
	      result.setSelectionCode(rs.getString("SelectionCode"));
	      result.setDescription(rs.getString("Description"));
		} catch (Exception e) {
	    logger.warn("createSelection() Could not create: "+e.getMessage());
	  }
		return result;
  }

}
