package au.com.fundfoto.shutterbug.util;

import java.sql.Statement;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import org.apache.log4j.*;

public class DbUtil {
	
  static Logger logger = Logger.getLogger("DbUtil");

  public DbUtil() {
  }
  
  public static Connection getConnection() {
    Connection result = null;
    try {
      Context initContext = new InitialContext();
      Context envContext  = (Context)initContext.lookup("java:/comp/env");
      DataSource ds = (DataSource)envContext.lookup("jdbc/ShutterBug");
      int tries = 0;
      while (tries<3 && result==null) {
        result = connect(ds);
        tries++;
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return result;
  }
  
  public static Connection connect(DataSource ds) {
    Connection result = null;
    try {
      result = setConnection(ds);
      result.setAutoCommit(false);
    } catch (Exception e) {
      result = null;
      logger.warn("connect()"+e.getMessage());
    }
    return result;
  }
  
  private static Connection setConnection(DataSource ds) {
    Connection result = null;
    try {
      result = ds.getConnection();
    } catch (Exception e) {
      logger.warn("setConnection() " + e.getMessage());
    }
    return result;
  }
  
  public static void freeConnection(Connection con) {
    try {
      if (con != null && !con.isClosed()) {
        con.commit();
        con.close();
      }
    } catch (SQLException sqle) {
      sqle.printStackTrace();
    }
  }

  public static boolean canConnect() {
    boolean result = false;
    Connection con = null;
    try {
      con = getConnection();
      if (con != null) {
        freeConnection(con);
        result = true;
      }
    } catch (Exception e) {}
    return result;
  }

  public static long getGeneratedKey(PreparedStatement ps) {
    long id = 0L;
    try {
      ResultSet rs = ps.getGeneratedKeys();
      if (rs.next()) {
        id = rs.getInt(1);
      }      
      rs.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
    return id;
  }

  public static long getGeneratedKey(Statement stmt) {
    long id = 0L;
    try {
      ResultSet rs = stmt.getGeneratedKeys();
      if (rs.next()) {
        id = rs.getInt(1);
      }      
      rs.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
    return id;
  }
  
  public static boolean allowDelete(String keyField, long idValue, String tableList) {
  	boolean result = true;
    Connection con = null;
    String sql = null;
 	  try {
 	    con = getConnection();
 	    String[] t = tableList.split(",");
 	    for (int i=0;i<t.length && result;i++) {
  	    Statement ps = con.createStatement();
        sql = "SELECT " + keyField + " FROM " + t[i] + " WHERE " + keyField + " = " + idValue;
        ResultSet rs = ps.executeQuery(sql);
        result = !rs.next();
        ps.close();
      }
    } catch (Exception e) {
 	    logger.warn("allowDelete() Could not check: sql="+sql+" error="+e.getMessage());
 	  } finally {
 		  freeConnection(con);
 	  }
  	return result;
  }

}
