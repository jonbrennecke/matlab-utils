Documentation for XL.m
======================

###Basic Usage

The XL.m Matlab file is a 

creates an instance of an XL object. The object has properties and methods listed below. 

"COM is a platform-independent, distributed, object-oriented system for creating binary software components that can interact. COM is the foundation technology for Microsoft's OLE (compound documents) and ActiveX (Internet-enabled components) technologies."

xl = XL;

XL object

*static* methods are bound to the class at compile time, whereas *dynamic* methods are bound to an object (instance of the class) at runtime.

Documentation for the VBA Object Model Reference can be found on the [Microsoft Developer Network](http://msdn.microsoft.com/en-us/library/bb149081.aspx).

###Properties:
	
- **Excel** : *(read only)* - COM Object
	- ActiveX connection to the running Excel Application. 
	- If Excel is not currently running, an instance will be created.
- **Workbooks** : *(read only)* - Interface Object
	- 
- **Sheets** : *(read only)* - Interface Object
	- 

###Methods:

####Dynamic:

- **sourceInfo** : 
	- Syntax: `xl.sourceInfo( mfilename('fullpath') );`
	- Parameters:
		- callingScript : (string) absolute path and filename of the calling script.
	- Return Value: 
		- this method has no return value.
	- Description:
		- Appends a sheet with some information about where this file came from.

- **addSheet** : 
	- Syntax: `sheet = xl.addSheet( sheetname );`
	- Parameters:
		- sheetname : (string) name of the sheet to create.
	- Return Value: 
		- handle to the new sheet.
	- Description:
		- Add a single sheet to the active workbook.
- **addSheets** : 
	- Syntax: `sheets = xl.addSheets( sheetnames );`
	- Parameters:
		- sheetnames : cell array containing the names of the sheets to be created.
	- Return Value: 
		- cell array containing handles to the new sheets.
	- Description:
		- Add multiple sheets to the active workbook.
- **rmSheets** : 
	- Syntax: `xl.rmSheets( sheets );`
	- Parameters:
		- sheets : cell array containing handles to the sheets to be removed.
	- Return Value: 
		- this method has no return value.
	- Description:
		- Remove multiple sheets from the active workbook.
		- NOTE: This action is not reversable.
- **rmDefaultSheets** : 
	- Syntax: `xl.rmDefaultSheets();`
	- Parameters:
		- this method has no parameters.
	- Return Value: 
		- this method has no return value.
	- Description:
		- Remove the default sheets ('Sheet1','Sheet2','Sheet3') from the active workbook.
		- NOTE: This function does not check if the sheets are empty; it will delete the default sheets even if you have overwritten their contents.
- **saveAs** : 
	- Syntax: `xl.saveAs( filename );`
	- Parameters:
		- filename : (string) name by which to save the active workbook.
	- Return Value: 
		- this method has no return value.
	- Description:
		- Save the active workbook as 'filename'.
- **clone** : 
	- Syntax: `xl.clone( item );`
	- Parameters:
		- item : handle to either a sheet or a workbook to be cloned.
	- Return Value: 
		- this method has no return value.
	- Description:
		- Clones a workbook or a sheet. If 'item' is a sheet, the sheet is cloned into the same workbook. If 'item' is a workbook, a new workbook is generated.



####Static:

- **sheetSize** : 
	- Syntax: `xl.sheetSize( sheet );`
	- Parameters:
		- sheet : handle to a sheet. 
	- Return Value: 
		- array containing [ # columns, # rows ].
	- Description:
		- Returns the size of a worksheet as an array of [ # columns, # rows ].
- **getRow** : 
	- Syntax: `xl.getRow( sheet, index );`
	- Parameters:
		- sheet : handle to a sheet. 
	- Return Value: 
		- array containing [ # columns, # rows ].
	- Description:
		- Returns the size of a worksheet as an array of [ # columns, # rows ].



Constructor
create a new ActiveX connection to Excel
@param filename { string } - either (1.) a full filename and absolute path to an Excel 
readable file, (2.) the filename (absolute path is unnecessary) of a file already open in Excel
or (3.) If none is provided, the XL constructor will open a new Excel instance.
@return { COM.Excel_Application } : handle to the ActiveX object
