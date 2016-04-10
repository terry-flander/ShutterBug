package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;

import au.com.fundfoto.shutterbug.util.DbUtil;
import org.apache.log4j.*;

public class SubjectService {
	  
  static Logger logger = Logger.getLogger("SubjectService");

  public SubjectService() {
  }
  
  public Subject getSubject (long SubjectID) {
    Subject result = new Subject();
    Connection con = null;
	  if (SubjectID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT S.SubjectID,SessionID,SubjectCode,S.NameCardID,S.FirstName,S.LastName,PhotographerID,FirstShot,LastShot, MountShotID, ShotName, " + 
	 	        "concat(concat(N.LastName,', '),N.FirstName) AS FIRST_SUBJECT, " + 
	 	        "concat(concat(P.FirstName,' '),P.LastName) AS PHOTOGRAPHER, " + 
      		  "concat(concat(C.FirstName,' '),C.LastName) AS CONTACT_NAME, " + 
	 	        "C.Mobile AS CONTACT_NUMBER, Status, Note FROM Subject S " +
          "LEFT OUTER JOIN NameRelation SR ON SR.ParentType = ? AND SR.ParentID = S.SubjectID AND SR.RelationType = ? " +
          "LEFT OUTER JOIN NameCard N ON SR.ChildID = N.NameCardID " +
          "LEFT OUTER JOIN NameRelation NR ON NR.ParentType = ? AND NR.ParentID = S.SubjectID AND NR.RelationType = ? " +
          "LEFT OUTER JOIN NameCard C ON NR.ChildID = C.NameCardID " +
          "LEFT OUTER JOIN NameCard P ON S.PhotographerID = P.NameCardID " +
          "LEFT OUTER JOIN Shot SH ON SH.ShotID = S.MountShotID " +
                "WHERE S.SubjectID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,NameRelation.SUBJECT_TYPE);
        ps.setString(2,OptionService.getOptionValue("Setup","SubjectRelationType"));
        ps.setLong(3,NameRelation.SUBJECT_TYPE);
        ps.setString(4,OptionService.getOptionValue("Setup","ContactRelationType"));
        ps.setLong(5,SubjectID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
        	result = createSubject(rs);
        }
        rs.close();
        ps.close();
	    } catch (Exception e) {
	      logger.error("getSubject()",e);
      } finally {
        DbUtil.freeConnection(con);
      }
	  }
    return result;
  }
  
  public boolean saveSubject(Subject sc) {
    boolean result = false;
    Connection con = null;
    try {
    	long oldNameCardID = 0;
      // Create and/or Update NameCard
  	  String sql = null;
   	  if (sc.getSubjectID()==0) {
  	    sql = "INSERT INTO Subject (SubjectCode,NameCardID,PhotographerID,FirstShot,LastShot,MountShotID,Status,Note,SessionID) VALUES (?,?,?,?,?,?,?,?,?)";
  	  } else {
  	    sql = "UPDATE Subject SET SubjectCode=?,NameCardID=?,PhotographerID=?,FirstShot=?,LastShot=?,MountShotID=?,Status=?,Note=? WHERE SubjectID=?";
  	    oldNameCardID = getSubject(sc.getSubjectID()).getNameCardID();

  	  }
   	  con = DbUtil.getConnection();
   	  PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
   	  ps.setString(1,sc.getSubjectCode());
   	  ps.setLong(2,sc.getNameCardID());
      ps.setLong(3,sc.getPhotographerID());
   	  ps.setLong(4,sc.getiFirstShot());
      ps.setLong(5,sc.getiLastShot());
      ps.setLong(6,sc.getlMountShotID());
      ps.setString(7,sc.getStatus());
      ps.setString(8,sc.getNote());
      if (sc.getSubjectID()!=0) {
        ps.setLong(9,sc.getSubjectID());
      } else {
     	  ps.setLong(9,sc.getSessionID());
      }
      ps.executeUpdate();
      if (sc.getSubjectID()==0) {
        long SubjectID = DbUtil.getGeneratedKey(ps);
        sc.setSubjectID(SubjectID);
      }
      ps.close();
      // Remove original 'Subject' name relation links for this Subject
      if (oldNameCardID!=0) {
	      sql = "DELETE FROM NameRelation WHERE ParentType=? AND ParentID=? AND ChildID=? AND RelationType=?";
     	  ps = con.prepareStatement(sql);
   	    ps.setLong(1,NameRelation.SUBJECT_TYPE);
   	    ps.setLong(2,sc.getSubjectID());
   	    ps.setLong(3,oldNameCardID);
   	    ps.setString(4,OptionService.getOptionValue("Setup","SubjectRelationType"));
   	    ps.executeUpdate();
      }
      result = true;
	  } catch (Exception e) {
	    logger.warn("saveSubject() Could not update: "+e.getMessage());
	    result = false;
	  } finally {
		  DbUtil.freeConnection(con);
	  }
    // Add Name Relation link
    if (result) {
      NameRelationService nrs = new NameRelationService();
      NameRelation nr = nrs.getNameRelation(0);
      nr.setParentType(NameRelation.SUBJECT_TYPE);
      nr.setlParentID(sc.getSubjectID());
      nr.setlChildID(sc.getNameCardID());
      nr.setRelationType(OptionService.getOptionValue("Setup","SubjectRelationType"));
      nrs.saveNameRelation(nr);
    }
    return result;
  }
  
  public Subject[] getSubjectList(long SessionID) {
    Vector<Subject> result = new Vector<Subject>();
    Connection con = null;
	 	try {
      String sql = "SELECT S.SubjectID,SessionID,SubjectCode,S.NameCardID,S.FirstName,S.LastName,PhotographerID,FirstShot,LastShot,MountShotID,ShotName, " + 
	 	        "concat(concat(N.LastName,', '),N.FirstName) AS FIRST_SUBJECT, " + 
	 	        "concat(concat(P.FirstName,' '),P.LastName) AS PHOTOGRAPHER, " + 
      		  "concat(concat(C.FirstName,' '),C.LastName) AS CONTACT_NAME, " + 
	 	        "C.Mobile AS CONTACT_NUMBER, Status, Note FROM Subject S " +
          "LEFT OUTER JOIN NameRelation SR ON SR.ParentType = ? AND SR.ParentID = S.SubjectID AND SR.RelationType = ? " +
          "LEFT OUTER JOIN NameCard N ON SR.ChildID = N.NameCardID " +
          "LEFT OUTER JOIN NameRelation NR ON NR.ParentType = ? AND NR.ParentID = S.SubjectID AND NR.RelationType = ? " +
          "LEFT OUTER JOIN NameCard C ON NR.ChildID = C.NameCardID " +
          "LEFT OUTER JOIN NameCard P ON S.PhotographerID = P.NameCardID " +
          "LEFT OUTER JOIN Shot SH ON SH.ShotID = S.MountShotID " +
              "WHERE S.SessionID=? ORDER BY N.LastName, N.FirstName, S.SubjectCode";
	 	  con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,NameRelation.SUBJECT_TYPE);
      ps.setString(2,OptionService.getOptionValue("Setup","SubjectRelationType"));
      ps.setLong(3,NameRelation.SUBJECT_TYPE);
      ps.setString(4,OptionService.getOptionValue("Setup","ContactRelationType"));
      ps.setLong(5,SessionID);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createSubject(rs));
      }
      ps.close();
    } catch (Exception e) {
	 	  logger.warn("getSubjectList() Could not update: "+e.getMessage());
	 	} finally {
	 		DbUtil.freeConnection(con);
	 	}
    return (Subject[])result.toArray(new Subject[result.size()]);
  }
	  
  public Subject[] getSubjectList(String subjectFilter) {
    Vector<Subject> result = new Vector<Subject>();
    Connection con = null;
	 	try {
      String sql = "SELECT S.SubjectID,SessionID,SubjectCode,S.NameCardID,S.FirstName,S.LastName,PhotographerID,FirstShot,LastShot,MountShotID,ShotName, " + 
	 	        "concat(concat(N.LastName,' '),N.FirstName) AS FIRST_SUBJECT, " + 
	 	        "concat(concat(P.FirstName,' '),P.LastName) AS PHOTOGRAPHER, " + 
      		  "concat(concat(C.FirstName,' '),C.LastName) AS CONTACT_NAME, " + 
	 	        "C.Mobile AS CONTACT_NUMBER, Status, Note FROM Subject S " +
          "LEFT OUTER JOIN NameRelation SR ON SR.ParentType = ? AND SR.ParentID = S.SubjectID AND SR.RelationType = ? " +
          "LEFT OUTER JOIN NameCard N ON SR.ChildID = N.NameCardID " +
          "LEFT OUTER JOIN NameRelation NR ON NR.ParentType = ? AND NR.ParentID = S.SubjectID AND NR.RelationType = ? " +
          "LEFT OUTER JOIN NameCard C ON NR.ChildID = C.NameCardID " +
          "LEFT OUTER JOIN NameCard P ON S.PhotographerID = P.NameCardID " +
          "LEFT OUTER JOIN Shot SH ON SH.ShotID = S.MountShotID " +
            "WHERE (SubjectCode LIKE ? OR N.LastName LIKE ? OR N.FirstName LIKE ?) ORDER BY SubjectCode";
      if (subjectFilter.length()>0 && subjectFilter.indexOf("%")==-1) {
      	subjectFilter += "%";
      }
	 	  con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,NameRelation.SUBJECT_TYPE);
      ps.setString(2,OptionService.getOptionValue("Setup","SubjectRelationType"));
      ps.setLong(3,NameRelation.SUBJECT_TYPE);
      ps.setString(4,OptionService.getOptionValue("Setup","ContactRelationType"));
      ps.setString(5,subjectFilter);
      ps.setString(6,subjectFilter);
      ps.setString(7,subjectFilter);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createSubject(rs));
      }
      ps.close();
    } catch (Exception e) {
	 	  logger.warn("getSubjectList() Could not update: "+e.getMessage());
	 	} finally {
	 		DbUtil.freeConnection(con);
	 	}
    return (Subject[])result.toArray(new Subject[result.size()]);
  }
	  
  public String setSubjectCode(long SessionID) {
    String result = null;
    Connection con = null;
   	try {
      con = DbUtil.getConnection();
      // Check for valid setup first
      String sql = "SELECT JC.Code, SE.Code FROM JobCard JC, Session SE " +
        "WHERE SE.SessionID=? " +
        "  AND JC.JobCardID = SE.JobCardID";
    	PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,SessionID);
      ResultSet rs = ps.executeQuery();
      String jobCode = null;
      String sessionCode = null;
      if (rs.next()) {
        jobCode = rs.getString(1);
        sessionCode = rs.getString(2);
      }
      
      if (jobCode!=null && jobCode.length()==2 && sessionCode!=null && sessionCode.length()==2) {
	      String subjectCode = null;
	      int lastSubjectNo = 0;
	   	  // Look for last existing SubjectCode. If there is one, all new Subjects must start from this number
	      sql = "SELECT SubjectCode FROM Subject SU " +
	          "WHERE SU.SessionID=? " +
	          "  AND EXISTS (SELECT * FROM Shot SH WHERE SH.SubjectID = SU.SubjectID) " +
	          "ORDER BY SubjectCode DESC LIMIT 1";
	      ps = con.prepareStatement(sql);
	      ps.setLong(1,SessionID);
	      rs = ps.executeQuery();
	      if (rs.next()) {
	        subjectCode = rs.getString("SubjectCode");
	        if (subjectCode.length()>4) {
		        try {
		          lastSubjectNo = Integer.parseInt(subjectCode.substring(4));
		          subjectCode = subjectCode.substring(0,4);
		        } catch (Exception ee) {
		        	// Some numbering problem from before
		        }
	        } else {
	        	subjectCode = null;
	        }
	      }
	      // If no shots exist on any Subjects, start from 0
	      if (subjectCode==null) {
         subjectCode = jobCode + sessionCode;
	      }
        sql = "SELECT SU.SubjectID FROM Subject SU " +
            "WHERE SU.SessionID=? " +
            "  AND NOT EXISTS (SELECT * FROM Shot SH WHERE SH.SubjectID = SU.SubjectID)";
        ps = con.prepareStatement(sql);
        ps.setLong(1,SessionID);
        rs = ps.executeQuery();
        Vector<Long> v = new Vector<Long>();
        while (rs.next()) {
          v.add(rs.getLong("SubjectID"));
        }
        rs.close();
        sql = "UPDATE Subject SET SubjectCode=? WHERE SubjectID = ?";
        ps = con.prepareStatement(sql);
        for (int i=0;i<v.size();i++) {
          lastSubjectNo++;
          ps.setString(1,subjectCode + (lastSubjectNo<10?"0":"") + lastSubjectNo);
          ps.setLong(2,v.get(i));
          ps.executeUpdate();
        }
        sql = "UPDATE Session SET LastSessionNo=? WHERE SessionID = ?";
        ps = con.prepareStatement(sql);
        ps.setInt(1,lastSubjectNo);
        ps.setLong(2,SessionID);
        ps.executeUpdate();
	      ps.close();
      } else {
      	result = "setSubjectCode() Could not set SubjectCode with JobCode="+jobCode+", SessionCode="+sessionCode;
      }
    } catch (Exception e) {
   	  logger.warn("setSubjectCode() Could not update: "+e.getMessage());
   	} finally {
   		DbUtil.freeConnection(con);
   	}
    return result;
  }
	  
  public void deleteSubject (Subject su) {
  	Connection con = null;
  	String errMsg = null;
  	boolean allowDelete = DbUtil.allowDelete("SubjectID",su.getSubjectID(), "OrderSubject");
  	if (allowDelete) {
	    try {
	      con = DbUtil.getConnection();
	      // Delete any Shots first
	      String sql = "DELETE FROM Shot WHERE SubjectID=?";
	      PreparedStatement ps = con.prepareStatement(sql);
	      ps.setLong(1,su.getSubjectID());
	      ps.executeUpdate();
	      // Delete Subject
	      sql = "DELETE FROM Subject WHERE SubjectID=?";
	      ps = con.prepareStatement(sql);
	      ps.setLong(1,su.getSubjectID());
	      ps.executeUpdate();
	      ps.close();
	    } catch (Exception e) {
	    	logger.error("deleteSubject()",e);
	    	su.addErrMsg("Unable to delete: "+errMsg + e.getMessage());
	    } finally {
	      DbUtil.freeConnection(con);
	    }
  	} else {
	    su.addErrMsg("Unable to delete: Related Order(s) exist");
  	}
  }
  
  public boolean changeNameCardID(long fromNameCardID, long toNameCardID) {
    boolean result = false;
    Connection con = null;
    try {
      NameCard nc = new NameCardService().getNameCard(toNameCardID);
      con = DbUtil.getConnection();
      String sql = "UPDATE Subject SET NameCardID=?,FirstName=?,LastName=? WHERE NameCardID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,toNameCardID);
      ps.setString(2,nc.getFirstName());
      ps.setString(3,nc.getLastName());
      ps.setLong(4,fromNameCardID);
      ps.executeUpdate();

      // Now change PhotographerID
      sql = "UPDATE Subject SET PhotographerID=? WHERE PhotographerID=?";
      ps = con.prepareStatement(sql);
      ps.setLong(1,toNameCardID);
      ps.setLong(2,fromNameCardID);
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
      
  private Subject createSubject(ResultSet rs) {
	  Subject result = new Subject();
 	  try {
	    result.setSubjectID(rs.getLong("SubjectID"));
	    result.setSessionID(rs.getLong("SessionID"));
      result.setSubjectCode(rs.getString("SubjectCode"));
	    result.setNameCardID(rs.getLong("NameCardID"));
      result.setFirstSubjectName(rs.getString("FIRST_SUBJECT"));
      result.setPhotographerID(rs.getLong("PhotographerID"));
      result.setiFirstShot(rs.getInt("FirstShot"));
      result.setiLastShot(rs.getInt("LastShot"));
      result.setlMountShotID(rs.getLong("MountShotID"));
      result.setShotName(rs.getString("ShotName"));
      result.setPhotographer(rs.getString("PHOTOGRAPHER"));
      result.setStatus(rs.getString("Status"));
      result.setNote(rs.getString("Note"));
      result.setContactName(rs.getString("CONTACT_NAME"));
      result.setContactNumber(rs.getString("CONTACT_NUMBER"));
 	  } catch (Exception e) {
      logger.warn("createSubject() Could not update: "+e.getMessage());
 	  }
 	  return result;
  }
  
  public String bulkLoad(long JobSessionID, Vector<LoadSubject> names) {
    StringBuffer result = new StringBuffer(); 
    long SubjectID = 0;

    for (int i=0;i<names.size();i++) {
      LoadSubject ls = names.get(i);
      Vector<LoadSubject.LoadName> subs = ls.getSubjects();
      for (int j=0;j<subs.size();j++) {
        LoadSubject.LoadName sub = subs.get(j);
        NameCard nc = new NameCardService().getNameCard(0);
        nc.setFirstName(sub.getFirstName());
        nc.setLastName(sub.getLastName());
        nc.setMobile(ls.getContactNumber());
        new NameCardService().saveNameCard(nc);
        if (j==0) {
          Subject su = new Subject();
          su.setSessionID(JobSessionID);
          su.setNameCardID(nc.getNameCardID());
          new SubjectService().saveSubject(su);
          if (su.hasErrors()) {
            result.append(su.getErrMsg()+"\n");
          }
          SubjectID = su.getSubjectID();
        }
        NameRelationService nrs = new NameRelationService();
        NameRelation nr = nrs.getNameRelation(0);
        nr.setParentType(NameRelation.SUBJECT_TYPE);
        nr.setlParentID(SubjectID);
        nr.setlChildID(nc.getNameCardID());
        nr.setRelationType(OptionService.getOptionValue("Setup","SubjectRelationType"));
        nrs.saveNameRelation(nr);
      }
      
      // Add Contact if one exists
      if (ls.getContactFirstName().length()>0) {
        NameCard nc = new NameCardService().getNameCard(0);
        nc.setFirstName(ls.getContactFirstName());
        nc.setLastName(ls.getContactLastName());
        nc.setMobile(ls.getContactNumber());
        new NameCardService().saveNameCard(nc);
        
        // Add contact relation to this Subject
        NameRelationService nrs = new NameRelationService();
        NameRelation nr = nrs.getNameRelation(0);
        nr.setParentType(NameRelation.SUBJECT_TYPE);
        nr.setlParentID(SubjectID);
        nr.setlChildID(nc.getNameCardID());
        nr.setRelationType(OptionService.getOptionValue("Setup","ContactRelationType"));
        nrs.saveNameRelation(nr);
      }
    }
    return result.toString();
  }
  
  public long getSubjectIDBySubjectCode (long jobCardID, String subjectCode) {
    long result = 0;
    Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "SELECT SubjectID FROM Subject" +
        " INNER JOIN Session ON Session.SessionID = Subject.SessionID " +
        " WHERE SubjectCode=? AND Session.JobCardID=?";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setString(1,subjectCode);
      ps.setLong(2,jobCardID);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
        result = rs.getLong("SubjectID");
      }
      rs.close();
      ps.close();
    } catch (Exception e) {
      logger.error("getSubjectIDBySubjectCode()",e);
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }

  public int getLastShotNumber (long subjectID) {
    int result = 0;
    Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "SELECT ShotNo FROM Shot" +
        " INNER JOIN Subject ON Shot.SubjectID = Subject.SubjectID " +
        " WHERE Subject.SubjectID=? ORDER BY ShotNo DESC LIMIT 1";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,subjectID);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
        result = rs.getInt("ShotNo");
      }
      rs.close();
      ps.close();
    } catch (Exception e) {
      logger.error("getLastShotNumber()",e);
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
  

    
}
