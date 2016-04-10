package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;
import au.com.fundfoto.shutterbug.util.DbUtil;
import org.apache.log4j.*;

public class ReportService {
	  
  static Logger logger = Logger.getLogger("ReportService");

  public ReportService() {
  }
  
  public Report getReport (long ReportID) {
    Report result = new Report();
    Connection con = null;
    if (ReportID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT * FROM Report WHERE ReportID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,ReportID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
      	  result = createReport(rs);
        }
        rs.close();
        ps.close();
	    } catch (Exception e) {
	      logger.error("getReport()",e);
      } finally {
        DbUtil.freeConnection(con);
      }
    }
    return result;
  }
  
  public boolean saveReport(Report rp) {
    boolean result = false;
    Connection con = null;
	  try {
      String sql = null;
 	    if (rp.getReportID()==0) {
	      sql = "INSERT INTO Report (Description,Title,JasperFile,Comments) VALUES (?,?,?,?)";
	    } else {
	      sql = "UPDATE Report SET Description=?,Title=?,JasperFile=?,Comments=? WHERE ReportID=?";
	    }
 	    con = DbUtil.getConnection();
 	    PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setString(1,rp.getDescription());
      ps.setString(2,rp.getTitle());
      ps.setString(3,rp.getJasperFile());
      ps.setString(4,rp.getComments());
      if (rp.getReportID()!=0) {
        ps.setLong(5,rp.getReportID());
      }
      ps.executeUpdate();
      if (rp.getReportID()==0) {
        long ReportID = DbUtil.getGeneratedKey(ps);
        rp.setReportID(ReportID);
      }
      ps.close();
      result = true;
	  } catch (Exception e) {
	    logger.warn("saveReport() Could not update: "+e.getMessage());
	    result = false;
	  } finally {
		  DbUtil.freeConnection(con);
    }
    return result;
  }
  
  public Report[] getReportList() {
    Vector<Report> result = new Vector<Report>();
    Connection con = null;
 	  try {
      String sql = "SELECT ReportID,Description,Title,JasperFile,Comments FROM Report ORDER BY Title";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
    	  Report rp = new Report();
    	  rp.setReportID(rs.getLong("ReportID"));
        rp.setDescription(rs.getString("Description"));
        rp.setTitle(rs.getString("Title"));
        rp.setJasperFile(rs.getString("JasperFile"));
        rp.setComments(rs.getString("Comments"));
        result.add(rp);
      }
      ps.close();
    } catch (Exception e) {
 	    logger.warn("getReportList() Could not update: "+e.getMessage());
 	  } finally {
 		  DbUtil.freeConnection(con);
 	  }
    return (Report[])result.toArray(new Report[result.size()]);
  }

  private Report createReport(ResultSet rs) {
    Report result = new Report();
    try {
	    result.setReportID(rs.getLong("ReportID"));
      result.setDescription(rs.getString("Description"));
      result.setTitle(rs.getString("Title"));
      result.setJasperFile(rs.getString("JasperFile"));
      result.setComments(rs.getString("Comments"));
    } catch (Exception e) {
   	  logger.warn("createReport() Could not create: "+e.getMessage());
    }
    return result;
  }
  
}