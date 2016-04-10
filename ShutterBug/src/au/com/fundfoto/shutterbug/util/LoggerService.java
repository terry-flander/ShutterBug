package au.com.fundfoto.shutterbug.util;

import org.apache.log4j.*;
import org.apache.log4j.xml.DOMConfigurator;
import au.com.fundfoto.shutterbug.entities.OptionService;

public class LoggerService {

  private LoggerService() {
  }
  
  public static void configure() {
    Logger.getRootLogger();
    try {
      String source = null;
      /*
      if (false) {
        new DOMConfigurator().doConfigure(d.getInputStream(),LogManager.getLoggerRepository());
        source = "Document: " + d.getName();
      } else {
      */
        String fileName = OptionService.getOptionValue("Setup","LogFileConfig");
        DOMConfigurator.configure(fileName);
        source = "File: " + fileName;
      // } 
      Logger logger = Logger.getLogger(LoggerService.class);
      logger.warn("init from: "+source);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
  
}