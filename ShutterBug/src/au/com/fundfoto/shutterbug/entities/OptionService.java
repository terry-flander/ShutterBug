package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;

import au.com.fundfoto.shutterbug.util.DbUtil;
import org.apache.log4j.*;

public class OptionService {
	  
  static Logger logger = Logger.getLogger("OptionService");

  public OptionService() {
  }
  
  public Option getOption (long OptionID) {
	Option result = new Option();
	Connection con = null;
	if (OptionID!=0) {
    try {
      con = DbUtil.getConnection();
      String sql = "SELECT * FROM SelectionOption WHERE OptionID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,OptionID);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
    	  result = createOption(rs);
      }
      rs.close();
      ps.close();
	  } catch (Exception e) {
	    logger.error("geOption()",e);
    } finally {
      DbUtil.freeConnection(con);
    }
	}
    return result;
  }
  
  public boolean saveOption(Option op) {
    boolean result = false;
    Connection con = null;
    try {
      String sql = null;
	 	  if (op.getOptionID()==0) {
		    sql = "INSERT INTO SelectionOption (OptionName,OptionValue,OptionAttributes,SelectionID) VALUES (?,?,?,?)";
		  } else {
		    sql = "UPDATE SelectionOption SET OptionName=?,OptionValue=?,OptionAttributes=? WHERE OptionID=?";
		  }
	 	  con = DbUtil.getConnection();
	 	  PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setString(1,op.getOptionName());
      ps.setString(2,op.getOptionValue());
      ps.setString(3,op.getOptionAttributes());
      if (op.getOptionID()==0) {
        ps.setLong(4,op.getSelectionID());
      } else {
          ps.setLong(4,op.getOptionID());
      }
      ps.executeUpdate();
      if (op.getOptionID()==0) {
        long OptionID = DbUtil.getGeneratedKey(ps);
        op.setOptionID(OptionID);
      }
      ps.close();
      result = true;
		} catch (Exception e) {
	    logger.warn("saveOption() Could not update: "+e.getMessage());
	    result = false;
		} finally {
			DbUtil.freeConnection(con);
		}
    return result;
  }
  
  public Option[] getOptionList(String SelectionCode) {
    return getOptionList(SelectionCode, 0);
  }

  public Option[] getOptionList(long SelectionID) {
    return getOptionList("", SelectionID);
  }

  private Option[] getOptionList(String SelectionCode, long SelectionID) {
    Vector<Option> result = new Vector<Option>();
    Connection con = null;
    try {
      String sql = "SELECT SelectionID,OptionID,OptionName,OptionValue,OptionAttributes FROM SelectionOption " +
      (SelectionCode.length()==0?"WHERE SelectionID=?":"WHERE SelectionID IN (SELECT SelectionID FROM Selection WHERE SelectionCode=?)") +
      " ORDER BY OptionName";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
  	  if (SelectionCode.length()==0) {
        ps.setLong(1,SelectionID);
  	  } else {
        ps.setString(1,SelectionCode);
  	  }
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createOption(rs));
      }
      ps.close();
    } catch (Exception e) {
 	  logger.warn("getOptionList() Could not update: "+e.getMessage());
 	} finally {
 		DbUtil.freeConnection(con);
 	}
    return (Option[])result.toArray(new Option[result.size()]);
  }
  
  public static String getHTMLOptionList(String SelectionCode) {
    StringBuffer result = new StringBuffer(1000);
    Connection con = null;
 	  try {
      String sql = "SELECT OptionName,OptionValue FROM SelectionOption WHERE SelectionID = (SELECT SelectionID from Selection WHERE SelectionCode=?) ORDER BY OptionName";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ps.setString(1,SelectionCode);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.append("<option value=\"" + rs.getString("OptionValue") + "\">" + rs.getString("OptionName") + "</option>");
      }
      ps.close();
    } catch (Exception e) {
 	    logger.warn("getHTMLOptionList() Could not update: "+e.getMessage());
 	  } finally {
 		  DbUtil.freeConnection(con);
 	  }
    return result.toString();
  }
	  
  public static String getOptionValue(String SelectionCode, String OptionName) {
    String result = null;
    Connection con = null;
    try {
      String sql = "SELECT OptionValue FROM SelectionOption WHERE SelectionID = (SELECT SelectionID from Selection WHERE SelectionCode=?) AND OptionName=?";
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setString(1,SelectionCode);
      ps.setString(2,OptionName);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
        result = rs.getString("OptionValue");
      }
      ps.close();
    } catch (Exception e) {
      logger.warn("getOptionValue() Could not get: SelectionCode="+SelectionCode+" OptionName="+OptionName+" Error:"+e.getMessage());
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
  
  public static String getOptionName(String SelectionCode, String OptionValue) {
    String result = null;
    Connection con = null;
    try {
      String sql = "SELECT OptionName FROM SelectionOption WHERE SelectionID = (SELECT SelectionID from Selection WHERE SelectionCode=?) AND OptionValue=?";
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setString(1,SelectionCode);
      ps.setString(2,OptionValue);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
        result = rs.getString("OptionName");
      }
      ps.close();
    } catch (Exception e) {
      logger.warn("getOptionName() Could not get: SelectionCode="+SelectionCode+" OptionValue="+OptionValue+" Error:"+e.getMessage());
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }

  public static String getOptionAttributes(String SelectionCode, String OptionValue) {
    String result = null;
    Connection con = null;
    try {
      String sql = "SELECT OptionAttributes FROM SelectionOption WHERE SelectionID = (SELECT SelectionID from Selection WHERE SelectionCode=?) AND OptionValue=?";
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setString(1,SelectionCode);
      ps.setString(2,OptionValue);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
        result = rs.getString("OptionAttributes");
      }
      ps.close();
    } catch (Exception e) {
      logger.warn("getOptionAttributes() Could not get: SelectionCode="+SelectionCode+" OptionValue="+OptionValue+" Error:"+e.getMessage());
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }

  public void deleteOption (Option op) {
	Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "DELETE FROM SelectionOption WHERE OptionID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,op.getOptionID());
      ps.executeUpdate();
      ps.close();
	} catch (Exception e) {
	  logger.error("deleteOption",e);
    } finally {
      DbUtil.freeConnection(con);
    }
  }
  
  public boolean duplicateCheck(Option op) {
    boolean result = false;
    Connection con = null;
 	try {
	 String sql = "SELECT * FROM SelectionOption WHERE SelectionID=? AND OptionValue=? AND OptionID<>?";
 	  con= DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
  	  ps.setLong(1,op.getSelectionID());
  	  ps.setString(2,op.getOptionValue());
  	  ps.setLong(3,op.getOptionID());
      ResultSet rs = ps.executeQuery();
      result = (rs.next());
      ps.close();
    } catch (Exception e) {
 	  logger.warn("duplicateCheck() Could not update: "+e.getMessage());
 	} finally {
 		DbUtil.freeConnection(con);
 	}
    return result;
  }
		  
 private Option createOption(ResultSet rs) {
    Option result = new Option();
    try {
  	  result.setSelectionID(rs.getLong("SelectionID"));
      result.setOptionID(rs.getLong("OptionID"));
      result.setOptionName(rs.getString("OptionName"));
      result.setOptionValue(rs.getString("OptionValue"));
      result.setOptionAttributes(rs.getString("OptionAttributes"));
    } catch (Exception e) {
 	    logger.warn("createOption() Could not create: "+e.getMessage());
    }
    return result;
  }


}
