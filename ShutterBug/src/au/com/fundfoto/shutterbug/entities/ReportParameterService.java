package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;
import org.apache.log4j.*;

import au.com.fundfoto.shutterbug.util.DbUtil;

public class ReportParameterService {
	  
  static Logger logger = Logger.getLogger("ReportParameterService");

  public ReportParameterService() {
  }
  
  public ReportParameter getReportParameter (long ParameterID) {
	  ReportParameter result = new ReportParameter();
	  Connection con = null;
	  if (ParameterID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT ReportID, ParameterID, `order`, Code, Description, DataType, Validation FROM ReportParameter WHERE ParameterID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,ParameterID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
      	  result = createReportParameter(rs);
        }
        rs.close();
        ps.close();
	    } catch (Exception e) {
	      logger.error("getReportParameter",e);
	    } finally {
        DbUtil.freeConnection(con);
      }
    }
    return result;
  }
  
  public boolean saveReportParameter(ReportParameter jp) {
    boolean result = false;
    Connection con = null;
	  try {
      String sql = null;
 	    if (jp.getParameterID()==0) {
	      sql = "INSERT INTO ReportParameter (`order`, Code, Description,DataType,Validation,ReportID) VALUES (?,?,?,?,?,?)";
	    } else {
	      sql = "UPDATE ReportParameter SET `order`=?,Code=?,Description=?,DataType=?,Validation=? WHERE ParameterID=?";
	    }
 	    con = DbUtil.getConnection();
 	    PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setInt(1,jp.getiOrder());
      ps.setString(2,jp.getCode());
      ps.setString(3,jp.getDescription());
      ps.setString(4,jp.getDataType());
      ps.setString(5,jp.getValidation());
      if (jp.getParameterID()!=0) {
        ps.setLong(6,jp.getParameterID());
      } else {
        ps.setLong(6,jp.getReportID());
      }
      ps.executeUpdate();
      if (jp.getParameterID()==0) {
        long ParameterID = DbUtil.getGeneratedKey(ps);
        jp.setParameterID(ParameterID);
      }
      ps.close();
      result = true;
    } catch (Exception e) {
	    logger.warn("saveReportParameter() Could not update: "+e.getMessage());
	    result = false;
	  } finally {
		  DbUtil.freeConnection(con);
	  }
    return result;
  }
  
  public void deleteReportParameter (ReportParameter jp) {
	  Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "DELETE FROM ReportParameter WHERE ParameterID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,jp.getParameterID());
      ps.executeUpdate();
      ps.close();
	  } catch (Exception e) {
	    logger.error("deleteReportParameter",e);
    } finally {
      DbUtil.freeConnection(con);
    }
  }
  
  public ReportParameter[] getReportParameterList(long ReportID) {
    Vector<ReportParameter> result = new Vector<ReportParameter>();
    Connection con = null;
 	  try {
      String sql = "SELECT ReportID,ParameterID,`order`,Code,Description,DataType,Validation FROM ReportParameter WHERE ReportID = ? ORDER BY Description";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,ReportID);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createReportParameter(rs));
      }
      ps.close();
    } catch (Exception e) {
 	    logger.warn("getReportParameterList() Could not update: "+e.getMessage());
 	  } finally {
 	  	DbUtil.freeConnection(con);
 	  }
    return (ReportParameter[])result.toArray(new ReportParameter[result.size()]);
  }
  
  private ReportParameter createReportParameter(ResultSet rs) {
    ReportParameter result = new ReportParameter();
    try {
  	  result.setParameterID(rs.getLong("ParameterID"));
      result.setReportID(rs.getLong("ReportID"));
      result.setiOrder(rs.getInt("order"));
      result.setCode(rs.getString("Code"));
      result.setDescription(rs.getString("Description"));
      result.setDataType(rs.getString("DataType"));
      result.setValidation(rs.getString("Validation"));
    } catch (Exception e) {
   	  logger.warn("createReportParameter() Could not update: "+e.getMessage());
    }
    return result;
  }


}
