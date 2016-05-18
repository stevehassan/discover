package discover;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.FileChannel;
import java.nio.channels.ReadableByteChannel;
import java.util.HashMap;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;


public class OAIHarvester implements Runnable {

	final String BASE_URL = "http://oai.ukdataservice.ac.uk/oai/provider?verb=GetRecord&metadataPrefix=oai_dc&identifier=";
	final String BASE_DIR = "C:/Users/Steve/Documents/My Web Sites/Discover/data/"; // Change to your web site's data location
	final String JSON = "studies.json";
	final String TITLE = "title";
	final String CREATOR = "creator";
	final String STATUS = "status";
	final String DELETED = "deleted";
	final String SUCCESS = "success";
	final int MIN = 1;
	final int MAX = 7029;
	
	public void run() {
		System.out.println("Starting");
		int id = MIN;
		int count = 0;
		try(
			Writer json = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(BASE_DIR+JSON), "UTF8"));
			) {
			json.append("[\n");
			for(; id<=MAX; id++){
				System.out.print("Fetching "+id+"...");
				try(ReadableByteChannel in = Channels.newChannel(new URL(BASE_URL+id).openStream());
					FileChannel out = new FileOutputStream(BASE_DIR+id+".xml").getChannel();
		    	){
				    out.transferFrom(in, 0, Long.MAX_VALUE);
				    out.close();
				    System.out.print(" written "+id);
		    	}
			    catch(IOException ex){
			    	System.out.println("Could not load study "+id+":\n"+ex);
			    }
				
			    Map<String, String> map = parseXML(BASE_DIR+id+".xml");
			    if(DELETED.equals(map.get(STATUS))){
			    	new File(BASE_DIR+id+".xml").delete();
			    	System.out.println(" deleted "+id);
			    	continue;
			    }
			    
			    json.append("\t{\n\t\t\"id\": " + id + ", \"title\": \"" + map.get(TITLE)+ "\", \"creator\": \"" + map.get(CREATOR) + "\"\n\t}")
			    	.append(id<MAX?",\n":"\n]");
			    System.out.println(" indexed "+id);
			    count++;
			}
			json.close();
		} catch (IOException e) {
			System.out.println("Error parsing study "+id+":\n"+e);
		}
		System.out.println(count + " studies harvested!");
	}
	
	private Map<String,String> parseXML(String file) {
		final String OAI_DC = "oai_dc:dc";
		final String DC_TITLE = "dc:title";
		final String DC_CREATOR = "dc:creator";
		final String UNDEFINED = "-";
		final String HEADER = "header";
		final String ERROR = "error";
		final String CODE = "code";
		final String IDNOTEXIST = "idDoesNotExist";
		
		Document document;

		HashMap<String,String> map = new HashMap<String,String>();
		map.put("title", UNDEFINED);
		map.put("creator", UNDEFINED);
		map.put(STATUS,SUCCESS);
		
		try{
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			document = builder.parse(file);
			document.getDocumentElement().normalize();

		}catch(Exception ex){
	    	System.out.println("Error...!!"+ex);
	    	return map;
	    }			
		
		// check for deleted studies
		NodeList nList = document.getElementsByTagName(HEADER);
		if(nList.getLength()>0){
			Node node = nList.item(0);
			if (node.getNodeType() == Node.ELEMENT_NODE){
				Element eElement = (Element) node;
				Node attr = eElement.getAttributeNode(STATUS);
				if(attr!=null){
					String status = attr.getTextContent();
					if(status.equalsIgnoreCase(DELETED)){
						map.put(STATUS,DELETED);
						return map;
					}
				}
			}
		}

		// check for non existent studies
		nList = document.getElementsByTagName(ERROR);
		if(nList.getLength()>0){
			Node node = nList.item(0);
			if (node.getNodeType() == Node.ELEMENT_NODE){
				Element eElement = (Element) node;
				Node attr = eElement.getAttributeNode(CODE);
				if(attr!=null){
					String status = attr.getTextContent();
					if(status.equalsIgnoreCase(IDNOTEXIST)){
						map.put(STATUS,DELETED);
						return map;
					}
				}
			}
		}
		
		nList = document.getElementsByTagName(OAI_DC);
		
		String title = "";
		String creator = UNDEFINED;
		
		for (int temp = 0; temp < nList.getLength(); temp++)
		{
		 Node node = nList.item(temp);
		 if (node.getNodeType() == Node.ELEMENT_NODE)
		 {
		    Element eElement = (Element) node;
		    title = eElement.getElementsByTagName(DC_TITLE).item(0).getTextContent();
		    NodeList creators = eElement.getElementsByTagName(DC_CREATOR);
		    // we just get the first creator for the listing
		    if(creators.getLength()>0){
		    	creator = eElement.getElementsByTagName(DC_CREATOR).item(0).getTextContent();
		    }
		 }
		}		
		
		map.put("title", title.replace("\n", "").replace("\r", "").trim());
		map.put("creator", creator.replace("\n", "").replace("\r", "").trim());
		
		return map;
	}

	public static void main(String args[]) {
	    	Thread thread = new Thread(new OAIHarvester()); 
	        thread.start();
	    }
}
