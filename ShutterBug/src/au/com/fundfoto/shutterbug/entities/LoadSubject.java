package au.com.fundfoto.shutterbug.entities;

import java.util.Vector;

public class LoadSubject {
  private Vector<LoadName> subjects = new Vector<LoadName>();
  private String contactFirstName;
  private String contactLastName;
  private String contactNumber;
  private StringBuffer errMsg;
    
  public LoadSubject (String subjectNames, String contactNames, String contactNumber) {
    this.subjects = new Vector<LoadName>();
    this.contactFirstName = "";
    this.contactLastName = "";
    this.contactNumber = "";
    this.errMsg = new StringBuffer();
    String[] names = subjectNames.split(";");
    for (int j=0;j<names.length;j++) {
      String[] thisName = names[j].split(",");
      if (thisName.length==2) {
        this.subjects.add(new LoadName(thisName[1].trim(), thisName[0].trim()));
      } else {
        this.errMsg.append("Invalid Name: "+thisName+"\n");
      }
    }
    if (contactNames!=null && contactNames.length()>0) {
      String[] contact = contactNames.split(",");
      if (contact.length==2) {
        this.contactLastName = contact[0].trim();
        this.contactFirstName = contact[1].trim();
      } else {
        this.contactFirstName = contactNames.trim();
        if (subjects.size()>0) {
          LoadName s = subjects.get(0);
          this.contactLastName = s.getLastName();
        }
      }
      this.contactNumber = contactNumber;
    }
  }
  
  public boolean notEmpty () {
    return this.subjects.size()>0;
  }
  public String getContactFirstName() {
    return this.contactFirstName; 
  }
    
  public String getContactLastName() {
    return this.contactLastName; 
  }
    
  public String getContactNumber() {
    return this.contactNumber; 
  }
    
  public Vector<LoadName> getSubjects() {
    return this.subjects;
  }
  
  public String getErrMsg() {
    return this.errMsg.toString();
  }

  public boolean hasError() {
    return this.errMsg.length()>0;
  }

  public class LoadName {
    private String firstName;
    private String lastName;
    
    public LoadName (String firstName, String lastName) {
      this.firstName = firstName;
      this.lastName = lastName;
    }
      
    public String getFirstName() {
      return this.firstName;
    }
      
    public String getLastName() {
      return this.lastName;
    }
  }
}
