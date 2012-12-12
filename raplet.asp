<%@ language="JavaScript" %>
<!--#include file="json.asp"-->
<%
//TODO: 
// use x_authtoken

//var mobileAppURL = "http://localhost/mobile";
var mobileAppURL = "http://support.dovetailsoftware.com/mobile";

var authTokenField = 'x_authtoken';
authTokenField = 'objid';
  
if (Request.QueryString('show') == "metadata"){
	var result = {};
	result.name = "Dovetail";
	result.description = "View a contact's open cases and quickly create new cases from Rapportive.";
	result.welcome_text = "<p><a href=\"http://www.dovetailsoftware.com\">Dovetail Software</a> is the leading provider of products and services for making Clarify rock.</p>";
	result.icon_url = "https://localhost/raplet/logo.gif";
	//result.preview_url = "";
	result.provider_name = "Dovetail Software";
	result.provider_url = "http://dovetailsoftware.com";
	//result.data_provider_name = "";
	//result.data_provider_url = "";
	result.config_url = "https://localhost/raplet/auth/auth.asp";
		
	var s = JSON.stringify(result);
	var callback = Request.QueryString("callback").Item;
	var jsonp = callback + '(' + s + ')';
	
	Response.Clear();
	Response.Write((jsonp));
	Response.End();
}


var authToken = Request.QueryString('oauth_token') + '';
var email = Request.QueryString("email").Item + '';

var FCSession = FCApp.CreateSession(Application.Contents('fcSessionId'))

var user = FCSession.CreateGeneric('user');
user.AppendFilter(authTokenField,'=',authToken);
user.Query();

if (user.Count() != 1 ){
	var html = "";
	html+='<div id="dovetail-raplet">';   
	html+= "<h3 class='name'><img id='logo' src='https://localhost/raplet/logo.gif'/>Dovetail</h3>";
	html+='<h4>Error! Invalid Token:' + authToken + '</h4>';
	html+="<h4>Try removing and reinstalling the Dovetail raplet.</h4>";
	
	var result = {};
	result.status = 200;
	result.html = html;
		        
	var s = JSON.stringify(result);
	var callback = Request.QueryString("callback").Item;
	var jsonp = callback + '(' + s + ')';
	
	Response.Clear();
	Response.Write((jsonp));
	Response.End();
}


var contactObjid = 0;	
var cases = FCSession.CreateGeneric('extactcase');
var contact = FCSession.CreateGeneric('contact');
contact.AppendFilter('e_mail','=',email);
contact.AppendSort('status','asc');
contact.Query();

if (contact.Count() > 0){
	cases.AppendFilter('contact_objid','=',contact('objid'));
	cases.AppendFilter('condition','starts with','Open');
	cases.AppendSort('creation_time','desc');
	cases.Query();
}

if (contact.Count() == 0){
	Response.Clear();
	Response.End();
}

contactObjid = contact('objid');
var contactUrl = mobileAppURL + "/Contacts/Show/" + contactObjid;

var numCases = cases.Count() - 0;
var firstName = contact('first_name');
var numCasesToDisplay = 3;

var html = "";
html+='<div id="dovetail-raplet">';   

//html+='<h4>Token:' + authToken + '</h4>';
 
html+= "<h3 class='name'><img id='logo' src='https://localhost/raplet/logo.gif'/>Dovetail</h3>";
html+="<h4>" + numCases + " Open Cases for " + "<a id='contact-link' href='" + contactUrl + "'>" + firstName + "</a>" + "</h4>";

var i = 1;

while (!cases.EOF && i <=numCasesToDisplay ){
	var caseId = cases('id_number');
	var caseTitle = cases('title');
	html+="<p><a target=_blank href='" + mobileAppURL + "/Cases/Summary/" + caseId + "'>Case " + caseId + " - " + caseTitle;
	html+="</a></p>";
	cases.MoveNext();
	i++;
}

var remainder = numCases - numCasesToDisplay;

if (cases.Count() > 3){
	html+="<p><a target=_blank  href='" + contactUrl + "'>and " + remainder + " more open cases...</a></p>";
}

html+="<p><a target=_blank  id='newcase-anchor' href='" + mobileAppURL + "/CaseCreate/Compose?contactDatabaseIdentifier=" + contactObjid + "'><input id='newcase' type='button' value='Create a New Case' /></a></p>";
html+="</div>";

var collapsed_html =  "<div class='collapsed'><p class='name'><img id='logo' src='https://localhost/raplet/logo.gif'/>";
		collapsed_html+= "Dovetail - "+ "<a id='contact-link' href='" + contactUrl + "'>" + numCases + " Open Cases" +  "</a>" + "</p></div>";

var css = "h3.name {}";
		css+="#newcase{margin-bottom:5px;xfloat:right;text-transform:uppercase;-moz-border-radius: 5px;-webkit-border-radius: 5px;border-radius: 5px;-moz-box-shadow: 1px 1px 4px rgba(160, 160, 160, 0.3);-webkit-box-shadow: 1px 1px 4px rgba(160, 160, 160, 0.3);";
		css+="box-shadow: 1px 1px 4px rgba(160, 160, 160, 0.3);background: white;background: -webkit-gradient(linear, left top, left bottom, from(white), to(#F4F4F4));";
		css+="background: -moz-linear-gradient(top, white, #F4F4F4);color: #666;padding: 4px 9px;margin-top: 4px;margin-right: 2px;font-size: 9px;cursor:pointer;font-family: Arial;line-height: 1.2;}";
		css+="#newcase:hover{background:#55688A;background:#3E67A9;color:white;}";
		css+="#contact-link{text-decoration:underline;}";
		css+="#contact-link:hover{text-decoration:underline;color:blue;}";
		css+="#logo{width:16px;height:16px;margin-right:7px;vertical-align:text-top}";
		css+="#dovetail-raplet{margin-left:5px;}";
		css+=".collapsed { white-space: nowrap; overflow: hidden; }";


var result = {};
//result.html = html;
//result.js = "alert(\'Hello world!\');"
result.css = css;
result.status = 200;

var sections = {};
sections.expanded_html = html;
sections.collapsed_html = collapsed_html;
result.sections = [sections];
        
var s = JSON.stringify(result);
var callback = Request.QueryString("callback").Item;
var jsonp = callback + '(' + s + ')';

Response.Clear();
Response.Write((jsonp));

%>
