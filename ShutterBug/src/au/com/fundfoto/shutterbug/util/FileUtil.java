package au.com.fundfoto.shutterbug.util;

import au.com.fundfoto.shutterbug.entities.OptionService;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.File;
import java.io.FilenameFilter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import org.apache.log4j.*;

public class FileUtil {
  
  static Logger logger = Logger.getLogger(FileUtil.class);

  public static boolean copyOneFile(String fromFile, String toFile, boolean overwrite, boolean removeSource) {
    boolean result = false;
    try {
      File f1 = new File(fromFile);
      File f2 = new File(toFile);
      if (f1.exists() && (!f2.exists() || overwrite)) {
        InputStream in = new FileInputStream(f1);
        OutputStream out = new FileOutputStream(f2);
    
        byte[] buf = new byte[1024];
        int len;
        while ((len = in.read(buf)) > 0){
          out.write(buf, 0, len);
        }
        in.close();
        out.close();
        if (removeSource) {
          f1.delete();
        }
        result = true;
      } else {
        logger.warn("copyOneFile() Unable to copy: "+fromFile+" to "+toFile + (!f1.exists()?" From File does not exist.":"") + (f2.exists() && !overwrite?" To File exists.":""));
      } 
    } catch (Exception e) {
      logger.warn("copyOneFile() Unable to copy: "+fromFile+" to "+toFile + " Error: " + e.getMessage());
    }
    return result;
  }
  
  public static boolean moveFile(String fromName, String toName) {
    boolean result = false;
    try {
      File fromF = new File(fromName);
      File toF = new File(toName);
      result = fromF.renameTo(toF);
    } catch (Exception e) {
      logger.error("renameFile()",e);
    }
    return result;
  }

  public static String getFTPDirName() {
    String result = null;
    result = OptionService.getOptionValue("Setup","FtpDirectory");
    File[] ftpList = new File(result).listFiles();
    int maxDir = 0;
    for (int i=0;ftpList!=null && i<ftpList.length;i++) {
      if (ftpList[i].isDirectory() && ftpList[i].getName().startsWith("E")) {
        int thisDir = Integer.parseInt(ftpList[i].getName().substring(1));
        maxDir = (thisDir>maxDir?thisDir:maxDir);
      }
    }
    maxDir++;
    result += "/" + "E" + StringUtil.padNumber(maxDir,6);
    return result;
  }

  public static void copyAll(String fromFile, String ftpDir) {
    try {
      File[] dirList = new File(fromFile).listFiles();
      for (int i=0;dirList!=null && i<dirList.length;i++) {
        if (dirList[i].isDirectory()) {
          copyAll(dirList[i].getAbsolutePath(), ftpDir);
        } else {
          if (dirList[i].getName().endsWith(".jpg")) {
            String toFile = ftpDir + "/" + dirList[i].getName(); 
            FileUtil.makeDirectory(toFile);
            FileUtil.copyOneFile(dirList[i].getAbsolutePath(), toFile, true, false);
          }
        }
      }
    } catch (Exception e) {
      logger.error("copyAll()",e);
    }
  }
  
  public static int[] countFiles(String dirName, boolean top) {
    int[] result = new int[2];
    result[0] = -1;
    result[1] = -1;
    try {
      File f = getDirectory(dirName);
      if (f.exists() && f.canRead()) {
        result[0] = 0;
        result[1] = 0;
        File[] dirList = new File(dirName).listFiles();
        for (int i=0;i<dirList.length;i++) {
          if (dirList[i].isDirectory()) {
            result[0] += countFiles(dirList[i].getAbsolutePath(), false)[0];
          } else if (!dirList[i].getName().startsWith(".")) {
            result[0]++;
            if (top) {
              result[1]++;
            }
          }
        }
      }
    } catch (Exception e) {
      // Directory probably not created yet.
    }
    return result;
  }
  

  public static boolean fileExists(String fileName) {
    boolean result = false;
    try {
      result = new File(fileName).exists();
    } catch (Exception e) {
      logger.error("fileExists()",e);
    }
    return result;
  }
  
  public static void deleteFile(String fileName) {
    try {
      File f = new File(fileName);
      f.delete();
      new File(f.getParent() + "/.DS_Store").delete();
    } catch (Exception e) {
      // Probably no DS_Store
    }
  }
  
  public static void deleteDirectory(String fileName) {
    deleteFile(getDirectory(fileName).getAbsolutePath());
  }
  
  public static void makeDirectory(String dirName) {
    File f = getDirectory(dirName);
    if (!f.exists() && !f.mkdirs()) {
      logger.warn("makeDirectory() Could not create: "+f.getAbsolutePath());
    }
  }
  
  private static File getDirectory(String fileName) {
    File result = new File(fileName);
    if (result.exists() && !result.isDirectory()) {
      result = result.getParentFile();
    }
    return result;
  }

  public String[] getDirList(String dirName) {
    return getDirList(dirName, null);
  }

  public String[] getDirList(String dirName, String fileFilter) {
    String[] result = null;
    try {
      File f = getDirectory(dirName);
      if (f.isDirectory()) {
        if (fileFilter!=null) {
          FilenameFilter only = new PrefixFilter(fileFilter); 
          result = f.list(only);
        } else {
          result = f.list();
        }
      }
    } catch (Exception e) {
      logger.error("getDirList()",e);
    }
    return result;
  }
  
  public static boolean isSymbolicLink(String fileName) {
    boolean result = true;
    try {
      File file = new File(fileName);
      if (file.exists()) {
        result = !file.getCanonicalPath().equals(file.getAbsolutePath());
      }
    } catch(IOException ex) {
      logger.error("isSymbolicLink()",ex);
    }
    return result;
  }
  
  public static boolean createSymbolicLink(String fromFile, String toFile) {
    return createSymbolicLink(new File(fromFile), new File(toFile));
  }

  public static boolean createSymbolicLink(File fromFile, File toFile) {
    boolean result = false;
    StringBuffer bf = new StringBuffer();
    String cmd = null;
    if (fromFile.exists() && fromFile.canRead() && !toFile.exists()) {
      try {
        cmd = "ln -s " + fromFile.getAbsolutePath() + " " + toFile.getAbsolutePath();
        Process p = Runtime.getRuntime().exec(cmd);
        BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
        String line;
        while ((line = in.readLine())!=null) {
          bf.append(line + "\n");
        }
        try {
          if (p.waitFor()!=0) {
            bf.append("exit value = " + p.exitValue());
          }
        } catch (InterruptedException e) {
          logger.error("createSymbolicLink()",e);
        }
        p.destroy();
        result = true;
      } catch(IOException ex) {
        logger.error("createSymbolicLink()",ex);
      }
    }
    return result;
  }

  public static boolean openFinder(String dirName) {
    boolean result = false;
    StringBuffer bf = new StringBuffer();
    String cmd = null;
    try {
      cmd = "open " + dirName;
      Process p = Runtime.getRuntime().exec(cmd);
      BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
      String line;
      while ((line = in.readLine())!=null) {
        bf.append(line + "\n");
      }
      try {
        if (p.waitFor()!=0) {
          bf.append("exit value = " + p.exitValue());
        }
      } catch (InterruptedException e) {
        logger.error("openFinder()",e);
      }
      p.destroy();
      result = true;
    } catch(IOException ex) {
      logger.error("openFinder()",ex);
    }
    return result;
  }
  
  public class PrefixFilter implements FilenameFilter { 
    String matchString; 
    public PrefixFilter(String matchString) { 
      this.matchString = matchString; 
    } 
    public boolean accept(File dir, String name) { 
      return name.startsWith(this.matchString); 
    } 
  }
  
  
}