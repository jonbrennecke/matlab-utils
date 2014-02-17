%
% An object-oriented handler for an Excel ActiveX object
%
% by @jonbrennecke / https://github.com/jonbrennecke
%
% Released under the MIT license (see the accompanying LICENSE.md)
%  
classdef XL

	properties (Hidden)
	end

	properties (SetAccess = private)
		Excel;
		Workbooks;
		Sheets;
	end
	
	events
	end
 
	methods
		
		% Constructor
		% create a new ActiveX connection to Excel
		% @param filename { string } - either (1.) a full filename and absolute path to an Excel 
		% readable file, (2.) the filename (absolute path is unnecessary) of a file already open in Excel
		% or (3.) If none is provided, the XL constructor will open a new Excel instance.
		% @return { COM.Excel_Application } : handle to the ActiveX object
		function this = XL( filename )

			% if XL is passed a filename, then create try to find an instance of Excel
			% with the given name
			if exist('filename')
				% this.Excel = actxGetRunningServer('Excel.Application');
				this.Excel = actxserver('Excel.Application');
				set(this.Excel,'Visible',1);
				this.Workbooks = this.Excel.Workbooks;

				% the file may already be open in Excel, so see if it is...
				try
					for i=1:this.Workbooks.Count
						if strcmpi(this.Workbooks.Item(i).Name, filename)
							this.Workbooks.Item(i).Activate()
							this.Sheets = this.Excel.ActiveWorkBook.sheets;
							break
						end
					end
				catch err
					% display the error as a warning
					msg = getReport(err);
					warning(msg)
				end

				% if the file wasn't already open in Excel, open it
				if isempty(this.Sheets)
					try
						% now try opening the spreadsheet
						this.Workbooks.Open(filename);
						this.Sheets = this.Excel.ActiveWorkBook.sheets;

					catch err
						% display the error as a warning
						msg = getReport(err);
						warning(msg)
					end

				end

			% if no filename is passed to the XL Constructor, create a blank Excel workbook
			else 
				% create a new ActiveX connection to Excel
				this.Excel = actxserver('Excel.Application');
				set(this.Excel, 'Visible', 1);

				% add a workbooks and an empty sheets object
				this.Workbooks = this.Excel.Workbooks;
				workbook.triggered = invoke(this.Workbooks, 'Add');
				this.Sheets = this.Excel.ActiveWorkBook.sheets;
				invoke(workbook.triggered,'Activate');
			end
			
		end % end Constructor
		
		% appends a sheet with some information about where this file came from
		function sourceInfo(this,callingScript)
			sheet = this.addSheet('Data Source Info');
			info = dir([ callingScript '.m']);
			values = { 'This xls generated by Matlab on:', date; ...
					'This xls generated by script', callingScript; ...
					'Calling script:', info.name; ...
					'Calling script modified on:', info.date };
			this.setCells(sheet,[1,1], values,'false','true');
		end

		% add a single sheet to the active workbook
		% @return { Interface.Microsoft_Excel_14.0_Object_Library._Worksheet } - handle to the new sheet
		function sheet = addSheet(this,sheetname)
			sheet = invoke(this.Sheets,'Add');
			invoke(sheet, 'Activate');
			try
				sheet.name = sheetname;
			catch
				sheet.name = sheetname(1:31);
			end
		end

		% add multiple sheets to the active workbook
		% @return { cell array} containing { Interface.Microsoft_Excel_14.0_Object_Library._Worksheet } - cell array of handles to the new sheets
		function sheets = addSheets(this,sheetnames)
			for i=1:length(sheetnames)
				sheets{i} = this.addSheet(sheetnames{i});
			end
		end

		% remove one or more sheets from the active workbook
		function rmSheets(this,sheets)
			if iscell(sheets)
				for i=1:length(sheets)
					invoke(sheets{i}, 'Delete');
				end
			else, invoke(sheets{i}, 'Delete');
			end
		end

		% clear the default sheets
		function rmDefaultSheets(this)
			this.Sheets.Item(['Sheet1']).Delete;
			this.Sheets.Item(['Sheet2']).Delete;
			this.Sheets.Item(['Sheet3']).Delete;
		end

		% save the Active Workbook as 'filename'
		function saveAs(this,filename)
			this.Excel.ActiveWorkBook.SaveAs(filename);
		end

		% clone
		% if 'item' is a sheet, the sheet is cloned into the same workbook
		% if 'item' is a workbook, a new workbook is generated
		function clone(this,item)
			if( strcmpi( class( item ), class( this.Excel.ActiveWorkbook ) ) )
				workbook = this.Excel.Workbooks.Add;
				this.Workbooks = this.Excel.Workbooks;   

			elseif strcmpi( class( item ), class( this.Excel.ActiveSheet ) )
				sheet = this.addSheet( [ item.name  '-copy' ] );
				[c,r] = this.sheetSize(item);
				cells = this.getCells( item, [ 1, 1, c, r ] );
				this.setCells(sheet,[1,1],cells);
			end
		end

	end % methods

	methods (Static)

		% return the size of a worksheet
		% @param sheet { Interface.Microsoft_Excel_XX.X_Object_Library._Worksheet } - ActiveX pointer to an Excel worksheet
		% @return numcols { int } - the number of columns
		% @return numrows { int } - the number of rows
		function [numcols,numrows] = sheetSize(sheet)
			% TODO calc of numcols is a shitty hack; fix this
			numcols = sheet.Range('a1').End('xlToRight').End('xlToRight').End('xlToRight').End('xlToRight').Column;
			numrows = sheet.Range('a65536').End('xlUp').Row;
		end

		% return the row at param 'index'
		% @param sheet { Interface.Microsoft_Excel_XX.X_Object_Library._Worksheet } - ActiveX pointer to an Excel worksheet
		% @param index { int } - heightwise index of which row to select
		function cells = getRow(sheet,index)
			[numcols,~] = size(sheet);
			cells = sheet.Range(strcat('A', num2str(index),':', upper(Units.hexavigesimal(numcols)),num2str(index)));
		end

		% set the cell range starting at the point passed in param 'position'
		% @param sheet { Interface.Microsoft_Excel_XX.X_Object_Library._Worksheet } - ActiveX pointer to an Excel worksheet
		% @param position { array of length = 2 } - starting x,y location of where to place the data
		% @param data { cell or array } - values to write to the sheet
		% @param clr { string or int } - OPTIONAL color value to color the cell range, can be either (1.) color as a hexidecimal string like 'FFFFFF'
		% or (2.) as the boolean string value 'false', or (3.) an integer color representation like 16777215 (for 'FFFFFF').
		% @param autofit { * } - OPTIONAL boolean to be interpreted as whether or not to apply column width autofitting to the range. Can be anything but 'false', 
		% so long as it exists, but preferably the string 'true'.
		function range = setCells( sheet, position, data, clr, autofit )
			range = sheet.Range([ upper(Units.hexavigesimal(position(1))) num2str(position(2)) ':'  upper(Units.hexavigesimal(position(1) + size(data,2) - 1)) num2str(position(2) + size(data,1) -1) ]);
			range.Value = data;
			if exist('clr') % if the color is passed, color the range
				if isstr(clr) && ~strcmpi('false',clr)
					range.Interior.Color = hex2dec(clr);
				elseif isstr(clr) && strcmpi('false',clr)
					% do nothing
				else
					range.Interior.Color = clr;
				end	
			end
			if exist('autofit') && ~strcmpi('false',autofit)
				XL.autofit(range);
			end
		end

		% gets the values of 'sheet' from [ position(1), position(2) ], to [ position(3) position(4) ]
		% @param sheet { Interface.Microsoft_Excel_XX.X_Object_Library._Worksheet } - ActiveX pointer to an Excel worksheet
		% @param position { array of length = 4 } - range of cells to return in the format [ starting x,y, ending x,y ]
		function [ cells, range ] = getCells(sheet,position)
			range = sheet.Range([ upper(Units.hexavigesimal(position(1))) num2str(position(2)) ':'  upper(Units.hexavigesimal(position(1) + position(3) - 1)) num2str(position(2) + position(4) -1) ]);
			cells = range.Value;
		end

		% for each column in 'range', set the width of that column to the length (in characters) of the cell with the
		% largest number of characters.
		% @param range { Interface.Microsoft_Excel_XX.X_Object_Library.Range } - range of cells to autofit
		function autofit( range ) 
			for i = 1:range.Columns.Count
				col = range.Columns.Item(i);
				values = col.Value;
				if isstr( values ), values = { values }; end
				width = max( cellfun('length', values ) );
				col.ColumnWidth = width;
			end
		end

		% set or get the width of a specific column
		% @param sheet { Interface.Microsoft_Excel_XX.X_Object_Library._Worksheet } - ActiveX pointer to an Excel worksheet
		% @param index { string or int } - index of the columns of which to set the width
		% @paam width { int } - new width of the column ( OPTIONAL - if none is provided, the method will act as a getter ) 
		function w = columnWidth(sheet,index,width)
			if ( exist('index') && isstr(index) )
				if ( exist('width') )
					sheet.Columns.Item( Units.hexavigesimal(index) ).ColumnWidth = width;
					w = width;
				else % if no width is provided, act as a getter and return the ColumnWidth
					w = sheet.Columns.Item( Units.hexavigesimal(index) ).ColumnWidth;
				end
			elseif ( exist('index') && ~isstr(index) )
				if ( exist('width') )
					sheet.Columns.Item( index ).ColumnWidth = width;
					w = width;
				else % if no width is provided, act as a getter and return the ColumnWidth
					w = sheet.Columns.Item( index ).ColumnWidth;
				end
			end
		end

		% set the width of a range of columns
		% @param sheet { Interface.Microsoft_Excel_XX.X_Object_Library._Worksheet } - ActiveX pointer to an Excel worksheet
		% @param index { string or int } - index of the columns of which to set the width
		% @paam width { int } - new width of the column
		function width = columnsWidth(sheet,indices,width)
			for i=1:length(indices)
				if iscell(indices)
					XL.columnWidth(sheet,indices{i},width);
					continue;
				end
				XL.columnWidth(sheet,indices(i),width);
			end
		end

	end % static methods

end % XL