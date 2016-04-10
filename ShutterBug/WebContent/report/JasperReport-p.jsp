<%@ page import="au.com.fundfoto.shutterbug.reports.JasperReport" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.Report" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportParameter" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportParameterService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportResults" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.ReportResultsService" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLogin" %>
<%@ page import="au.com.fundfoto.shutterbug.entities.NameLoginService" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<html>
<body>
<script>
<% String result = doReport(request.getParameterMap()); 
   if (result!=null) { %>
     parent.errorMsg("<%=result%>");
<% } else { %>
     parent.success();
<% } %>
</script>   
</body>
</html>
<%!
public String doReport(Map<String,String[]> params) {
	String result = null;
	StringBuffer errMsg = new StringBuffer();
	long ReportID = 0;
	if (params.containsKey("ReportID")) {
	   ReportID = Long.parseLong(params.get("ReportID")[0]);
	}
  String SessionCode = null;
  if (params.containsKey("SessionCode")) {
     SessionCode = params.get("SessionCode")[0];
  }
	Report re = new ReportService().getReport(ReportID);
	ReportParameter[] rps = new ReportParameterService().getReportParameterList(re.getReportID());
	boolean hasParameters = rps!=null && rps.length>0;
	StringBuffer param = new StringBuffer(100);
	HashMap<String,Object> h = new HashMap<String,Object>();
	for (int i=0;i<rps.length;i++) {
	  String code = rps[i].getCode();
	  String value = params.get(code)[0];
	  rps[i].setEnteredValue(value);
	  errMsg.append(rps[i].getErrMsg());
	  h.put(code, rps[i].getReportValue());
	  param.append(rps[i].getDescription()+" (" + code + "): "+rps[i].getEnteredValue()+" ["+rps[i].getReportValue()+"]\n");
	}
	if (errMsg.length()>0) {
		result = errMsg.toString();
	} else {
		JasperReport jt = new JasperReport();
		jt.setReportName(re.getJasperFile());
		jt.setParameters(h);
		if (!jt.doReport()) {
			result = jt.getErrMsg();
		} else {
		  NameLogin nl = NameLoginService.getNameLogin(SessionCode);
		  ReportResultsService rrs = new ReportResultsService();
		  ReportResults rr = rrs.getReportResults(0);
		  rr.setReportID(ReportID);
		  rr.setParameters(param.toString());
		  rr.setFileName(jt.getOutputFileName());
		  rr.setdRunTime(new java.sql.Timestamp(new java.util.Date().getTime()));
		  rr.setlRunByID(nl.getNameCardID());
		  rrs.saveReportResults(rr);
		  rrs.clearOld(ReportID); 
		}
		jt = null;
	}
	return result;
}
%>