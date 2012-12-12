<%@ language="JavaScript" %>
<%
//TODO: 
// use x_authtoken
// create token if it doesnt exist (and persist back to db)

var authTokenField = 'x_authtoken';
authTokenField = 'objid';

%>

<head>
<title>Dovetail Login</title>
</head>

<body>
<h3 class='name'><img id='logo' src='../logo.gif'/>Dovetail Login</h3>

<%
var username = Request.Form('username');
var password = Request.Form('password');
var redirectURI = Request.Form('redirectURI');
var FCSession = FCApp.CreateSession()
var valid=true;

try{
	FCSession.Login(username, password, "user");
}catch(e){
	Response.Redirect('auth.asp?error=' + Server.HTMLEncode(e.description));
}

var user = FCSession.CreateGeneric('user');
user.AppendFilter('login_name','=',username);
user.Query();
if (user.Count() != 1 ){
	Response.Write('Error. Unable to locate user record for ' + username);
	FCSession.Logout();
	FCSession.CloseSession();
	FCSession = null;
	Response.End();
}

var authToken = user(authTokenField) + '';

FCSession.Logout();
FCSession.CloseSession();
FCSession = null;

var url = redirectURI + '#access_token=' + authToken;
//Response.Write(url);

Response.Redirect(url);
%>

</body>
</html>
