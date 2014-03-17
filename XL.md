Documentation for XL.m
======================

###Basic Usage

The XL.m Matlab file is a 

creates an instance of an XL object. The object has properties and methods listed below. 

"COM is a platform-independent, distributed, object-oriented system for creating binary software components that can interact. COM is the foundation technology for Microsoft's OLE (compound documents) and ActiveX (Internet-enabled components) technologies."

xl = XL;

XL object

http://msdn.microsoft.com/en-us/library/bb149081.aspx

####Properties:
	
	- (private) Excel : { COM Object / COM.Excel_Application } ActiveX Connection to the running Excel Application.
	- (private) Workbooks :
	- (private) Sheets :

####Methods:


Constructor
create a new ActiveX connection to Excel
@param filename { string } - either (1.) a full filename and absolute path to an Excel 
readable file, (2.) the filename (absolute path is unnecessary) of a file already open in Excel
or (3.) If none is provided, the XL constructor will open a new Excel instance.
@return { COM.Excel_Application } : handle to the ActiveX object
