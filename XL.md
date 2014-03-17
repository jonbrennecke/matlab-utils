Documentation for XL.m
======================

###Basic Usage

The XL.m Matlab file is a 

creates an instance of an XL object. The object has properties and methods listed below.      *   

xl = XL;

XL object

####Properties:
	
	-

####Methods:


Constructor
create a new ActiveX connection to Excel
@param filename { string } - either (1.) a full filename and absolute path to an Excel 
readable file, (2.) the filename (absolute path is unnecessary) of a file already open in Excel
or (3.) If none is provided, the XL constructor will open a new Excel instance.
@return { COM.Excel_Application } : handle to the ActiveX object