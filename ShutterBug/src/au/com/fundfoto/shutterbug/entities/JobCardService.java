package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;
import java.util.Hashtable;
import java.util.Enumeration;
import java.util.Comparator;
import org.apache.log4j.*;

import au.com.fundfoto.shutterbug.util.DbUtil;
import au.com.fundfoto.shutterbug.util.StringUtil;
import au.com.fundfoto.shutterbug.util.FileUtil;

public class JobCardService {
	  
  static Logger logger = Logger.getLogger("JobCardService");
  
  Hashtable<String,Photographer> JobShots = null;

  public JobCardService() {
  }
  
/** Construct a JobCard object based on input JobCardID
 *
 * @param JobCardID -- Contains the DB JobCardID value for the requested JobCard
 * @returns JobCard 
 */
  public JobCard getJobCard (long JobCardID) {
    JobCard result = new JobCard();
    Connection con = null;
    if (JobCardID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT * FROM JobCard WHERE JobCardID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,JobCardID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
          result = createJobCard(rs);
        }
        rs.close();
        ps.close();
      } catch (Exception e) {
        logger.error("getJobCard()",e);
      } finally {
        DbUtil.freeConnection(con);
      }
    } else {
      result.setBaseDirectory(OptionService.getOptionValue("Setup","DefaultBaseDirectory"));
    }
    return result;
  }
  
  public JobCard getJobCard (String JobCode) {
    JobCard result = new JobCard();
    Connection con = null;
    if (JobCode!=null && JobCode.length()>0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT * FROM JobCard WHERE Code=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1,JobCode);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
          result = createJobCard(rs);
        }
        rs.close();
        ps.close();
      } catch (Exception e) {
        logger.error("getJobCard()",e);
      } finally {
        DbUtil.freeConnection(con);
      }
    }
    return result;
  }
  
  public boolean saveJobCard(JobCard jc) {
    boolean result = false;
    Connection con = null;
    if (validate(jc)) {
		  try {
	      String sql = null;
	 	    if (jc.getJobCardID()==0) {
		      sql = "INSERT INTO JobCard (Name,Code,Description,Type,Date,StartTime,EndTime,BaseDirectory) VALUES (?,?,?,?,?,?,?,?)";
		    } else {
		      sql = "UPDATE JobCard SET Name=?,Code=?,Description=?,Type=?,Date=?,StartTime=?,EndTime=?,BaseDirectory=? WHERE JobCardID=?";
		    }
	 	    con = DbUtil.getConnection();
	 	    PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
	      ps.setString(1,jc.getName());
	      ps.setString(2,jc.getCode());
	      ps.setString(3,jc.getDescription());
	      ps.setString(4,jc.getType());
	      ps.setDate(5,jc.getdJobDate());
	      ps.setTime(6,jc.getdStartTime());
	      ps.setTime(7,jc.getdEndTime());
	      ps.setString(8,jc.getBaseDirectory());
	      if (jc.getJobCardID()!=0) {
	        ps.setLong(9,jc.getJobCardID());
	      }
	      ps.executeUpdate();
	      if (jc.getJobCardID()==0) {
	        long JobCardID = DbUtil.getGeneratedKey(ps);
	        jc.setJobCardID(JobCardID);
	      }
	      ps.close();
	      result = true;
		  } catch (Exception e) {
		    logger.warn("saveJobCard() Could not update: "+e.getMessage());
		    result = false;
		  } finally {
			  DbUtil.freeConnection(con);
	    }
    }
    return result;
  }
  
  private boolean validate(JobCard jc) {
  	boolean result = true;
  	if (jc.getBaseDirectory()==null || jc.getBaseDirectory().length()==0) {
  		jc.addErrMsg("Base Directory may not be blank.");
  		result = false;
  	}
  	if (result) {
	    Connection con = null;
	 	  try {
	      String sql = "SELECT Code FROM JobCard WHERE BaseDirectory=? AND JobCardID<>?";
	 	    con = DbUtil.getConnection();
	  	  PreparedStatement ps = con.prepareStatement(sql);
	  	  ps.setString(1,jc.getBaseDirectory());
	  	  ps.setLong(2,jc.getJobCardID());
	      ResultSet rs = ps.executeQuery();
	      if (rs.next()) {
	      	jc.addErrMsg("Base Directory already used on Job Code: "+rs.getString("Code"));
	      	result = false;
	      }
	      ps.close();
	    } catch (Exception e) {
	 	    logger.warn("validate() Could not update: "+e.getMessage());
	 	  } finally {
	 		  DbUtil.freeConnection(con);
	 	  }
  	}
  	return result;
  }
  
  public JobCard[] getJobCardList() {
    Vector<JobCard> result = new Vector<JobCard>();
    Connection con = null;
 	  try {
      String sql = "SELECT JobCardID,Name,Code,Description,Type,Date,StartTime,EndTime FROM JobCard ORDER BY Name";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
    	JobCard jc = new JobCard();
    	jc.setJobCardID(rs.getLong("JobCardID"));
        jc.setName(rs.getString("Name"));
        jc.setCode(rs.getString("Code"));
        jc.setDescription(rs.getString("Description"));
        jc.setType(rs.getString("Type"));
        jc.setdJobDate(rs.getDate("Date"));
        jc.setdStartTime(rs.getTime("StartTime"));
        jc.setdEndTime(rs.getTime("EndTime"));
        result.add(jc);
      }
      ps.close();
    } catch (Exception e) {
 	    logger.warn("getJobCardList() Could not update: "+e.getMessage());
 	  } finally {
 		  DbUtil.freeConnection(con);
 	  }
    return (JobCard[])result.toArray(new JobCard[result.size()]);
  }

  private JobCard createJobCard(ResultSet rs) {
    JobCard result = new JobCard();
    try {
    result.setJobCardID(rs.getLong("JobCardID"));
      result.setName(rs.getString("Name"));
      result.setCode(rs.getString("Code"));
      result.setDescription(rs.getString("Description"));
      result.setType(rs.getString("Type"));
      result.setdJobDate(rs.getDate("Date"));
      result.setdStartTime(rs.getTime("StartTime"));
      result.setdEndTime(rs.getTime("EndTime"));
      result.setBaseDirectory(rs.getString("BaseDirectory"));
    } catch (Exception e) {
      logger.warn("createJobCard() Could not create: "+e.getMessage());
    }
    return result;
  }
  
  public boolean createDirectories(long JobCardID) {
    boolean result = false;
    try {
      if (JobCardID!=0) {
        JobCard jc = getJobCard(JobCardID);
        JobPhotographer[] photographers = new JobPhotographerService().getJobPhotographerList(JobCardID);
        if (photographers.length>0) {
          Option[] dirs = new OptionService().getOptionList("CreateDirectories");
          String directory = jc.getBaseDirectory();
          FileUtil.makeDirectory(directory);
          for (int i=0;i<dirs.length;i++) {
            directory = jc.getBaseDirectory() + "/" + dirs[i].getOptionValue();
            if (directory.indexOf("${Directory}")!=-1) {
              FileUtil.makeDirectory(directory.substring(0,directory.indexOf("${Directory}") - 1));
              for (int j=0;j<photographers.length;j++) {
                FileUtil.makeDirectory(directory.replaceAll("\\$\\{Directory}",photographers[j].getDirectory()));
              }
            } else {
              FileUtil.makeDirectory(directory);
            }
          }
          result = true;
        } else {
          logger.warn("createDirectories() Could not create. No Photographers setup on this Job.");
        }
      }
    } catch (Exception e) {
      logger.warn("createDirectories() Could not create: "+e.getMessage());
    }
    return result;
  }
  
  public Hashtable<String, DirectoryCount> countDirectories(long JobCardID) {
    Hashtable<String, DirectoryCount> result = new Hashtable<String, DirectoryCount>();
    try {
      if (JobCardID!=0) {
        int missingDirectories = 0;
        JobCard jc = getJobCard(JobCardID);
        JobPhotographer[] photographers = new JobPhotographerService().getJobPhotographerList(JobCardID);
        int[] count = new int[2];
        if (photographers.length>0) {
          Option[] dirs = new OptionService().getOptionList("CreateDirectories");
          for (int i=0;i<dirs.length;i++) {
            count[0] = 0;
            count[1] = 0;
            String directory = jc.getBaseDirectory() + "/" + dirs[i].getOptionValue();
            if (directory.indexOf("${Directory}")!=-1) {
              for (int j=0;j<photographers.length;j++) {
                int[] cnt = FileUtil.countFiles(directory.replaceAll("\\$\\{Directory}",photographers[j].getDirectory()), true);
                count[0] += cnt[0];
                count[1] += cnt[1];
              }
              directory = directory.replaceAll("\\$\\{Directory}","");
            } else {
              count = FileUtil.countFiles(directory, true);
            }
            if (count[0]==-1) {
              missingDirectories++;
            }
            result.put(dirs[i].getOptionName(), new DirectoryCount(dirs[i].getOptionName(), count, directory));
            logger.warn("adding: "+dirs[i].getOptionName());
          }
        }
        String workingDir = OptionService.getOptionValue("Setup","WorkingDirectory");
        count = FileUtil.countFiles(workingDir + "/MOUNTS/" + jc.getCode(), true);
        result.put("MOUNTS", new DirectoryCount("MOUNTS", count, workingDir + "/MOUNTS/" + jc.getCode()));
        count = FileUtil.countFiles(workingDir + "/ORDERS/" + jc.getCode(), true);
        result.put("ORDERS", new DirectoryCount("ORDERS", count, workingDir + "/ORDERS/" + jc.getCode()));
        count[0] = 0;
        count[1] = 0;
        result.put("FTP", new DirectoryCount("FTP", count, OptionService.getOptionValue("Setup","FTPDirectory")));
        count[0] = new OrderService().countOrders(jc.getCode());
        result.put("ORDERCARDS", new DirectoryCount("ORDERCARDS", count, ""));
        if (missingDirectories>0) {
          count[0] = missingDirectories;
          result.put("MISSING", new DirectoryCount("MISSING",count, ""));
        }
      }
    } catch (Exception e) {
      logger.warn("countDirectories() Could not count: "+e.getMessage());
    }
    return result;
  }
  
  public String copyRenameCameraPictures(long JobCardID, boolean overwriteFiles) {
    String result = null;
    if (JobCardID!=0) {
	    try {
	    	JobCard jc = new JobCardService().getJobCard(JobCardID);
	    	// Set SubjecCode values first to allow error reporting
	    	logger.info("copyRenameCameraPictures() setSubjectCodes");
	    	result = setSubjectCodes(JobCardID);
	    	// Load all Subject First and Last shots associated with this Job 
	    	// Check for any overlap of numbers by PHOTOGRAPHER directory
	    	if (result==null) {
		    	logger.info("copyRenameCameraPictures() loadJobShotList");
	    		result = loadJobShotList(JobCardID);
	    	}
	    	// Check for any PHOTOGRAPHER Pictures not included in Shot List 
	    	if (result==null) {
	    	  logger.info("copyRenameCameraPictures() checkDirContents");
	    	  result = checkDirContents(jc.getBaseDirectory());
	    	}
	    	// No errors reported; go ahead and copy/rename photographers. May still be errors reported here.
	    	if (result==null) {
		    	logger.info("copyRenameCameraPictures() doRenameCameraPictures");
	    		result = doRenameCameraPictures(JobCardID, overwriteFiles);
	    	}
	    } catch (Exception e) {
	    	result = "Could not rename: " + e.getMessage();
	    	e.printStackTrace();
	    }
    } else {
    	result = "Could not rename: JobCardID = 0";
    }
    return result;
  }
  
  private String setSubjectCodes(long JobCardID) {
  	StringBuffer result = new StringBuffer();
    JobSession[] jcs = new JobSessionService().getJobSessionList(JobCardID);
    SubjectService ss = new SubjectService();
    for (int i=0;i<jcs.length;i++) {
    	String r = ss.setSubjectCode(jcs[i].getSessionID());
    	if (r!=null) {
    		result.append(r + "\n");
    	}
    }
    return (result.length()!=0?result.toString():null);
  }
  
  private String loadJobShotList(long JobCardID) {
  	StringBuffer result = new StringBuffer(100);
    Connection con = null;
 	  try {
      String sql = "SELECT N.NameCardID,concat(concat(N.FirstName,' '),N.LastName) AS FULL_NAME,P.Directory,P.Prefix,S.SubjectCode,S.FirstShot,S.LastShot FROM Subject S,JobPhotographer P,NameCard N "
        + " WHERE S.SessionID IN (SELECT SessionID FROM Session WHERE Session.JobCardID=?) "
      	+ " AND P.NameCardID = S.PhotographerID " 
      	+ " AND P.JobCardID=? "
        + " AND N.NameCardID=P.NameCardID "
        + " AND S.FirstShot<>0 AND S.LastShot<>0  "
      	+ " ORDER BY P.Directory, S.FirstShot";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
  	  ps.setLong(1, JobCardID);
  	  ps.setLong(2, JobCardID);
      ResultSet rs = ps.executeQuery();
      this.JobShots = new Hashtable<String,Photographer>();
      while (rs.next()) {
      	String Directory = rs.getString("Directory");
      	if (!this.JobShots.containsKey(Directory)) {
      		this.JobShots.put(Directory,new Photographer(rs.getLong("NameCardID"),Directory,rs.getString("Prefix"),rs.getString("FULL_NAME")));
      	}
      	this.JobShots.get(Directory).addShots(rs.getString("SubjectCode"),rs.getInt("FirstShot"),rs.getInt("LastShot"));
      }
      ps.close();
    } catch (Exception e) {
 	    logger.warn("validateJobShotList() Could not update: "+e.getMessage());
 	  } finally {
 		  DbUtil.freeConnection(con);
 	  }
 	  // Check for errors
  	for (Enumeration<Photographer> e=this.JobShots.elements();e.hasMoreElements();) {
  		result.append(e.nextElement().getErrors());
  	}
 	  return (result.length()>0?result.toString():null);
  }
  
  private String checkDirContents(String baseDirectory) {
  	StringBuffer result = new StringBuffer(100);
    Option[] dirs = new OptionService().getOptionList("CreateDirectories");
    String photoDir = null;
    for (int i=0;i<dirs.length;i++) {
      if (dirs[i].getOptionName().equals("PHOTOGRAPHER")) {
        photoDir = dirs[i].getOptionValue().substring(0,dirs[i].getOptionValue().indexOf("${Directory}"));
      }
    }
  	for (Enumeration<Photographer> e=this.JobShots.elements();e.hasMoreElements();) {
  		Photographer p = e.nextElement();
      String sourceDir = baseDirectory + "/" + photoDir + p.getDirectory();
      logger.info("checkDirContents() checking: " + sourceDir + " using mask: " + p.getPrefix());
      String[] dirList = new FileUtil().getDirList(sourceDir);
      if (dirList!=null) {
        String prefix = p.getPrefix().substring(0,p.getPrefix().indexOf("#"));
        for (int j=0;j<dirList.length;j++) {
        	if (dirList[j].startsWith(prefix)) {
	        	int shotNumber = getShotNumber(dirList[j], p.getPrefix());
	        	if (shotNumber==0) {
	        		result.append("Picture: " + dirList[j] + " in Directory: " + sourceDir + " could not be converted to Shot number.\n");
	        	} else if (!p.checkNumber(shotNumber)) {
	        		result.append("Picture: " + dirList[j] + " in Directory: " + sourceDir + " is not included in any Session.\n");
	        	}
        	}
        }
      }
    }
    logger.info("checkDirContents() done ("+result.toString()+")");
 	  return (result.length()>0?result.toString():null);
  }
  
  private int getShotNumber(String fileName, String prefix) {
  	int result = 0;
  	StringBuffer bf = new StringBuffer();
  	for (int i=0;i<prefix.length();i++) {
  		if (prefix.substring(i,i+1).equals("#")) {
  			bf.append(fileName.substring(i,i+1));
  		}
  	}
  	try {
  		result = Integer.parseInt(bf.toString());
  	} catch (Exception e) {
  		// Could not convert using prefix mask
  	}
  	return result;
  }
      
  public String doRenameCameraPictures(long JobCardID, boolean doneOnly) {
    int  result = 0;
    int copied = 0;
    try {
      JobCard jc = getJobCard(JobCardID);
      JobPhotographer[] photographers = new JobPhotographerService().getJobPhotographerList(JobCardID);
      JobSession[] jcs = new JobSessionService().getJobSessionList(JobCardID);
      ShotService ss = new ShotService();
      Option[] dirs = new OptionService().getOptionList("CreateDirectories");
      String photoDir = null;
      String rawDir = null;
      for (int i=0;i<dirs.length;i++) {
        if (dirs[i].getOptionName().equals("RAW")) {
          rawDir = dirs[i].getOptionValue();
        }
        if (dirs[i].getOptionName().equals("PHOTOGRAPHER")) {
          photoDir = dirs[i].getOptionValue().substring(0,dirs[i].getOptionValue().indexOf("${Directory}"));
        }
      }
      String targetDir = jc.getBaseDirectory() + "/" + rawDir + "/";        
      logger.info("targetDir="+targetDir+" sessions="+jcs.length);
      for (int i=0;i<jcs.length;i++) {
        Subject[] sus = new SubjectService().getSubjectList(jcs[i].getSessionID());
        for (int j=0;j<sus.length;j++) {
          Subject su = sus[j];
          if (su.getPhotographerID()!=0 && su.getiFirstShot()!=0 && su.getiLastShot()!=0 && (!doneOnly || su.getStatus().equals("done"))) {
            logger.info("Rename photos for: "+su.getSubjectCode());
            JobPhotographer jp = null;
            String PhotographerCode = "";
            for (int k=0;k<photographers.length && jp==null;k++) {
              if (photographers[k].getNameCardID()==su.getPhotographerID()) {
                jp = photographers[k];
                PhotographerCode = jp.getPhotographerInitials();
              }
            }
            if (jp==null) {
              logger.warn("copyRenameCameraPictures() Could not find Photographer for: "+su.getSubjectCode());
              result++;
            } else if (su.getiFirstShot()<=su.getiLastShot() && su.getiLastShot()!=0 && su.getiFirstShot()!=0) {
              String originalDirectory = jc.getBaseDirectory() + "/" + photoDir + jp.getDirectory() + "/";
              int shotNo = ss.getLastShotNo(su.getSubjectID()) + 1;
              int pixId = su.getiFirstShot() - 1;
              while (pixId<su.getiLastShot()) {
                pixId++;
                String fromName = StringUtil.formatNumber(pixId,jp.getFormat());
                String fromFile = originalDirectory + "/" + fromName;
                String toName = su.getSubjectCode() + StringUtil.padNumber(shotNo,2) + PhotographerCode;
                String toFile = targetDir + toName + ".CR2";
                boolean exists = FileUtil.fileExists(toFile);
                if (!ss.shotExists(originalDirectory, fromName) || !exists) {
                  //if (FileUtil.createSymbolicLink(fromFile,toFile)) {
                  if (FileUtil.copyOneFile(fromFile,toFile,false,false)) {
                    if (!exists) {
                      Shot sh = new Shot();
                      sh.setSubjectID(su.getSubjectID());
                      sh.setShotNo(shotNo);
                      sh.setShotName(toName);
                      sh.setOriginalDirectory(originalDirectory);
                      sh.setOriginalName(fromName);
                      ss.saveShot(sh);
                      shotNo++;
                    }
                    copied++;
                  } else {
                    logger.info("copyRenameCameraPictures() skipping: " + fromFile + " to " + toFile);
                  }
                } else {
                	logger.info("copyRenameCameraPictures() Camera photo already in Shot table: "+fromName);
                }
              }
            } else if (su.getiLastShot()!=0 && su.getiFirstShot()!=0) {
              logger.warn("copyRenameCameraPictures() FirstShot/LastShot error for: "+su.getSubjectCode());
              result++;
            }
          } // Subject Status == 'done'
        } // Subjects
      } // Sessions
    } catch (Exception e) {
      logger.warn("copyRenameCameraPictures() Could not create: "+e.getMessage());
      result++;
    }
    return (result!=0?"Unable to Copy/Rename : " + result + " files.":"Successfully Copy/Rename :" + copied + " files") +  "<br>See log for details";
  }
  
  // Scan RAW directory for any new shots for Subject. If found, add Shot record
  public String createNewShots(long JobCardID) {
    int created = 0;
    try {
      if (JobCardID!=0) {
        JobCard jc = getJobCard(JobCardID);
        ShotService shotService = new ShotService();
        SubjectService subjectService = new SubjectService();
        Option[] dirs = new OptionService().getOptionList("CreateDirectories");
        String rawDir = null;
        for (int i=0;i<dirs.length;i++) {
          if (dirs[i].getOptionName().equals("RAW")) {
            rawDir = dirs[i].getOptionValue();
          }
        }
        String sourceDir = jc.getBaseDirectory() + "/" + rawDir + "/";
        String[] dirList = new FileUtil().getDirList(sourceDir, jc.getCode());
        if (dirList!=null) {
          Hashtable<String, Shot> jobShots = shotService.getJobShots(JobCardID);
	        for (int i=0;i<dirList.length;i++) {
	          String fileName[] = dirList[i].split("\\.");
	          if (fileName.length==2 && !jobShots.containsKey(fileName[0])) {
		        	String subjectCode = fileName[0].substring(0,6);
		        	long subjectID = subjectService.getSubjectIDBySubjectCode(JobCardID, subjectCode);
		        	if (subjectID!=0) {
			          Shot sh = new Shot();
			          sh.setSubjectID(subjectID);
				        sh.setShotNo(subjectService.getLastShotNumber(subjectID) + 1);
				        sh.setShotName(fileName[0]);
				        sh.setOriginalDirectory("none");
				        sh.setOriginalName("n/a");
				        shotService.saveShot(sh);
				        created++;
                logger.warn("createNewShots() New Shot from RAW: " + fileName[0]);
              } else {
                logger.warn("createNewShots() SubjectID not found for SubjectCode: "+subjectCode);
	        	  }
	          }
          }
        } else {
          logger.warn("createNewShots() Empty directory: "+rawDir);
        }
      }
    } catch (Exception e) {
      logger.error("createNewShots()",e);
    }
    return (created==0?"No new RAW Photos were found":"Successfully created :" + created + " new Shots from RAW") +  "<br>See log for details";
  }
  
  public boolean moveProofToSubjects(long JobCardID) {
    boolean result = true;
    try {
      if (JobCardID!=0) {
        JobCard jc = getJobCard(JobCardID);
        JobSession[] jcs = new JobSessionService().getJobSessionList(JobCardID);
        Option[] dirs = new OptionService().getOptionList("CreateDirectories");
        String proofDir = null;
        for (int i=0;i<dirs.length;i++) {
          if (dirs[i].getOptionName().equals("PROOF")) {
            proofDir = dirs[i].getOptionValue();
          }
        }
        String sourceDir = jc.getBaseDirectory() + "/" + proofDir + "/";
        for (int i=0;i<jcs.length;i++) {
          Subject[] sus = new SubjectService().getSubjectList(jcs[i].getSessionID());
          for (int j=0;j<sus.length;j++) {
            Subject su = sus[j];
            String targetDir = jc.getBaseDirectory() + "/" + proofDir + "/" + su.getFirstSubjectName().replaceAll(" ","") + "/";
            FileUtil.makeDirectory(targetDir);
            String s[] = new FileUtil().getDirList(sourceDir, su.getSubjectCode()); 
            for (int k=0; k<s.length; k++) {
              String fromFile = sourceDir + s[k];
              String toFile = targetDir + s[k];
              if (!FileUtil.moveFile(fromFile, toFile)) {
                logger.warn("moveProofToSubjects() Unable to copy: "+fromFile+" to "+toFile);
                result = false;
              }
            }
          }
        }
      } else {
        logger.warn("moveProofToSubjects() Could not copy: JobCardID=0");
        result = false;
      }
    } catch (Exception e) {
      logger.warn("moveProofToSubjects() Could not create: "+e.getMessage());
      result = false;
    }
    return result;
  }
  
  public boolean moveMountShotsBetweenJpgAndWorking(long JobCardID, boolean toWorking) {
    boolean result = true;
    try {
      if (JobCardID!=0) {
        JobCard jc = getJobCard(JobCardID);
        JobSession[] jcs = new JobSessionService().getJobSessionList(JobCardID);
        Option[] dirs = new OptionService().getOptionList("CreateDirectories");
        String jpgDir = null;
        String workingDir = OptionService.getOptionValue("Setup","WorkingDirectory")+ "/MOUNTS/" + jc.getCode();
        for (int i=0;i<dirs.length;i++) {
          if (dirs[i].getOptionName().equals("JPG")) {
            jpgDir = dirs[i].getOptionValue();
          }
        }
        String sourceDir = jc.getBaseDirectory() + "/" + jpgDir + "/";
        String firstPhotoOptions = "_" + OptionService.getOptionValue("FirstPhoto","PhotoSize")+ "_"+ OptionService.getOptionValue("FirstPhoto","PhotoColor");
        for (int i=0;i<jcs.length;i++) {
          Subject[] sus = new SubjectService().getSubjectList(jcs[i].getSessionID());
          for (int j=0;j<sus.length;j++) {
            Subject su = sus[j];
            if (su.getlMountShotID()!=0) {
              Shot sh = new ShotService().getShot(su.getlMountShotID());
              String fromFile = sourceDir + sh.getShotNameBase() + ".jpg";
              String toFile = workingDir + "/" + sh.getShotNameBase()  + firstPhotoOptions + ".jpg";
              FileUtil.makeDirectory(toFile);
              if (toWorking) {
                if (!FileUtil.copyOneFile(fromFile,toFile,true,false)) {
                  logger.warn("moveMountBetweenJpgAndWorking() Unable to link: "+fromFile+" to "+toFile);
                }
              } else {
                try {
                  FileUtil.copyOneFile(toFile, fromFile,true,true);
                  FileUtil.deleteFile(toFile);
                  if (FileUtil.countFiles(toFile, true)[0]==0) {
                    FileUtil.deleteDirectory(toFile);
                  }
                } catch (Exception ex) {
                  logger.warn("moveMountShotsBetweenJpgAndWorking() Unable to delete: "+toFile);
                  result = false;
                }
              }
            }
          }
        }
        if (FileUtil.countFiles(workingDir, true)[0]==0) {
          FileUtil.deleteFile(workingDir);
        }
      }
    } catch (Exception e) {
      logger.error("moveMountBetweenJpgAndWorking() Could not move: "+e.getMessage(),e);
    }
    return result;
  }
  
  public boolean moveJobShotsBetweenJpgAndWorking(long JobCardID, boolean toWorking) {
    boolean result = true;
    try {
      if (JobCardID!=0) {
        JobCard jc = getJobCard(JobCardID);
        OrderService os = new OrderService();
        os.setOrderFilter(jc.getCode(),"");
        Order[] orders = os.getOrderList();
        Option[] dirs = new OptionService().getOptionList("CreateDirectories");
        String jpgDir = null;
        String rawDir = null;
        String workingDir = OptionService.getOptionValue("Setup","WorkingDirectory") + "/ORDERS/" + jc.getCode();
        for (int i=0;i<dirs.length;i++) {
          if (dirs[i].getOptionName().equals("RAW")) {
            rawDir = dirs[i].getOptionValue();
          }
          if (dirs[i].getOptionName().equals("JPG")) {
            jpgDir = dirs[i].getOptionValue();
          }
        }
        String rawSourceDir = jc.getBaseDirectory() + "/" + rawDir + "/";
        String jpgSourceDir = jc.getBaseDirectory() + "/" + jpgDir + "/";
        long firstPhotoProductID = Long.parseLong(OptionService.getOptionValue("FirstPhoto","ProductID"));
        for (int i=0;i<orders.length;i++) {
          OrderLine[] lines = new OrderLineService().getOrderLineList(orders[i].getOrderID());
          for (int j=0;j<lines.length;j++) {
            OrderLine ol = lines[j];
            if (ol.getlProductID()!=firstPhotoProductID) {
              Vector<OrderPhoto> ops = ol.getPhotos();
              for (int k=0;k<ops.size();k++) {
                OrderPhoto op = ops.get(k);
                if (toWorking) {
                  String fromFile = rawSourceDir + op.getShotNameBase() + ".CR2";
                  String toFile = workingDir + "/" + orders[i].getOrderNumber()+"/" + op.getShotNameBase() + "_" + op.getSize()+"_"+op.getColor() + ".CR2";
                  FileUtil.makeDirectory(toFile);
                  if (!FileUtil.copyOneFile(fromFile, toFile, true, false)) {
                    logger.warn("moveJobShotsBetweenJpgAndWorking() Unable to link: "+fromFile+" to "+toFile);
                    result = false;
                  }
                  fromFile = jpgSourceDir + op.getShotNameBase() + "_" + op.getSize()+"_"+op.getColor() + ".jpg";
                  toFile = workingDir + "/" + orders[i].getOrderNumber()+"/" + op.getShotNameBase() + "_" + op.getSize()+"_"+op.getColor() + ".jpg";
                  if (FileUtil.fileExists(fromFile) && !FileUtil.copyOneFile(fromFile, toFile, true, false)) {
                    logger.warn("moveJobShotsBetweenJpgAndWorking() Unable to link: "+fromFile+" to "+toFile);
                    result = false;
                  }
                } else {
                  String toFile = jpgSourceDir + op.getShotNameBase() + "_" + op.getSize()+"_"+op.getColor() + ".jpg";
                  String fromFile = workingDir + "/" + orders[i].getOrderNumber()+"/" + op.getShotNameBase() + "_" + op.getSize()+"_"+op.getColor() + ".jpg";
                  if (FileUtil.fileExists(fromFile)) {
                    if (!FileUtil.copyOneFile(fromFile, toFile, true, true)) {
                      logger.warn("moveJobShotsBetweenJpgAndWorking() Unable to copy: "+fromFile+" to "+toFile);
                      result = false;
                    }
                  }
                  toFile = workingDir + "/" + orders[i].getOrderNumber()+"/" + op.getShotNameBase() + "_" + op.getSize()+"_"+op.getColor() + ".CR2";
                  try {
                    FileUtil.copyOneFile(toFile, fromFile, true, true);
                    if (FileUtil.countFiles(toFile, true)[0]==0) {
                      FileUtil.deleteDirectory(toFile);
                    }
                  } catch (Exception ex) {
                    logger.warn("moveJobShotsBetweenJpgAndWorking() Unable to delete: "+toFile);
                    result = false;
                  } // Clear Symbolic entries in WORKING
                } 
              } // For each order line photo
            } // Order lines which are not first photo
          } // For each order line
        } // For each order
        if (FileUtil.countFiles(workingDir, true)[0]==0) {
          FileUtil.deleteFile(workingDir);
        }

      } // JobCard exists
    } catch (Exception e) {
      logger.warn("moveJobShotsBetweenJpgAndWorking() Could not move: "+e.getMessage());
    }
    return result;
  }
  
  public boolean copyWorkingToFtp(long JobCardID) {
    boolean result = false;
    try {
      JobCard jc = new JobCardService().getJobCard(JobCardID);
      if (jc!=null) {
        String ftpDir = FileUtil.getFTPDirName();
        FileUtil.copyAll(OptionService.getOptionValue("Setup","WorkingDirectory") + "/ORDERS/" + jc.getCode(), ftpDir);
        FileUtil.copyAll(OptionService.getOptionValue("Setup","WorkingDirectory") + "/MOUNTS/" + jc.getCode(), ftpDir);
        result = true;
      } else {
        logger.warn("copyWorkingToFtp() Job does not exist.");
      }
    } catch (Exception e) {
      logger.error("copyWorkingToFtp()",e);
    }
    return result;
  }
  
  public String createOrders(long JobCardID, boolean mountOnly) {
    StringBuffer result = new StringBuffer();
    try {
    	int newOrderCount = 0;
      if (JobCardID!=0) {
        OrderService os = new OrderService();
        OrderLineService ols = new OrderLineService();
        long firstPhotoProductID = 0;
        String firstPhotoOptions = null;
        ProductCard pc = null;
       	Vector<OrderPhoto> v = new Vector<OrderPhoto>();
        try {
        	firstPhotoProductID = Long.parseLong(OptionService.getOptionValue("FirstPhoto","ProductID"));
        	firstPhotoOptions = OptionService.getOptionValue("FirstPhoto","OptionList");
          pc = new ProductCardService().getProductCard(firstPhotoProductID);
          OrderPhoto op = new OrderPhoto();
         	op.setFrameOrder(1);
         	op.setQuantity(1);
         	op.setColor(OptionService.getOptionValue("FirstPhoto","PhotoColor"));
         	op.setSize(OptionService.getOptionValue("FirstPhoto","PhotoSize"));
         	v.add(op);
        } catch (Exception e) {
          logger.warn("createOrders() FirstPhoto not configured properly");
        }
        NameRelationService nrsrv = new NameRelationService(); 
        JobSession[] jcs = new JobSessionService().getJobSessionList(JobCardID);
        String contactType = OptionService.getOptionValue("Setup","ContactRelationType");
        String billToType = OptionService.getOptionValue("Setup","BillToRelationType");
        SubjectService subjectService = new SubjectService();
        OrderSubjectService oss = new OrderSubjectService();
        for (int i=0;i<jcs.length;i++) {
          Subject[] sus = subjectService.getSubjectList(jcs[i].getSessionID());
          for (int j=0;j<sus.length;j++) {
            Subject su = sus[j];
            if (su.getStatus().equals("done") 
                && !OrderService.orderNumberExists(0, su.getSubjectCode())
                && (!mountOnly || (su.getlMountShotID()!=0 && pc!=null))) {
	            NameRelation[] nrs = nrsrv.getNameRelationList(NameRelation.SUBJECT_TYPE, su.getSubjectID());
	            long NameCardID = getRelationType(nrs, billToType);
	            if (NameCardID==0) {
	              NameCardID = getRelationType(nrs, contactType);
	            }
	            if (NameCardID==0) {
	            	NameCardID = su.getNameCardID();
	            }
	            Order or = os.getOrder(0);
							or.setdOrderDate(new java.sql.Date(new java.util.Date().getTime()));
							or.setOrderStatus("New");
							or.setdTotalPrice(0);
							or.setlNameCardID(NameCardID);
							or.setBillToName("");
							or.setOrderNumber(su.getSubjectCode());
	            os.saveOrder(or);
	            
            	// Ready to go, just add the Subject.MountShotID if it is not 0;
              if (su.getlMountShotID()!=0) {
                v.get(0).setShotID(su.getlMountShotID());
              	
              	OrderLine ol = ols.getOrderLine(0);
              	ol.setOrderID(or.getOrderID());
              	ol.setlProductID(pc.getProductID());
              	ol.setOptionList(firstPhotoOptions);
              	ol.setiQuantity(1);
              	ol.setdCost(pc.getdCost());
              	ol.setdPrice(pc.getdPrice());
              	ol.setdExtendedPrice(pc.getdPrice());
              	ol.setPhotos(v);
              	ols.saveOrderLine(ol);
              }
              
	            // Now add all Subject Name Relations EXCEPT whichever was chosen to be BillTo UNLESS this was the Subject as well
	            for (int k=0;k<nrs.length;k++) {
	            	if (nrs[k].getlChildID()!=NameCardID || nrs[k].getRelationType().equals("Subject")) {
		            	NameRelation nr = nrsrv.getNameRelation(0);
		            	nr.setParentType(NameRelation.ORDER_TYPE);
		            	nr.setlParentID(or.getOrderID());
		            	nr.setlChildID(nrs[k].getlChildID());
		            	nr.setRelationType(nrs[k].getRelationType());
		            	nrsrv.saveNameRelation(nr);
	            	  if (nrs[k].getRelationType().equals("Subject")) {
	            	  	OrderSubject ors = oss.getOrderSubject(0);
	            	  	ors.setOrderID(or.getOrderID());
	            	  	ors.setlSubjectID(su.getSubjectID());
	            	  	oss.saveOrderSubject(ors, false);
	            	  }
	            	}
	            }
	            su.setStatus("order");
	            subjectService.saveSubject(su);
	            newOrderCount++;
	            logger.info("createOrders() New Order: " + or.getOrderNumber() + " for Subject: " + su.getSubjectCode());
	          }
          }
        }
        result.append("Successfully created " + newOrderCount + " new Orders. See log for details.");
      }
    } catch (Exception e) {
      logger.warn("createOrders() Could not create: "+e.getMessage());
      result.append("Errors encountered creating Orders. See log for details.");
    }
    return result.toString();
  }
  
  private long getRelationType(NameRelation[] nr, String type) {
  	long result = 0;
	  for (int k=0;k<nr.length && result==0;k++) {
	  	if (nr[k].getRelationType().equals(type)) {
	  		result = nr[k].getlChildID();
	  	}
	  }
  	return result;
  }
  
  public class DirectoryCount { 
    String dirName;
    int fileCount;
    int topFileCount;
    String dirPath;
    
    public DirectoryCount(String dirName, int[] fileCount, String dirPath) { 
      this.dirName = dirName;
      this.fileCount = fileCount[0];
      this.topFileCount = fileCount[1];
      this.dirPath = dirPath;
    }
    
    public String getDirName() {
      return this.dirName;
    }
    
    public int getFileCount() {
      return this.fileCount;
    }
    
    public int getTopFileCount() {
      return this.topFileCount;
    }
    
    public String getDisplayFileCount() {
      return (this.fileCount>0?String.valueOf(this.fileCount):(this.fileCount==0?"Empty":"N/A"));
    }
    
    public String getDisplayTopFileCount() {
      return (this.topFileCount>0?String.valueOf(this.topFileCount):(this.topFileCount==0?"Empty":"N/A"));
    }
    
    public String getDirPath() {
      return this.dirPath;
    }
    
  }
  
  public class Photographer {
    long NameCardID;
    String Directory = null;
    String Prefix = null;
    String FullName = null;
    Vector<PhotographerShots> shotList;
    PhotographerShots[] pss = null;
    
    public Photographer(long NameCardID, String Directory, String Prefix, String FullName) {
    	this.NameCardID = NameCardID;
    	this.Directory = Directory;
    	this.Prefix = Prefix;
    	this.FullName = FullName;
    	this.shotList = new Vector<PhotographerShots>();
    }
    
    public long getNameCardID() {
    	return this.NameCardID;
    }
    
    public String getDirectory() {
    	return this.Directory;
    }
    
    public String getPrefix() {
    	return this.Prefix;
    }
    
    public String getFullName() {
    	return this.FullName;
    }
    
    public void addShots(String subjectCode, int firstShot, int lastShot) {
    	if (this.shotList==null) {
    		this.shotList = new Vector<PhotographerShots>();
    	}
    	this.shotList.add(new PhotographerShots(subjectCode, firstShot, lastShot));
    }
    
    public String getErrors() {
    	StringBuffer result = new StringBuffer();
    	this.pss = this.shotList.toArray(new PhotographerShots[this.shotList.size()]);
    	int lastShot = 0;
    	String lastSubjectCode = null;
    	for (int i=0;i<this.pss.length;i++) {
    		PhotographerShots ps = this.pss[i];
    		if (ps.getFirstShot()!=0 && ps.getLastShot()!=0) {
    			if (ps.getFirstShot()>ps.getLastShot()) {
    				result.append("Last Shot Before First Show for Subject Code: "+ps.getSubjectCode());
    			} else {
    				if (lastShot!=0 && ps.getFirstShot()<=lastShot) {
  						result.append("First Shot Subject Code: "+ps.getSubjectCode() + " overlaps Last Shot of Subject Code " + lastSubjectCode);
   					}
   					lastShot = ps.getLastShot();
   					lastSubjectCode = ps.getSubjectCode();
    			}
    		}
    	}
    	return result.toString();
    }
    
    public boolean checkNumber(int shotNumber) {
    	boolean result = false;
    	for (int i=0;i<this.pss.length && !result;i++) {
    		PhotographerShots ps = pss[i];
    		result = (ps.getFirstShot()<=shotNumber && shotNumber<=ps.getLastShot());
    	}
    	return result;
    }
  }
  
  public class PhotographerShots {
  	String subjectCode = null;
  	int firstShot = 0;
  	int lastShot = 0;
  	
  	public PhotographerShots(String subjectCode, int firstShot, int lastShot) {
  		this.subjectCode = subjectCode;
  		this.firstShot = firstShot;
  		this.lastShot = lastShot;
  	}
  	
  	public String getSubjectCode() {
  		return this.subjectCode;
  	}
  	
  	public int getFirstShot() {
  		return this.firstShot;
  	}
  	
  	public int getLastShot() {
  		return this.lastShot;
  	}
  }

  class Compare implements Comparator<PhotographerShots> {

    public Compare() {}

    public int compare(PhotographerShots p1, PhotographerShots p2) {
      int result = 0;
      if (p1 != null && p2 != null) {
        result = p1.getFirstShot() - p2.getFirstShot();
      }
      return result;
    }
  
  }
}

