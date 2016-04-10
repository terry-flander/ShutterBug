package au.com.fundfoto.shutterbug.entities;

import java.sql.*;
import java.util.Vector;
import org.apache.log4j.*;

import au.com.fundfoto.shutterbug.util.DbUtil;

public class ProductCardService {
	
	static String productHTML = null;
	static Vector<String> productControl = null;
	static Vector<String> productOptions = null;
	static Vector<String> productPhotos = null;
	static String productPrices = null;
	static String allOptions = null;
	static String allPhotos = null;
	static Vector<String> allProductImages = null;
	  
  static Logger logger = Logger.getLogger("ProductCardService");

  public ProductCardService() {
  }
  
  public ProductCard getProductCard (long ProductID) {
    ProductCard result = new ProductCard();
    Connection con = null;
    if (ProductID!=0) {
      try {
        con = DbUtil.getConnection();
        String sql = "SELECT * FROM ProductCard WHERE ProductID=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setLong(1,ProductID);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
      	  result = createProductCard(rs);
        }
        rs.close();
        ps.close();
	    } catch (Exception e) {
	      logger.error("getProductCard()",e);
      } finally {
        DbUtil.freeConnection(con);
      }
    }
    return result;
  }
  
  public boolean saveProductCard(ProductCard pc) {
    boolean result = false;
    Connection con = null;
	  try {
      String sql = null;
 	    if (pc.getProductID()==0) {
	      sql = "INSERT INTO ProductCard (ProductDescription,ProductType,OptionList,PhotoList,Cost,Price,ProductImage) VALUES (?,?,?,?,?,?,?)";
	    } else {
	      sql = "UPDATE ProductCard SET ProductDescription=?,ProductType=?,OptionList=?,PhotoList=?,Cost=?,Price=?,ProductImage=? WHERE ProductID=?";
	    }
 	    con = DbUtil.getConnection();
 	    PreparedStatement ps = con.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS);
      ps.setString(1,pc.getProductDescription());
      ps.setString(2,pc.getProductType());
      ps.setString(3,pc.getOptionList());
      ps.setString(4,pc.getPhotoList());
      ps.setDouble(5,pc.getdCost());
      ps.setDouble(6,pc.getdPrice());
      ps.setString(7,pc.getProductImage());
      if (pc.getProductID()!=0) {
        ps.setLong(8,pc.getProductID());
      }
      ps.executeUpdate();
      if (pc.getProductID()==0) {
        long ProductID = DbUtil.getGeneratedKey(ps);
        pc.setProductID(ProductID);
      }
      ps.close();
      result = true;
      productHTML = null;
	  } catch (Exception e) {
	    logger.warn("saveProductCard() Could not update: "+e.getMessage());
	    result = false;
	  } finally {
		  DbUtil.freeConnection(con);
    }
    return result;
  }
  
  public ProductCard[] getProductCardList() {
    Vector<ProductCard> result = new Vector<ProductCard>();
    Connection con = null;
 	  try {
      String sql = "SELECT ProductID,ProductDescription,ProductType,OptionList,PhotoList,Cost,Price,ProductImage FROM ProductCard ORDER BY ProductDescription";
 	    con = DbUtil.getConnection();
  	  PreparedStatement ps = con.prepareStatement(sql);
      ResultSet rs = ps.executeQuery();
      while (rs.next()) {
        result.add(createProductCard(rs));
      }
      ps.close();
    } catch (Exception e) {
 	    logger.warn("getProductCardList() Could not update: "+e.getMessage());
 	  } finally {
 		  DbUtil.freeConnection(con);
 	  }
    return (ProductCard[])result.toArray(new ProductCard[result.size()]);
  }

  public static String getHTMLProductList() {
  	if (productHTML==null) {
  		initStaticFields();
  	}
  	return productHTML;
  }
  
  public static Vector<String> getProductControl() {
  	if (productHTML==null) {
  		initStaticFields();
  	}
  	return productControl;
  }
  
  public static String getProductPrices() {
  	if (productHTML==null) {
  		initStaticFields();
  	}
  	return productPrices;
  }
  
  public static String getAllOptions() {
  	if (productHTML==null) {
  		initStaticFields();
  	}
  	return allOptions;
  }
  
  public static String getAllPhotos() {
  	if (productHTML==null) {
  		initStaticFields();
  	}
  	return allPhotos;
  }
  
  public static Vector<String> getProductOptions() {
  	if (productHTML==null) {
  		initStaticFields();
  	}
  	return productOptions;
  }
  
  public static Vector<String> getProductPhotos() {
  	if (productHTML==null) {
  		initStaticFields();
  	}
  	return productPhotos;
  }

  public static Vector<String> getAllProductImages() {
  	if (productHTML==null) {
  		initStaticFields();
  	}
  	return allProductImages;
  }
  
  private static synchronized void initStaticFields() {
  	if (productHTML==null) {
	    StringBuffer bf = new StringBuffer(1000);
      Vector<String> ctrl = new Vector<String>();
	    Connection con = null;
	 	  try {
	      String sql = "SELECT ProductID,ProductDescription,OptionList,PhotoList,Cost,Price,ProductType,ProductImage FROM ProductCard ORDER BY ProductDescription";
	 	    con = DbUtil.getConnection();
	  	  PreparedStatement ps = con.prepareStatement(sql);
	      ResultSet rs = ps.executeQuery();
	      allOptions = "";
	      allPhotos = "";
	      allProductImages = new Vector<String>();
	      productOptions = new Vector<String>();
	      productPhotos = new Vector<String>();
	      while (rs.next()) {
	      	StringBuffer c = new StringBuffer(100); 
	      	String prodDesc = rs.getString("ProductDescription");
	      	allProductImages.add(rs.getString("ProductImage")!=null?rs.getString("ProductImage"):"");
	        bf.append("<option value=\"" + rs.getString("ProductID") + "\">" + prodDesc + "</option>");
	        String s[] = rs.getString("OptionList").split(";");
	        for (int i=0;i<s.length;i++) {
	        	c.append((c.length()>0?";":"") + s[i]);
		        if (allOptions.indexOf(s[i])==-1) {
		        	allOptions += (allOptions.length()>0?",":"") + s[i];
		        	productOptions.add("<tr><td class=\"optionLabel\">" + OptionService.getOptionName("ProductOptions",s[i]) 
		        	  + "</td><td class=\"optionValue\"><select  onChange=\"setOption('"  + s[i] + "')\" name=\"" + s[i] + "\" id=\"" + s[i] + "\"><option value=\"\">-select-</option>"
		        	  + OptionService.getHTMLOptionList(s[i]) + "</select></td></tr>");
		        }
	        }
	        s = rs.getString("PhotoList").split(";");
	        for (int i=0;i<s.length;i++) {
	        	String[] p = s[i].split(":");
	        	c.append((c.length()>0?";":"") + p[0]);
		        if (allPhotos.indexOf(p[0])==-1) {
		        	allPhotos += (allPhotos.length()>0?",":"") + p[0];
		        	productPhotos.add("<tr><td class=\"photoLabel\">" + OptionService.getOptionName("ProductPhotos",p[0]) 
		        	  + "</td><td class=\"photoValue\"><select name=\"" + p[0] + "\" id=\"" + p[0] + "\"><option value=\"0\">-select-</option>SUBJECT</select></td>"
		        	  + "</td><td class=\"photoValue\"><select name=\"" + p[0].replaceAll("photo","color") + "\" id=\"" + p[0].replaceAll("photo","color") + "\"><option value=\"\">-select-</option>"+OptionService.getHTMLOptionList("PhotoColors") 
		        	  + "</select></td>"
		        		+ "</tr>");
		        }
	        }
	        ctrl.add(c.toString());
	      }
	      ps.close();
	    } catch (Exception e) {
	 	    logger.warn("getHTMLProductList() Could not update: "+e.getMessage());
	 	  } finally {
	 		  DbUtil.freeConnection(con);
	 	  }
	 	  productControl = ctrl;
	    productHTML = bf.toString();
  	}
  }
  
  private ProductCard createProductCard(ResultSet rs) {
    ProductCard result = new ProductCard();
    try {
   	  result.setProductID(rs.getLong("ProductID"));
      result.setProductDescription(rs.getString("ProductDescription"));
      result.setProductType(rs.getString("ProductType"));
      result.setOptionList(rs.getString("OptionList"));
      result.setPhotoList(rs.getString("PhotoList"));
      result.setdCost(rs.getDouble("Cost"));
      result.setdPrice(rs.getDouble("Price"));
      result.setProductImage(rs.getString("ProductImage"));
    } catch (Exception e) {
   	  logger.warn("createProductCard() Could not create: "+e.getMessage());
    }
    return result;
  }

  public void deleteProductCard (ProductCard pc) {
	  Connection con = null;
    try {
      boolean allowDelete = DbUtil.allowDelete("ProductID", pc.getProductID(), "OrderLine");
  	  if (allowDelete) {
	      con = DbUtil.getConnection();
	      String sql = "DELETE FROM ProductCard WHERE ProductID=?";
	      PreparedStatement ps = con.prepareStatement(sql);
	      ps.setLong(1,pc.getProductID());
	      ps.executeUpdate();
	      ps.close();
	      productHTML = null;
      } else {
	      pc.addErrMsg("Unable to delete: Related Order(s) exist");
  	  }
		} catch (Exception e) {
		  e.printStackTrace();
	  } finally {
	    DbUtil.freeConnection(con);
  	}
  }
}
