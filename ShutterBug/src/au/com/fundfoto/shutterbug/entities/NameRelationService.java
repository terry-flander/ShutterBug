package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;

import au.com.fundfoto.shutterbug.util.DbUtil;
import org.apache.log4j.*;

public class NameRelationService {
	  
  static Logger logger = Logger.getLogger("NameRelationService");

  public NameRelationService() {
  }
  
  public NameRelation getNameRelation (long RelationID) {
	NameRelation result = new NameRelation();
	Connection con = null;
	if (RelationID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT RelationID, ParentType, ParentID, ChildID, RelationType, concat(concat(LastName,', '),FirstName) AS DESCRIPTION FROM NameRelation, NameCard WHERE RelationID=? AND NameCardID = ChildID";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,RelationID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
      	  result = createNameRelation(rs);
        }
        rs.close();
        ps.close();
	  } catch (Exception e) {
	    logger.error("getNameRelation()",e);
    } finally {
      DbUtil.freeConnection(con);
    }
	}
    return result;
  }
  
  public boolean saveNameRelation(NameRelation nr) {
    boolean result = false;
    Connection con = null;
    // Prevent INSERT of duplicate relation. May be attempted by automatic link creation.
    if (nr.getRelationID()==0) {
      result = duplicateCheck(nr);
    }
    if (!result) {
      try {
        String sql = null;
        if (nr.getRelationID()==0) {
  	      sql = "INSERT INTO NameRelation (ParentType, ParentID, ChildID, RelationType) VALUES (?,?,?,?)";
        } else {
  	      sql = "UPDATE NameRelation SET ParentType, ParentID=?,ChildID=?,RelationType=? WHERE RelationID=?";
  	    }
   	    con = DbUtil.getConnection();
   	    PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1,nr.getParentType());
        ps.setLong(2,nr.getlParentID());
        ps.setLong(3,nr.getlChildID());
        ps.setString(4,nr.getRelationType());
        if (nr.getRelationID()!=0) {
          ps.setLong(5,nr.getRelationID());
        }
        ps.executeUpdate();
        if (nr.getRelationID()==0) {
          long RelationID = DbUtil.getGeneratedKey(ps);
          nr.setRelationID(RelationID);
        }
        ps.close();
        result = true;
      } catch (Exception e) {
        logger.warn("saveNameRelation() Could not update: "+e.getMessage());
        result = false;
      } finally {
        DbUtil.freeConnection(con);
      }
    }
    return result;
  }
  
  public void deleteNameRelation (NameRelation nr) {
	Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "DELETE FROM NameRelation WHERE RelationID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,nr.getRelationID());
      ps.executeUpdate();
      ps.close();
    } catch (Exception e) {
      logger.error("deleteNameRelation()",e);
    } finally {
      DbUtil.freeConnection(con);
    }
  }
  
  public NameRelation[] getNameRelationList(int ParentType, long ParentID) {
    Vector<NameRelation> result = new Vector<NameRelation>();
    Connection con = null;
    try {
      String sql = "SELECT RelationID, ParentType, ParentID, ChildID, RelationType, concat(concat(LastName,', '),FirstName) AS DESCRIPTION FROM NameRelation, NameCard WHERE ParentType=? AND ParentID=? AND ChildID = NameCardID ORDER BY LastName, FirstName";
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setInt(1,ParentType);
      ps.setLong(2,ParentID);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createNameRelation(rs));
      }
      ps.close();
    } catch (Exception e) {
      logger.warn("getNameRelationList() ParentID="+ParentID+" Could not update: "+e.getMessage());
    } finally {
      DbUtil.freeConnection(con);
    }
    return (NameRelation[])result.toArray(new NameRelation[result.size()]);
  }
  
  public NameRelation[] getChildRelationList(int ParentType, long ChildID) {
    Vector<NameRelation> result = new Vector<NameRelation>();
    Connection con = null;
    try {
      String sql = null;
      if (ParentType==NameRelation.JOB_TYPE) {
        sql = "SELECT RelationID, ParentType, ParentID, ChildID, RelationType, concat(concat(Code,': '),Name) AS DESCRIPTION FROM NameRelation, JobCard WHERE ParentType=1 AND ChildID=? AND ParentID = JobCardID ORDER BY Code";
      } else if (ParentType==NameRelation.SESSION_TYPE) {
        sql = "SELECT RelationID, ParentType, ParentID, ChildID, RelationType, concat(concat(Code,': '),Name) AS DESCRIPTION  FROM NameRelation, Session WHERE ParentType=2 AND ChildID=? AND ParentID = SessionID ORDER BY Code";
      } else if (ParentType==NameRelation.SUBJECT_TYPE) {
      	sql = "SELECT RelationID, ParentType, ParentID, ChildID, RelationType, concat(concat(SubjectCode,': '),concat(concat(N.LastName,', '),N.FirstName)) AS DESCRIPTION FROM NameRelation, Subject S, NameCard N " +
      			  "WHERE ParentType=3 AND ChildID=? AND ParentID = SubjectID AND N.NameCardID = S.NameCardID ORDER BY SubjectCode";
      } else if (ParentType==NameRelation.ORDER_TYPE) {
        sql = "SELECT RelationID, ParentType, ParentID, ChildID, RelationType, concat(concat(OrderNumber,': '),DATE_FORMAT(OrderDate,'%d/%m/%Y')) AS DESCRIPTION  FROM NameRelation, OrderCard WHERE ParentType=4 AND ChildID=? AND ParentID = OrderID ORDER BY OrderNumber";
      }
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,ChildID);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createNameRelation(rs));
      }
      ps.close();
    } catch (Exception e) {
      logger.warn("getNameRelationList() ParentType="+ParentType+" ChildID="+ChildID+" Could not update: "+e.getMessage());
    } finally {
      DbUtil.freeConnection(con);
    }
    return (NameRelation[])result.toArray(new NameRelation[result.size()]);
  } 
  
  public boolean duplicateCheck(NameRelation nr) {
    boolean result = false;
    Connection con = null;
 	  try {
      String sql = "SELECT * FROM NameRelation WHERE ParentType=? AND ParentID=? AND ChildID=? AND RelationType=? AND RelationID<>?";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ps.setInt(1,nr.getParentType());
      ps.setLong(2,nr.getlParentID());
  	  ps.setLong(3,nr.getlChildID());
  	  ps.setString(4,nr.getRelationType());
  	  ps.setLong(5,nr.getRelationID());
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
	  
  public boolean changeNameCardID(long fromNameCardID, long toNameCardID) {
    boolean result = false;
    Connection con = null;
    try {
      String sql = "UPDATE NameRelation SET ChildID=? WHERE ChildID=?";
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,toNameCardID);
      ps.setLong(2,fromNameCardID);
      ps.executeUpdate();

      // Now change ParentID if ParentType = NameRelation.NAME_TYPE
      sql = "UPDATE NameRelation SET ParentID=? WHERE ParentType=? AND ParentID=?";
      ps = con.prepareStatement(sql);
      ps.setLong(1,toNameCardID);
      ps.setLong(2,NameRelation.NAME_TYPE);
      ps.setLong(3,fromNameCardID);
      ps.executeUpdate();
      
      ps.close();
      result = true;
    } catch (Exception e) {
      logger.warn("changeNameCardID() Could not update: from="+fromNameCardID+" to="+toNameCardID+ " error="+e.getMessage());
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }

  private NameRelation createNameRelation(ResultSet rs) {
    NameRelation result = new NameRelation();
    try {
      result.setRelationID(rs.getLong("RelationID"));
      result.setParentType(rs.getInt("ParentType"));
      result.setlParentID(rs.getLong("ParentID"));
      result.setlChildID(rs.getLong("ChildID"));
      result.setRelationType(rs.getString("RelationType"));
      result.setChildName(rs.getString("DESCRIPTION"));
    } catch (Exception e) {
      logger.warn("createNameRelation() Unable to create NameRelation");
    }
    return result;
  }


}
