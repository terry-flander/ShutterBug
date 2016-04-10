package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;
import java.io.File;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import javax.servlet.http.HttpServletResponse;

import au.com.fundfoto.shutterbug.util.DbUtil;
import org.apache.log4j.*;

public class ReportResultsService {
	  
  static Logger logger = Logger.getLogger("ReportResultsService");

  public ReportResultsService() {
  }
  
  public ReportResults getReportResults (long ResultsID) {
	  ReportResults result = new ReportResults();
	  Connection con = null;
	  if (ResultsID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT ReportID,ResultsID, Parameters, FileName, RunByID, RunTime, " +
        "concat(concat(N.LastName,', '),N.FirstName) AS RUN_BY_NAME " + 
        "FROM ReportResults " +
        "LEFT OUTER JOIN NameCard N ON N.NameCardID = RunById " +
        "WHERE ResultsID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,ResultsID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
      	  result = createReportResults(rs);
        }
        rs.close();
        ps.close();
	    } catch (Exception e) {
	      logger.error("getReportResults",e);
	    } finally {
        DbUtil.freeConnection(con);
      }
    }
    return result;
  }
  
  public boolean saveReportResults(ReportResults jp) {
    boolean result = false;
    Connection con = null;
	  try {
      String sql = null;
 	    if (jp.getResultsID()==0) {
	      sql = "INSERT INTO ReportResults (Parameters,FileName,RunByID,RunTime,ReportID) VALUES (?,?,?,?,?)";
	    } else {
	      sql = "UPDATE ReportResults SET Parameters=?,FileName=?,RunByID=?,RunTime=? WHERE ResultsID=?";
	    }
 	    con = DbUtil.getConnection();
 	    PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setString(1,jp.getParameters());
      ps.setString(2,jp.getFileName());
      ps.setLong(3,jp.getlRunByID());
      ps.setTimestamp(4,jp.getdRunTime());
      if (jp.getResultsID()!=0) {
        ps.setLong(5,jp.getResultsID());
      } else {
        ps.setLong(5,jp.getReportID());
      }
      ps.executeUpdate();
      if (jp.getResultsID()==0) {
        long ResultsID = DbUtil.getGeneratedKey(ps);
        jp.setResultsID(ResultsID);
      }
      ps.close();
      result = true;
    } catch (Exception e) {
	    logger.warn("saveReportResults() Could not update: "+e.getMessage());
	    result = false;
	  } finally {
		  DbUtil.freeConnection(con);
	  }
    return result;
  }
  
  public void deleteReportResults (ReportResults jp) {
	  Connection con = null;
	  boolean ok = false;
    try {
      con = DbUtil.getConnection();
      String sql = "DELETE FROM ReportResults WHERE ResultsID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,jp.getResultsID());
      ps.executeUpdate();
      ps.close();
      ok = true;
	  } catch (Exception e) {
	    logger.error("deleteReportResults",e);
    } finally {
      DbUtil.freeConnection(con);
    }
    // If no errors, try to get rid of PDF
    if (ok) {
    	try {
    	} catch (Exception e) {
    		logger.warn("deleteReportResults() Could not delete PDF."+e.getMessage());
    	}
    }
  }
  
  public ReportResults[] getReportResultsList(long ReportID) {
    Vector<ReportResults> result = new Vector<ReportResults>();
    Connection con = null;
 	  try {
      String sql = "SELECT ReportID,ResultsID,Parameters,FileName,RunByID,RunTime, " +
        "concat(concat(N.LastName,', '),N.FirstName) AS RUN_BY_NAME " + 
        "FROM ReportResults " +
        "LEFT OUTER JOIN NameCard N ON N.NameCardID = RunById " +
 	      "WHERE ReportID = ? ORDER BY RunTime DESC";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,ReportID);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createReportResults(rs));
      }
      ps.close();
    } catch (Exception e) {
 	    logger.warn("getReportResultsList() Could not update: "+e.getMessage());
 	  } finally {
 	  	DbUtil.freeConnection(con);
 	  }
    return (ReportResults[])result.toArray(new ReportResults[result.size()]);
  }
  
  private ReportResults createReportResults(ResultSet rs) {
    ReportResults result = new ReportResults();
    try {
  	  result.setResultsID(rs.getLong("ResultsID"));
      result.setReportID(rs.getLong("ReportID"));
      result.setParameters(rs.getString("Parameters"));
      result.setFileName(rs.getString("FileName"));
      result.setlRunByID(rs.getLong("RunByID"));
      result.setdRunTime(rs.getTimestamp("RunTime"));
      result.setRunByName(rs.getString("RUN_BY_NAME"));
    } catch (Exception e) {
   	  logger.warn("createReportResults() Could not update: "+e.getMessage());
    }
    return result;
  }
  
  public static void writePdf(String fileName, String reportTitle, HttpServletResponse res) {
    try {
      res.setHeader("Content-disposition", "attachment; filename=" + reportTitle+".pdf");
      res.setContentType("application/pdf");
      BufferedInputStream bis = null;
      BufferedOutputStream bos = null;
      try {
        File f = new File(fileName);
        FileInputStream in = new FileInputStream(f);
        bis = new BufferedInputStream(in);
        bos = new BufferedOutputStream(res.getOutputStream());
        byte[] b = new byte[16384];
        int bytesRead;
        while((bytesRead=bis.read(b)) != -1) {
          bos.write(b,0,bytesRead);
        }
      } catch (Exception e) {
        logger.warn("writeFile() Error: "+e.getMessage()+" fullFile="+fileName);
      } finally {
        if( bis != null ) {
          bis.close();
        }
        if( bos != null ) {
          bos.close();
        }
      }
    } catch(Exception e) {
      logger.warn("ReportResults-g.jsp Error: "+e.getMessage()+" fullFile="+fileName);
    }
  }
  
  public void clearOld(long ReportID) {
  	ReportResults[] rr = getReportResultsList(ReportID);
  	int maxFiles = 10;
  	try {
  		maxFiles = Integer.parseInt(OptionService.getOptionValue("Setup","MaxReportsToKeep"));
  	} catch (Exception e) {
  		// Didn't work; not to worry;
  		logger.warn("clearOld() System Parameter: Setup: MaxReportsToKeep -- Value not integer");
  	}
  	for (int i=rr.length - 1;i>=0 && i>maxFiles;i--) {
  		deleteReportResults(rr[i]);
  	}
  }
}
