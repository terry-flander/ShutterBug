package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;

import au.com.fundfoto.shutterbug.util.DbUtil;
import org.apache.log4j.*;

public class JobSessionService {
	  
  static Logger logger = Logger.getLogger("JobSessionService");

  public JobSessionService() {
  }
  
  public JobSession getJobSession (long SessionID) {
	JobSession result = new JobSession();
	Connection con = null;
	if (SessionID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT * FROM Session WHERE SessionID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,SessionID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
      	  result = createJobSession(rs);
        }
        rs.close();
        ps.close();
	  } catch (Exception e) {
	    e.printStackTrace();
      } finally {
        DbUtil.freeConnection(con);
      }
	}
    return result;
  }
  
  public boolean saveJobSession(JobSession js) {
    boolean result = false;
    Connection con = null;
	try {
      String sql = null;
 	  if (js.getSessionID()==0) {
	    sql = "INSERT INTO Session (Name,Code,Description,Date,StartTime,EndTime,JobCardID) VALUES (?,?,?,?,?,?,?)";
	  } else {
	    sql = "UPDATE Session SET Name=?,Code=?,Description=?,Date=?,StartTime=?,EndTime=? WHERE SessionID=?";
	  }
 	  con = DbUtil.getConnection();
 	  PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setString(1,js.getName());
      ps.setString(2,js.getCode());
      ps.setString(3,js.getDescription());
      ps.setDate(4,js.getdSessionDate());
      ps.setTime(5,js.getdStartTime());
      ps.setTime(6,js.getdEndTime());
      if (js.getSessionID()!=0) {
        ps.setLong(7,js.getSessionID());
      } else {
          ps.setLong(7,js.getJobCardID());
      }
      ps.executeUpdate();
      if (js.getSessionID()==0) {
        long SessionID = DbUtil.getGeneratedKey(ps);
        js.setSessionID(SessionID);
      }
      ps.close();
      result = true;
	} catch (Exception e) {
	    logger.warn("saveJobSession() Could not update: "+e.getMessage());
	    result = false;
	} finally {
		DbUtil.freeConnection(con);
	}
    return result;
  }
  
  public JobSession[] getJobSessionList(long JobCardID) {
    Vector<JobSession> result = new Vector<JobSession>();
    Connection con = null;
 	try {
      String sql = "SELECT SessionID,JobCardID,Name,Code,Description,Date,StartTime,EndTime FROM Session WHERE JobCardID=? ORDER BY Name";
 	  con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,JobCardID);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createJobSession(rs));
      }
      ps.close();
    } catch (Exception e) {
 	  logger.warn("getJobSessionList() Could not update: "+e.getMessage());
 	} finally {
 		DbUtil.freeConnection(con);
 	}
    return (JobSession[])result.toArray(new JobSession[result.size()]);
  }
  
  private JobSession createJobSession(ResultSet rs) {
    JobSession result = new JobSession();
    try {
      result.setSessionID(rs.getLong("SessionID"));
      result.setJobCardID(rs.getLong("JobCardID"));
      result.setName(rs.getString("Name"));
      result.setCode(rs.getString("Code"));
      result.setDescription(rs.getString("Description"));
      result.setdSessionDate(rs.getDate("Date"));
      result.setdStartTime(rs.getTime("StartTime"));
      result.setdEndTime(rs.getTime("EndTime"));
    } catch (Exception e) {
	  logger.warn("createJobSession() Could not create: "+e.getMessage());
    }
    return result;  
  }


}
