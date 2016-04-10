package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;
import org.apache.log4j.*;

import au.com.fundfoto.shutterbug.util.DbUtil;

public class NameCardService {

	static Logger logger = Logger.getLogger("NameCardService");

	private String nameFilter;
	  
  public NameCardService() {
  }
  
  public void setNameFilter(String nameFilter) {
    this.nameFilter = nameFilter.replaceAll("[^\\p{L}\\p{N} ]", "").toUpperCase() + "%";
  }
  
  public NameCard getNameCard (long NameCardID) {
    NameCard result = new NameCard();
    Connection con = null;
	  if (NameCardID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT NameCardID,FirstName,LastName,CompanyName,Address,City,State,PostCode,eMail,Phone,Mobile,BirthDate,MiddleName FROM NameCard WHERE NameCardID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,NameCardID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
      	  result = createNameCard(rs);
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
  
  public NameCard getNameCard (String SessionCode) {
    NameCard result = new NameCard();
    Connection con = null;
    try {
      con = DbUtil.getConnection();
      String sql = "SELECT NameCard.NameCardID,FirstName,LastName,CompanyName,Address,City,State,PostCode,eMail,Phone,Mobile,BirthDate,MiddleName FROM NameCard, NameLogin " +
      "  WHERE SessionCode=? AND NameCard.NameCardID = NameLogin.NameCardID";
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setString(1,SessionCode);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
    	  result = createNameCard(rs);
      }
      rs.close();
      ps.close();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
  
  public boolean saveNameCard(NameCard nc) {
    boolean result = false;
    Connection con = null;
	  try {
      String sql = null;
   	  if (nc.getNameCardID()==0) {
  	    sql = "INSERT INTO NameCard (FirstName,MiddleName,LastName,CompanyName,Address,City,State,PostCode,eMail,Phone,Mobile,BirthDate) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
  	  } else {
  	    sql = "UPDATE NameCard SET FirstName=?,MiddleName=?,LastName=?,CompanyName=?,Address=?,City=?,State=?,PostCode=?,eMail=?,Phone=?,Mobile=?,BirthDate=? WHERE NameCardID=?";
  	  }
   	  con = DbUtil.getConnection();
   	  PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setString(1,nc.getFirstName());
      ps.setString(2,nc.getMiddleName());
      ps.setString(3,nc.getLastName());
      ps.setString(4,nc.getCompanyName());
      ps.setString(5,nc.getAddress());
      ps.setString(6,nc.getCity());
      ps.setString(7,nc.getState());
      ps.setString(8,nc.getPostCode());
      ps.setString(9,nc.getEmail());
      ps.setString(10,nc.getPhone());
      ps.setString(11,nc.getMobile());
      ps.setDate(12,nc.getdBirthDate());
      if (nc.getNameCardID()!=0) {
        ps.setLong(13,nc.getNameCardID());
      }
      ps.executeUpdate();
      if (nc.getNameCardID()==0) {
        long NameCardID = DbUtil.getGeneratedKey(ps);
        nc.setNameCardID(NameCardID);
      }
      ps.close();
      result = true;
    } catch (Exception e) {
	    logger.warn("saveNameCard() Could not update: "+e.getMessage());
	    result = false;
	  } finally {
		  DbUtil.freeConnection(con);
    }
    return result;
  }
  
  public boolean deleteNameCard(NameCard nc) {
    boolean result = false;
    Connection con = null;
    try {
      String sql = "DELETE FROM NameCard WHERE NameCardID=?";
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,nc.getNameCardID());
      ps.executeUpdate();
      ps.close();
      result = true;
    } catch (Exception e) {
      logger.warn("deleteNameCard() Could not delete: "+e.getMessage());
      result = false;
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
  
  public NameCard[] getNameCardList() {
    Vector<NameCard> result = new Vector<NameCard>();
    Connection con = null;
 	  try {
      String sql = "SELECT NameCardID,FirstName,MiddleName,LastName,CompanyName,Address,City,State,PostCode,eMail,Phone,Mobile,BirthDate FROM NameCard ";
      if (this.nameFilter!=null) {
        sql += " WHERE FirstName like '" + this.nameFilter + "' OR LastName like '" + this.nameFilter + "' OR CompanyName like '" + this.nameFilter + "'";
      }
 	    sql += " ORDER BY LastName, FirstName";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createNameCard(rs));
      }
      ps.close();
    } catch (Exception e) {
 	    logger.warn("getNameCardList() Could not update: "+e.getMessage());
 	  } finally {
 		  DbUtil.freeConnection(con);
 	  }
    return (NameCard[])result.toArray(new NameCard[result.size()]);
  }
  
  public NameCard[] getNameCardList(long ParentID, String RelationType) {
    Vector<NameCard> result = new Vector<NameCard>();
    Connection con = null;
    try {
      String sql = "SELECT NameCardID,FirstName,MiddleName,LastName,CompanyName,Address,City,State,PostCode,eMail,Phone,Mobile,BirthDate FROM NameCard NC,NameRelation NR " +
        "WHERE NR.ParentID=? AND NR.RelationType=? " +
        "  AND NR.ChildID = NC.NameCardID " +
        "ORDER BY LastName, FirstName";
      con = DbUtil.getConnection();
      PreparedStatement ps = con.prepareStatement(sql);
      ps.setLong(1,ParentID);
      ps.setString(2, RelationType);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createNameCard(rs));
      }
      ps.close();
    } catch (Exception e) {
      logger.warn("getNameCardList() Could not update: "+e.getMessage());
    } finally {
      DbUtil.freeConnection(con);
    }
    return (NameCard[])result.toArray(new NameCard[result.size()]);
  }
  
  private NameCard createNameCard(ResultSet rs) {
    NameCard result = new NameCard();
    try {
      result.setNameCardID(rs.getLong("NameCardID"));
      result.setFirstName(rs.getString("FirstName"));
      result.setMiddleName(rs.getString("MiddleName"));
      result.setLastName(rs.getString("LastName"));
      result.setCompanyName(rs.getString("CompanyName"));
      result.setAddress(rs.getString("Address"));
      result.setCity(rs.getString("City"));
      result.setState(rs.getString("State"));
      result.setPostCode(rs.getString("PostCode"));
      result.setEmail(rs.getString("eMail"));
      result.setPhone(rs.getString("Phone"));
      result.setMobile(rs.getString("Mobile"));
      result.setdBirthDate(rs.getDate("BirthDate"));
    } catch (Exception e) {
      logger.warn("createNameCard() Unable to create NameCard");
    }
    return result;
  }

  public boolean mergeNameCards(long fromCardID, long toCardID) {
    boolean result = false;
    try {
      NameCard from = getNameCard(fromCardID);
      NameCard to = getNameCard(toCardID);
      if (to.getFirstName().length()==0) {
        to.setFirstName(from.getFirstName());
      }
      if (to.getMiddleName().length()==0) {
        to.setMiddleName(from.getMiddleName());
      }
      if (to.getLastName().length()==0) {
        to.setLastName(from.getLastName());
      }
      if (to.getCompanyName().length()==0) {
        to.setCompanyName(from.getCompanyName());
      }
      if (to.getAddress().length()==0) {
        to.setAddress(from.getAddress());
      }
      if (to.getCity().length()==0) {
        to.setCity(from.getCity());
      }
      if (to.getState().length()==0) {
        to.setState(from.getState());
      }
      if (to.getPostCode().length()==0) {
        to.setPostCode(from.getPostCode());
      }
      to.setEmail(appendValue(to.getEmail(), from.getEmail()));
      to.setPhone(appendValue(to.getPhone(), from.getPhone()));
      to.setMobile(appendValue(to.getMobile(), from.getMobile()));
      if (to.getdBirthDate()==null) {
        to.setdBirthDate(from.getdBirthDate());
      }
      result = saveNameCard(to);
      
      // Save OK, now change links in other files
      result = new JobPhotographerService().changeNameCardID(from.getNameCardID(), to.getNameCardID());
      result = new SubjectService().changeNameCardID(from.getNameCardID(), to.getNameCardID());
      result = new NameRelationService().changeNameCardID(from.getNameCardID(), to.getNameCardID());
      
      // Save OK, delete From UNLESS for some reason it is the same as the TO!
      if (result && (from.getNameCardID()!=to.getNameCardID())) {
        result = deleteNameCard(from);
      }
    } catch (Exception e) {
      logger.warn("mergeNameCards() Unable to merge from NameCard: "+fromCardID+" with: "+toCardID);
    }
    return result;
  }
  
  private String appendValue(String to, String from) {
    // Only append from value if it is not already on the to string.
    StringBuffer result = new StringBuffer(to!=null?to:"");
    if (from!=null && from.length()>0 && to.indexOf(from)==-1) {
      result.append((result.length()>0?",":"")+from);
    }
    return result.toString();
  }

}
