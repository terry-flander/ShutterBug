<%@ page import="java.io.File"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="au.com.fundfoto.shutterbug.entities.OptionService"%>
<%@ page import="au.com.fundfoto.shutterbug.util.BackwardsFileInputStream"%>
<%@ page import="org.apache.log4j.*"%>


<%
  int maxLines = (request.getParameter("maxLines")!=null?Integer.parseInt(request.getParameter("maxLines")):100);
  boolean backwards = (request.getParameter("backwards")!=null);
  StringBuffer LogFileData = (backwards?getLogFile(maxLines):getLogFileOld(maxLines));
%>
<html>
	<head>
		<title>ShutterBug Log File</title>
    <link href="../includes/shutterbug.css" rel="stylesheet" type="text/css">
    <style type="text/css">
      body, table {font-family: arial,sans-serif; font-size: x-small;}
      th {background: #336699; color: #FFFFFF; text-align: left;}
      td {border-bottom:solid black thin;border-color:#224466; }
    </style>
	</head>
	<body>
	<form action="ShowLog-g.jsp" method="GET">
  <input type="text" name="maxLines" value="<%=maxLines%>">
  <input type="checkbox" name="backwards" <%=(backwards?"checked":"")%>> From End?
  <input type="submit" value="Refresh">
  </form>
  <table>
  <tr><th>Time</th><th>Level</th><th>Category</th><th>Message</th></tr>
	<%=LogFileData.toString()%>
  </table>
	</body>
</html>
<%!
public StringBuffer getLogFile(int maxLines) {
  Logger logger = Logger.getLogger("ShowLog-g");
  StringBuffer result = new StringBuffer(1000);
  String fileName = OptionService.getOptionValue("Setup","LogFileDir") + "/" + formatFile(OptionService.getOptionValue("Setup","LogFileName"));
  try {
    File f = new File(fileName);
    List<String> lines = tail(f, maxLines + 1);
    for (int i=lines.size()-1;i>=0;i--)  {
      result.append(getTd(lines.get(i)));
    }
  } catch (Exception e) {
    logger.warn("ShowLog-g.jsp Error: "+e.getMessage()+" fullFile="+fileName);
  }
  return result;
}
public static String getTd(String line) {
  StringBuffer result = new StringBuffer(line.length() + 40);
  String[] words = line.split(" ");
  if (words.length>=5) {
	  result.append("<tr><td>");
	  for (int i=1;i<words.length;i++) {
	    if (i==2 || i==3 || i==4) {
	      result.append("</td><td>");
	    }
	    if (i==2) {
        result.append(words[i].replaceAll("\\[","").replaceAll("]","") + " ");
      } else { 
        result.append(words[i] + " ");
      } 
	  }
	  result.append("</td></tr>");
  }
  return result.toString();
}
public static List<String> tail(File file, int numberOfLinesToRead) throws IOException {
  return tail(file, "ISO-8859-1" , numberOfLinesToRead);
}

public static List<String> tail(File file, String encoding, int numberOfLinesToRead) throws IOException  {
  assert (file != null) && file.exists() && file.isFile() && file.canRead();
  assert numberOfLinesToRead > 0;
  assert (encoding != null) && encoding.matches("(?i)(iso-8859|ascii|us-ascii).*");
  LinkedList<String> lines = new LinkedList<String>();
  BufferedReader reader= new BufferedReader(new InputStreamReader(new BackwardsFileInputStream(file), encoding));
  for (String line = null; (numberOfLinesToRead-- > 0) && (line = reader.readLine()) != null;) {
    // Reverse the order of the characters in the string
    char[] chars = line.toCharArray();
    for (int j = 0, k = chars.length - 1; j < k ; j++, k--)
    {
        char temp = chars[j];
        chars[j] = chars[k];
        chars[k]= temp;
    }
    lines.addFirst(new String(chars));
  }
  reader.close();
  return lines;
}

public StringBuffer getLogFileOld(int maxLines) {
  Logger logger = Logger.getLogger("ShowLog-g.jsp");
  StringBuffer result = new StringBuffer(1000);
  String fileName = OptionService.getOptionValue("Setup","LogFileDir") + "/" + formatFile(OptionService.getOptionValue("Setup","LogFileName"));
  try {
    File f = new File(fileName);
    BufferedReader fwb = new BufferedReader(new InputStreamReader(new FileInputStream(f)));
    int lineCount = 0;
    while (fwb.ready() && lineCount<maxLines) {
      result.append(getTd(fwb.readLine()));
      lineCount++;
    }
    fwb.close();
  } catch (Exception e) {
    logger.warn("ShowLog-g.jsp Error: "+e.getMessage()+" fullFile="+fileName);
  }
  return result;
}
 private String formatFile(String fileName) {
   String result = fileName;
   if (fileName.indexOf("<DATE:") != -1 && fileName.indexOf(">") > fileName.indexOf("<DATE:") + 6) {
     result = fileName.substring(0,fileName.indexOf("<DATE:"));
     String df = fileName.substring(fileName.indexOf("<DATE:") + 6,fileName.indexOf(">"));
     result += getTime(df);
     if (fileName.indexOf(">") < fileName.length()) {
       result += fileName.substring(fileName.indexOf(">") + 1);
     }
   }
   return result;
 }

 private String getTime(String f) {
   String result = "";
   try {
     SimpleDateFormat df = new SimpleDateFormat(f);
     try  {
       result = df.format(new java.util.Date(System.currentTimeMillis()));
     } catch (Exception pe) {
       System.out.println(new java.sql.Timestamp(System.currentTimeMillis()) + "Could not format using format = '" + f + "'");
       try  {
         df.applyPattern("yyyyMMdd");
         result = df.format(new java.util.Date(System.currentTimeMillis()));
       } catch (Exception pe1) {
         System.out.println(new java.sql.Timestamp(System.currentTimeMillis()) + "Could not format using format = 'yyyyMMdd'");
       }
     }
   } catch (Exception e) {
     result = f;
   }
   return result;
}


%>