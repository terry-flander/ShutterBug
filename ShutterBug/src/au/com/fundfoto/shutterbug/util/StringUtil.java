package au.com.fundfoto.shutterbug.util;

import org.apache.log4j.*;

public class StringUtil {
	
  static Logger logger = Logger.getLogger("StringUtil");

  public StringUtil() {
  }
  
  public static String getFormatPrefix(String fmt) {
    StringBuffer result = new StringBuffer();
    for (int i=0;i<fmt.length();i++) {
      String cur = fmt.substring(i,i+1);
      if (!cur.equals("#")) {
        result.append(cur);
      } else {
      	break;
      }
    }
    return result.toString();
  }
  
  public static String padNumber(long num, int pad) {
    StringBuffer result = new StringBuffer(String.valueOf(num));
    while (result.length()<pad) {
      result.insert(0,"0");
    }
    return result.toString();
  }
  
  public static String formatNumber(long num, String fmt) {
    StringBuffer result = new StringBuffer(fmt.length());
    int numLen = 0;
    for (int i=0;i<fmt.length();i++) {
      String cur = fmt.substring(i,i+1);
      if (cur.equals("#")) {
        numLen++;
      } 
      if (numLen>0 && (!cur.equals("#") || i==fmt.length() - 1)) {
        result.append(padNumber(num,numLen));
        numLen=0;
      }
      if (!cur.equals("#")) {
        result.append(cur);
      }
    }
    return result.toString();
  }
  
  public static long parseNumber(String num, String fmt) {
  	long result = 0;
  	if (num.length()!=0) {
	  	if (fmt.length()>0 && num.length()==fmt.length()) {
		  	try {
			    String numString = "";
			    for (int i=0;i<fmt.length();i++) {
			      if (fmt.substring(i,i+1).equals("#")) {
			        numString += num.substring(i,i+1);  
			      }
			    }
			    result = Long.parseLong(numString);
		  	} catch (Exception e) {
		  		logger.warn("parseNumber() Could not parse: " + num + " using: " + fmt + " error=" + e.getMessage());
		  	}
	  	} else {
	  		logger.warn("parseNumber() Number: " + num + " and/or Format: " + fmt + " invalid. Must be non-blank and equal length.");
	  	}
  	} else {
  		logger.info("parseNumber() Allocating first number for Format: "+ fmt);
  	}
    return result;
  }
  
}
