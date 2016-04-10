package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;
import java.util.Hashtable;

import au.com.fundfoto.shutterbug.util.DbUtil;
import org.apache.log4j.*;

public class ShotService {
	  
  static Logger logger = Logger.getLogger("ShotService");

  public ShotService() {
  }
  
  public Shot getShot (long ShotID) {
		Shot result = new Shot();
		Connection con = null;
		if (ShotID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT SubjectID,ShotID,ShotNo,ShotName,OriginalName,OriginalDirectory FROM Shot WHERE ShotID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,ShotID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
        	result = createShot(rs);
        }
        rs.close();
        ps.close();
	  } catch (Exception e) {
	    logger.error("getShot()",e);
    } finally {
      DbUtil.freeConnection(con);
    }
	}
    return result;
  }
  
  public boolean saveShot(Shot sh) {
    boolean result = false;
    Connection con = null;
    try {
  	  String sql = null;
   	  if (sh.getShotID()==0) {
  	    sql = "INSERT INTO Shot (ShotName,OriginalName,OriginalDirectory,ShotNo,SubjectID) VALUES (?,?,?,?,?)";
  	  } else {
  	    sql = "UPDATE Shot SET ShotName=?,OriginalName=?,OriginalDirectory=?,ShotNo=? WHERE ShotID=?";
  	  }
   	  con = DbUtil.getConnection();
   	  PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
   	  ps.setString(1,sh.getShotName());
   	  ps.setString(2,sh.getOriginalName());
   	  ps.setString(3,sh.getOriginalDirectory());
      ps.setInt(4,sh.getShotNo());
      if (sh.getShotID()!=0) {
        ps.setLong(5,sh.getShotID());
      } else {
     	  ps.setLong(5,sh.getSubjectID());
      }
      ps.executeUpdate();
      if (sh.getShotID()==0) {
        long ShotID = DbUtil.getGeneratedKey(ps);
        sh.setSubjectID(ShotID);
      }
      ps.close();
      result = true;
	  } catch (Exception e) {
	    logger.warn("saveShot() Could not update: "+e.getMessage());
	    result = false;
	  } finally {
		  DbUtil.freeConnection(con);
	  }
    return result;
  }
  
  public Shot[] getShotList(long SubjectID) {
	  Vector<Shot> result = new Vector<Shot>();
	  Connection con = null;
	 	try {
	    String sql = "SELECT SubjectID,ShotID,ShotNo,ShotName,OriginalName,OriginalDirectory FROM Shot WHERE SubjectID=? ORDER BY ShotName";
	 	  con = DbUtil.getConnection();
	  	PreparedStatement ps = con.prepareStatement(sql);
	    ps.setLong(1,SubjectID);
	    ResultSet rs = ps.executeQuery();
	    while (rs.next()) {
	      result.add(createShot(rs));
	    }
	    ps.close();
	  } catch (Exception e) {
	 	  logger.warn("getShotList() Could not update: "+e.getMessage());
	 	} finally {
	 		DbUtil.freeConnection(con);
	 	}
	  return (Shot[])result.toArray(new Shot[result.size()]);
	}
	  
  public String getSubjectShotListHTML(long SubjectID) {
  	StringBuffer result = new StringBuffer();
    Shot[] shots = getShotList(SubjectID);
    for (int j=0;j<shots.length;j++) {
      result.append("<option value='" + shots[j].getShotID() + "'>" + shots[j].getShotName() + "</option>");
    }
    return result.toString();
  }

  public int getLastShotNo(long SubjectID) {
    int result = 0;
    Connection con = null;
    try {
      String sql = "SELECT ShotNo FROM Shot WHERE SubjectID=? ORDER BY ShotNo DESC LIMIT 1";
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,SubjectID);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
        result = rs.getInt("ShotNo");
      }
      ps.close();
    } catch (Exception e) {
      logger.warn("getLastShotNo() Could not select: "+e.getMessage());
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
    
  public void deleteShot (Shot sh) {
	  Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "DELETE FROM Shot WHERE ShotID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,sh.getShotID());
      ps.executeUpdate();
      ps.close();
	  } catch (Exception e) {
	    logger.error("deleteShot()",e);
    } finally {
      DbUtil.freeConnection(con);
    }
  }
  
  public void deleteJobShots (long JobCardID) {
  	Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "DELETE FROM Shot WHERE SubjectID IN (SELECT SubjectID FROM Subject WHERE SessionID IN (SELECT SessionID from Session WHERE JobCardID = ?))";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,JobCardID);
      ps.executeUpdate();
      ps.close();
	  } catch (Exception e) {
	    logger.error("deleteJobShots()",e);
    } finally {
      DbUtil.freeConnection(con);
    }
  }
  
  public boolean shotExists (String dir, String name) {
    boolean result = false;
    Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "SELECT * FROM Shot WHERE OriginalDirectory=? AND OriginalName=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setString(1,dir);
      ps.setString(2,name);
      ResultSet rs = ps.executeQuery();
      result = rs.next();
      rs.close();
      ps.close();
    } catch (Exception e) {
      logger.error("shotExits()",e);
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
  
  public boolean shotExists (long jobCardID, String name) {
    boolean result = false;
    Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "SELECT * FROM Shot " +
        " INNER JOIN Subject ON Shot.SubjectID = Subject.SubjectID " +
        " INNER JOIN Session ON Session.SessionID = Subject.SessionID " +
        " WHERE ShotName=? AND Session.JobCardID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setString(1,name);
      ps.setLong(2,jobCardID);
      ResultSet rs = ps.executeQuery();
      result = rs.next();
      rs.close();
      ps.close();
    } catch (Exception e) {
      logger.error("shotExists()",e);
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
  
  public Hashtable<String,Shot> getJobShots (long jobCardID) {
    Hashtable<String, Shot> result = new Hashtable<String, Shot>();
    Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "SELECT * FROM Shot " +
        " INNER JOIN Subject ON Shot.SubjectID = Subject.SubjectID " +
        " INNER JOIN Session ON Session.SessionID = Subject.SessionID " +
        " WHERE Session.JobCardID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,jobCardID);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.put(rs.getString("ShotName"), createShot(rs));
      }
      rs.close();
      ps.close();
    } catch (Exception e) {
      logger.error("getJobShots()",e);
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
  
  private Shot createShot(ResultSet rs) {
	  Shot result = new Shot();
 	  try {
  	  result.setSubjectID(rs.getLong("SubjectID"));
  	  result.setShotID(rs.getLong("ShotID"));
      result.setShotName(rs.getString("ShotName"));
      result.setOriginalName(rs.getString("OriginalName"));
      result.setOriginalDirectory(rs.getString("OriginalDirectory"));
      result.setShotNo(rs.getInt("ShotNo"));
 	  } catch (Exception e) {
      logger.warn("createShot() Could not update: "+e.getMessage());
 	  }
 	  return result;
  }
}
