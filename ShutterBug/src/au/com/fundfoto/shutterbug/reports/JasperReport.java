package au.com.fundfoto.shutterbug.reports;

import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.export.*;
import java.util.*;
import java.sql.Connection;
import au.com.fundfoto.shutterbug.util.DbUtil;
import au.com.fundfoto.shutterbug.util.UniqueID;
import au.com.fundfoto.shutterbug.entities.OptionService;
import org.apache.log4j.*;

@SuppressWarnings("rawtypes")
public class JasperReport {


  static Logger logger = Logger.getLogger("JasperReport");

  private String errMsg;
  private String reportName;
  private String outputFileName;
  private HashMap parameters;
  
  public String getErrMsg() {
    return this.errMsg;
  }
  
  public void setReportName(String reportName) {
    this.reportName = reportName;
  }
  
  public void setParameters(HashMap parameters) {
    this.parameters = parameters;
  }
  
  public void setOutputFileName(String outputFileName) {
    this.outputFileName = outputFileName;
  }
  
  public String getOutputFileName() {
    if (this.outputFileName==null) {
       this.outputFileName = String.valueOf(UniqueID.get());  
    }
    return this.outputFileName;
  }

  public JasperReport () {

  }

  @SuppressWarnings( "unchecked" )
  public boolean doReport() {
    boolean result = false;
    String webContentDir = OptionService.getOptionValue("Setup","WebContentDir");
    String reportName = webContentDir + "/" + this.reportName;
    String outputDir = OptionService.getOptionValue("Setup","ReportOutputDir");
    logger.info("Running Report - "+this.reportName);
    setOutputFileName(outputDir + "/" + getOutputFileName() + ".pdf");
    Connection con = null;
    try {
      JasperCompileManager.compileReportToFile(reportName + ".jrxml");
      // Fill the report using a ShutterBug DB Connection
      con = DbUtil.getConnection();
      JasperPrint print = JasperFillManager.fillReport(reportName + ".jasper", this.parameters, con);
      DbUtil.freeConnection(con);
      
      // Create a PDF exporter
      JRExporter exporter = new JRPdfExporter();
        
      // Configure the exporter (set output file name and print object)
      exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, this.outputFileName);
      exporter.setParameter(JRExporterParameter.JASPER_PRINT, print);
        
      // Export the PDF file
      exporter.exportReport();
      result = true;
            
    } catch (JRException e) {
      e.printStackTrace();
      this.errMsg = e.getMessage();
    } catch (Exception e) {
      e.printStackTrace();
      this.errMsg = e.getMessage();
    } finally {
      DbUtil.freeConnection(con);
    }
    return result;
  }
}