Documentation for XL.m
======================

##Basic Usage

The XL object is a simplified means of creating an ActiveX connection to Microsoft Excel. The class is designed to take most of the burden out of everyday Excel tasks, while maintaining the ActiveX interface objects as properties of the class.

The properties and methods of the object are listed in the 'Technical Documentation' below. 

##Code Examples:

#### creating an empty Excel workbook
```matlab
% instantiate an XL object 
xl = XL;

% pass sheet names as a cell array
sheets = xl.addSheets({ 'Name of 1st sheet', 'Name of 2nd sheet', 'etc...' });

% order is important here; the default sheets must be removed *after* new sheets have been created
xl.rmDefaultSheets();
```

#### opening an Excel workbook from a file
```matlab

% open the get file modal
[ file, path ] = uigetfile({ '*xlsx', 'Excel Spreadsheet (*.xlsx)' }, 'Select Excel File','MultiSelect','Off'); 

% instantiate an XL object from the path 
xl = XL([ path file ]);
```

#### writing to a spreadsheet
```matlab

xl.setCells( 
	sheet, % a sheet (eg, returned from xl.addSheet(''))
	[5, 1], % position to write to [x,y]
	{ 'This', 'is', 'some', 'text', 'data' 
	'to', 'write', 'to', 'the', 'sheet' }, 
	FFEE00, % set the background color to hex #FFEE00 (yellow)
	'true' % autofit the cells
);
```


##Technical Documentation

The XL class object has both static and dynamic methods. *Static* methods are bound to the class at compile time, whereas *dynamic* methods are bound to an object (instance of the class) at runtime. Thus, static methods can be called without instantiating the class.

Documentation for the VBA Object Model Reference can be found on the [Microsoft Developer Network](http://msdn.microsoft.com/en-us/library/bb149081.aspx).

###Properties:
	
- **Excel** : *(read only)* - COM Object
	- ActiveX connection to the running Excel Application (COM Object)
	- If Excel is not currently running, an instance will be created.
- **Workbooks** : *(read only)* - Interface Object
	- ActiveX interface to open Workbooks (Interface Object)
- **Sheets** : *(read only)* - Interface Object
	- ActiveX interface to open Worksheets (Interface Object) 

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
	- Syntax: `[numcols,numrows] = xl.sheetSize( sheet );`
	- Parameters:
		- sheet : handle to a sheet. 
	- Return Value: 
		- array containing [ # columns, # rows ].
	- Description:
		- Returns the size of a worksheet as an array of [ # columns, # rows ].
- **getRow** : 
	- Syntax: `cells = xl.getRow( sheet, index );`
	- Parameters:
		- sheet : handle to a sheet. 
		- index : heightwise index of which row to select (as an integer). 
	- Return Value: 
		- cell array with the values in the designated row.
	- Description:
		- Returns the values of the row at an integer index.
- **setCells** : 
	- Syntax: `range = xl.setCells( sheet, position, data, color, autofit );`
	- Parameters:
		- sheet : handle to a sheet. 
		- position :  starting x,y location of where to place the data (as an array, eg. [x,y]). 
		- data : values to write to the sheet (as an array or cell array).
		- color : OPTIONAL color value to color the cell range. Can be:
			- color as a hexidecimal string like 'FFFFFF'
			- the boolean string value 'false', in which case no color is given.
			- an integer color representation like 16777215 (for 'FFFFFF').
		- autofit : OPTIONAL boolean string designating whether or not to apply column width autofitting to the range. 
			- NOTE: Since Matlab doesn't have strict boolean types, we're comparing strings here. So to be 'true' the value can be anything but 'false'. 
	- Return Value: 
		- Range object, containing the cells in the designated area.
	- Description:
		- Set the values of the cell range starting at the point 'position'.
- **getCells** : 
	- Syntax: `[ cells, range ] = xl.getCells( sheet, position );`
	- Parameters:
		- sheet : handle to a sheet. 
		- position: range of cells to return (as an array in the format [ starting x,y, ending x,y ])
	- Return Value: 
		- cells : cell array with the values.
		- range : range object.
	- Description:
		- Returns the values of 'sheet' from [ position(1), position(2) ], to [ position(3) position(4) ]
- **autofit** : 
	- Syntax: `xl.autofit( range );`
	- Parameters:
		- range : range of cells to autofit.
	- Return Value: 
		- this method has no return value.
	- Description:
		- For each column in 'range', sets the width of that column to the length (in characters) of the cell with the largest number of characters.
- **columnWidth** : 
	- Syntax: `width = xl.columnWidth( sheet, index, width );`
	- Parameters:
		- sheet - handle to an Excel worksheet
		- index - index of the columns of which to set the width (as a string or integer)
		- width - new width of the column ( OPTIONAL - if none is provided, the method will act as a getter rather than a setter ) 
	- Return Value: 
		- the width of the designated column.
	- Description:
		- Set or get the width of the designated column.
- **columnsWidth** : 
	- Syntax: `xl.columnsWidth( sheet, indices, width );`
	- Parameters:
		- sheet - handle to an Excel worksheet
		- indices - indices of the columns of which to set the width (as a string or integer)
		- width - new width of the columns
	- Return Value: 
		- this method has no return value.
	- Description:
		- Set or get the width of the designated columns.


Constructor
create a new ActiveX connection to Excel
@param filename { string } - either (1.) a full filename and absolute path to an Excel 
readable file, (2.) the filename (absolute path is unnecessary) of a file already open in Excel
or (3.) If none is provided, the XL constructor will open a new Excel instance.
@return { COM.Excel_Application } : handle to the ActiveX object
