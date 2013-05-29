raplet
======
A rapportive raplet for Clarify/Dovetail.

* Information on rapportive: https://rapportive.com
* Information on raplets: http://code.rapportive.com/
* Information about this specific raplet: http://www.dovetailsoftware.com/blogs/gsherman/archive/2012/12/13/you-got-dovetail-in-my-gmail

Schema Changes:
* Add table_user.x_authtoken varchar(128)
* A SchemaScript file is provided for this schema change (which can be used with Dovetail SchemaEditor): token.schemascript.xml

Configuration:

in fc.env:
* database connection information
* set the path to the logging configuration file

in logging.config:
* set the File param to be the log file path and filename

in raplet.asp:
* set the rapletURL variable to be the URL of the raplet
* set the mobileAppURL variable to be the URL of the Dovetail Mobile app 
* set the authTokenField to the field on table_user that will hold teh user's authentication token. suggested: x_authtoken

Create your web app and application pool in IIS:
* App Pool Name: raplet
* Web site name (alias): raplet
* Physical Path: directory where raplet.asp is located

Client Install:
* Install rapportive from http://rapportive.com/
* In your browser, open up GMail
* From the rapportive menu, click on Add Raplets
* Then click on Install within the Custom Raplet box.
* It will ask for the custom raplet URL, which will be the URL you setup in IIS + /raplet.asp, like this: http://localhost/raplet/raplet.asp
* it should then prompt you for your Dovetail/Clarify login and password.
* login
* open up an email from one of your customers that you know is in your Dovetail/Clarify system
* You should see case information in the rapportive sidebar, as shown in the screenshots here: 
  http://www.dovetailsoftware.com/blogs/gsherman/archive/2012/12/13/you-got-dovetail-in-my-gmail







