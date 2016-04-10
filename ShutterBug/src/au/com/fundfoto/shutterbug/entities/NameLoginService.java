package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;
import java.security.SecureRandom;
import java.math.BigInteger;

import au.com.fundfoto.shutterbug.util.DbUtil;
import org.apache.log4j.*;

public class NameLoginService {

  static Logger logger = Logger.getLogger("NameLoginService");
  private static SecureRandom random = new SecureRandom();

  public NameLoginService() {
  }
  
  public static NameLogin getNameLogin (long NameLoginID) {
    NameLogin result = new NameLogin();
    Connection con = null;
    if (NameLoginID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT * FROM NameLogin WHERE NameLoginID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,NameLoginID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
          result = createNameLogin(rs);
        }
        rs.close();
        ps.close();
      } catch (Exception e) {
        logger.error("getNameLogin",e);
      } finally {
        DbUtil.freeConnection(con);
      }
    }
    return result;
  }
  
  public static NameLogin getNameLogin (String SessionCode) {
    NameLogin result = new NameLogin();
    Connection con = null;
    if (SessionCode!=null && SessionCode.length()!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT * FROM NameLogin WHERE SessionCode=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1,SessionCode);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
          result = createNameLogin(rs);
        }
        rs.close();
        ps.close();
      } catch (Exception e) {
        logger.error("getNameLogin",e);
      } finally {
        DbUtil.freeConnection(con);
      }
    }
    return result;
  }
  
  public static boolean saveNameLogin(NameLogin nl) {
    boolean result = false;
    Connection con = null;
    try {
      String sql = null;
      if (nl.getNameLoginID()==0) {
        sql = "INSERT INTO NameLogin (LoginID,LoginPassword,Status,AccessLevel,SessionCode,DateCreated,NameCardID) VALUES (?,?,?,?,?,?,?)";
      } else {
        sql = "UPDATE NameLogin SET LoginID=?,LoginPassword=?,Status=?,AccessLevel=?,SessionCode=?,LastLogin=? WHERE NameLoginID=?";
      }
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setString(1,nl.getLoginID());
      ps.setString(2,nl.getLoginPassword());
      ps.setString(3,nl.getStatus());
      ps.setString(4,nl.getAccessLevel());
      ps.setString(5,nl.getSessionCode());
      if (nl.getNameLoginID()!=0) {
        ps.setTimestamp(6,nl.getdLastLogin());
        ps.setLong(7,nl.getNameLoginID());
      } else {
        ps.setTimestamp(6,new java.sql.Timestamp(new java.util.Date().getTime()));
        ps.setLong(7,nl.getNameCardID());
      }
      ps.executeUpdate();
      if (nl.getNameLoginID()==0) {
        long NameLoginID = DbUtil.getGeneratedKey(ps);
        nl.setNameLoginID(NameLoginID);
      }
      ps.close();
      result = true;
    } catch (Exception e) {
      logger.warn("saveNameLogin() Could not update: "+e.getMessage());
      result = false;
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
  
  public static boolean setLastLogin(NameLogin nl) {
    boolean result = false;
    Connection con = null;
    try {
      String sql = "UPDATE NameLogin SET LastLogin=? WHERE NameLoginID=?";
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setDate(1,new java.sql.Date(new java.util.Date().getTime()));
      ps.setLong(2,nl.getNameLoginID());
      ps.executeUpdate();
      if (nl.getNameLoginID()==0) {
        long NameLoginID = DbUtil.getGeneratedKey(ps);
        nl.setNameLoginID(NameLoginID);
      }
      ps.close();
      result = true;
    } catch (Exception e) {
      logger.warn("setLastLogin() Could not update: "+e.getMessage());
      result = false;
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
  
  public static NameLogin[] getNameLoginList(long NameCardID) {
    Vector<NameLogin> result = new Vector<NameLogin>();
    Connection con = null;
 	  try {
      String sql = "SELECT LoginID,LoginPassword,Status,AccessLevel,DateCreated,LastLogin,NameLoginID,NameCardID,SessionCode FROM NameLogin WHERE NameCardID=? ORDER BY LoginID";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,NameCardID);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createNameLogin(rs));
      }
      ps.close();
    } catch (Exception e) {
 	    logger.warn("getNameLoginList() Could not update: "+e.getMessage());
 	  } finally {
 		  DbUtil.freeConnection(con);
 	  }
    return (NameLogin[])result.toArray(new NameLogin[result.size()]);
  }
  
  public static void deleteNameLogin (NameLogin nl) {
    Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "DELETE FROM NameLogin WHERE NameLoginID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,nl.getNameLoginID());
      ps.executeUpdate();
      ps.close();
    } catch (Exception e) {
      logger.error("deleteNameLogin()",e);
    } finally {
      DbUtil.freeConnection(con);
    }
  }
  
  private static NameLogin createNameLogin(ResultSet rs) {
    NameLogin result = new NameLogin();
    try {
      result.setNameLoginID(rs.getLong("NameLoginID"));
      result.setNameCardID(rs.getLong("NameCardID"));
      result.setLoginID(rs.getString("LoginID"));
      result.setLoginPassword(rs.getString("LoginPassword"));
      result.setStatus(rs.getString("Status"));
      result.setAccessLevel(rs.getString("AccessLevel"));
      result.setdDateCreated(rs.getTimestamp("DateCreated"));
      result.setdLastLogin(rs.getTimestamp("LastLogin"));
      result.setSessionCode(rs.getString("SessionCode"));
    } catch (Exception e) {
    	logger.warn("createNameLogin() Could not create: "+e.getMessage());
    }
    return result;  
  }
  
  public static String loginUser(String LoginID, String LoginPassword) {
  	String result = null;
    Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "SELECT * FROM NameLogin WHERE LoginID=? AND LoginPassword=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setString(1,LoginID);
      ps.setString(2,LoginPassword);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
      	result = nextSessionId();
      	NameLogin nl = createNameLogin(rs);
      	nl.setSessionCode(result);
      	nl.setdLastLogin(new java.sql.Timestamp(new java.util.Date().getTime()));
      	saveNameLogin(nl);
      }
      ps.close();
    } catch (Exception e) {
      logger.error("loginUser()",e);
    } finally {
      DbUtil.freeConnection(con);
    }
    if (result!=null) {
      logger.info("loginUser() OK -- LoginID="+LoginID+" SessionCode="+result);
    } else {
      logger.warn("loginUser() Failed -- LoginID="+LoginID+" Password="+LoginPassword);
    }
    return result;
  }
  
  public static boolean accessOK(String SessionCode) {
    return getNameLogin(SessionCode).getNameLoginID()!=0;
  }

  public static boolean allowFunction(String SessionCode, String function) {
    boolean result = true;
    NameLogin nl = getNameLogin(SessionCode);
    if (nl.getNameLoginID()!=0) {
      Option[] fns = new OptionService().getOptionList("LimitedAccess");
      for (int i=0;i<fns.length && result;i++) {
        if (fns[i].getOptionValue().equals(function)) {
          result = fns[i].getOptionAttributes().indexOf(nl.getAccessLevel())!=-1;
        }
      }
    }
    return result;
  }

  public static boolean logoffUser(String SessionCode) {
  	boolean result = false;
    Connection con = null;
    if (SessionCode!=null && SessionCode.length()>0) {
	    try {
	      con = DbUtil.getConnection();
	      String sql = "SELECT NameLoginID FROM NameLogin WHERE SessionCode=?";
	      PreparedStatement ps = con.prepareStatement(sql);
	      ps.setString(1,SessionCode);
	      ResultSet rs = ps.executeQuery();
	      long nameLoginID = 0;;
	      if (rs.next()) {
	      	nameLoginID = rs.getLong("NameLoginID");
	      }
	      if (nameLoginID!=0) {
	      	sql = "UPDATE NameLogin SET SessionCode='' WHERE NameLoginID=? ";
	      	ps = con.prepareStatement(sql);
	      	ps.setLong(1,nameLoginID);
	      	ps.executeUpdate();
	      }
	      ps.close();
	    } catch (Exception e) {
	      logger.error("logoffUser()", e);
	    } finally {
	      DbUtil.freeConnection(con);
	    }
    }
    return result;
  }

  private static String nextSessionId() {
    return new BigInteger(130, random).toString(32);
  }
}
