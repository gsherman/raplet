<%@ language="JavaScript" %>
<%
var clientId = Request.QueryString('client_id');
var responseType = Request.QueryString('response_type');
var redirectURI = Request.QueryString('redirect_uri') + '';

var error = Request.QueryString('error') + '';
if (error == "undefined"){error = '';}

var valid=true;
if (clientId != "rapportive"){ valid=false;}
if (responseType != "token"){ valid=false;}
if (redirectURI.slice(0, 31) != "https://rapportive.com/raplets/"){ valid=false;}

%>

<html>

<head>
<title>Dovetail Login</title>
<style>
	body{background-color:lightsteelblue;}	
	#logo{width:32px;height:32px;margin-right:7px;vertical-align:middle;}
	#error{color:red;padding:10px 0px;display:block;}	
	</style>
</head>

<body>
<h3 class='name'><img id='logo' src='../logo.gif'/>Dovetail Login</h3>

<%
if (!valid){
	Response.Write('<h1>Warning!</h1>');
	Response.Write('<p>The provided query string parameters are not what we were expecting.</p>');
	Response.Write('<p>Best to turn back and contact Dovetail support with the following information:</p>');
	Response.Write('<br/>clientId = ' + clientId);
	Response.Write('<br/>responseType = ' + responseType);
	Response.Write('<br/>redirectURI = ' + redirectURI);
	Response.End();
}
%>

<span id="error"><%=error%></span>

<form method="POST" action="auth2.asp">
  Username: <input type="text" name="username" /><br />
  Password: <input type="password" name="password" /><br />
  <p><input type="submit" value="Login" /></p>
  <input type="hidden" name="redirectURI" value="<%=redirectURI%>"/>  
</form>

</body>
</html>
