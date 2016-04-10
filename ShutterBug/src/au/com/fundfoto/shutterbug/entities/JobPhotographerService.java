package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;
import org.apache.log4j.*;

import au.com.fundfoto.shutterbug.util.DbUtil;

public class JobPhotographerService {
	  
  static Logger logger = Logger.getLogger("JobPhotographerService");

  public JobPhotographerService() {
  }
  
  public JobPhotographer getJobPhotographer (long JobPhotographerID) {
	  JobPhotographer result = new JobPhotographer();
	  Connection con = null;
	  if (JobPhotographerID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT JobPhotographerID, JobCardID, JP.NameCardID,Directory,Prefix,N.LastName,N.MiddleName,N.FirstName,N.CompanyName FROM JobPhotographer JP, NameCard N WHERE JP.NameCardID = N.NameCardID AND JobPhotographerID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,JobPhotographerID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
      	  result = createJobPhotographer(rs);
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
  
  public boolean saveJobPhotographer(JobPhotographer jp) {
    boolean result = false;
    Connection con = null;
	  try {
      String sql = null;
 	    if (jp.getJobPhotographerID()==0) {
	      sql = "INSERT INTO JobPhotographer (NameCardID,Directory,Prefix,JobCardID) VALUES (?,?,?,?)";
	    } else {
	      sql = "UPDATE JobPhotographer SET NameCardID=?,Directory=?,Prefix=? WHERE JobPhotographerID=?";
	    }
 	    con = DbUtil.getConnection();
 	    PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setLong(1,jp.getNameCardID());
      ps.setString(2,jp.getDirectory());
      ps.setString(3,jp.getFormat());
      if (jp.getJobPhotographerID()!=0) {
        ps.setLong(4,jp.getJobPhotographerID());
      } else {
          ps.setLong(4,jp.getJobCardID());
      }
      ps.executeUpdate();
      if (jp.getJobPhotographerID()==0) {
        long JobPhotographerID = DbUtil.getGeneratedKey(ps);
        jp.setJobPhotographerID(JobPhotographerID);
      }
      ps.close();
      result = true;
    } catch (Exception e) {
	    logger.warn("saveJobPhotographer() Could not update: "+e.getMessage());
	    result = false;
	  } finally {
		  DbUtil.freeConnection(con);
	  }
    return result;
  }
  
  public void deleteJobPhotographer (JobPhotographer jp) {
	  Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "DELETE FROM JobPhotographer WHERE JobPhotographerID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,jp.getJobPhotographerID());
      ps.executeUpdate();
      ps.close();
	  } catch (Exception e) {
	    e.printStackTrace();
    } finally {
      DbUtil.freeConnection(con);
    }
  }
  
  public JobPhotographer[] getJobPhotographerList(long JobCardID) {
    Vector<JobPhotographer> result = new Vector<JobPhotographer>();
    Connection con = null;
 	  try {
      String sql = "SELECT JobPhotographerID, JobCardID, JP.NameCardID,Directory,Prefix,N.LastName,N.FirstName,N.MiddleName,N.FirstName,N.CompanyName FROM JobPhotographer JP, NameCard N WHERE JP.NameCardID = N.NameCardID AND JP.JobCardID = ? ORDER BY N.LastName";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,JobCardID);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createJobPhotographer(rs));
      }
      ps.close();
    } catch (Exception e) {
 	  logger.warn("getJobPhotographerList() Could not update: "+e.getMessage());
 	} finally {
 		DbUtil.freeConnection(con);
 	}
    return (JobPhotographer[])result.toArray(new JobPhotographer[result.size()]);
  }
  
  public String getHTMLJobPhotographerList(long JobCardID) {
    StringBuffer result = new StringBuffer(100);
    JobPhotographer[] ncl = getJobPhotographerList(JobCardID);
    result.append("<option value=\"0\">-select-</option>");
    for (int i=0;i<ncl.length;i++) {
      result.append("<option value=\"" + ncl[i].getNameCardID() + "\">" + ncl[i].getPhotographerName() + "</option>");
    }
    return result.toString();
  }

  public boolean duplicateCheck(JobPhotographer jp) {
    boolean result = false;
    Connection con = null;
    try {
      String sql = "SELECT * FROM JobPhotographer WHERE JobCardID=? AND Directory=? AND JobPhotographerID<>?";
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,jp.getJobCardID());
      ps.setString(2,jp.getDirectory());
      ps.setLong(3,jp.getJobPhotographerID());
      ResultSet rs = ps.executeQuery();
      result = (rs.next());
      ps.close();
    } catch (Exception e) {
      logger.warn("duplicateCheck() Could not update: "+e.getMessage());
      e.printStackTrace();
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
      
  public boolean changeNameCardID(long fromNameCardID, long toNameCardID) {
    boolean result = false;
    Connection con = null;
    try {
      String sql = "UPDATE JobPhotographer SET NameCardID=? WHERE NameCardID=?";
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,toNameCardID);
      ps.setLong(2,fromNameCardID);
      ps.executeUpdate();
      ps.close();
      result = true;
    } catch (Exception e) {
      logger.warn("changeNameCardID() Could not update: from="+fromNameCardID+" to="+toNameCardID+ " error="+e.getMessage());
      e.printStackTrace();
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
      
  private JobPhotographer createJobPhotographer(ResultSet rs) {
    JobPhotographer result = new JobPhotographer();
    try {
  	  result.setJobPhotographerID(rs.getLong("JobPhotographerID"));
      result.setJobCardID(rs.getLong("JobCardID"));
      result.setNameCardID(rs.getLong("NameCardID"));
      result.setPhotographerName(rs.getString("LastName") + ", " + rs.getString("FirstName"));
      result.setDirectory(rs.getString("Directory"));
      result.setFormat(rs.getString("Prefix"));
      result.setPhotographerInitials(makeInitials(rs.getString("FirstName"),rs.getString("LastName"),rs.getString("CompanyName")));
    } catch (Exception e) {
   	  logger.warn("createJobPhotographerList() Could not update: "+e.getMessage());
    }
    return result;
  }
  
  private String makeInitials(String firstName, String lastName, String companyName) {
  	String result = "";
  	firstName = (firstName!=null?firstName.trim():"");
  	lastName = (lastName!=null?lastName.trim():"");
  	companyName = (companyName!=null?companyName.trim():"");
  	if (firstName.length()==0 && lastName.length()==0 && companyName.length()==0) {
  		result = "XX";
  	} else if (firstName.length()==0 && lastName.length()==0) {
  		result = companyName.substring(0,(companyName.length()>2?2:companyName.length()));
  	} else if (firstName.length()==0) {
  		result = lastName.substring(0,(lastName.length()>2?2:lastName.length()));
  	} else if (lastName.length()==0) {
  		result = firstName.substring(0,(firstName.length()>2?2:firstName.length()));
  	} else {
  		result = firstName.substring(0,1)+lastName.substring(0,1);
  	}
  	return result;
  }


}
