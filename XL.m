%
% An object-oriented handler for an Excel ActiveX object
%
% by @jonbrennecke / https://github.com/jonbrennecke
%
% Released under the MIT license (see the accompanying LICENSE.txt)
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
		% @return { COM.Excel_Application } : handle to the ActiveX object
		function this = XL( filename )

			% if XL is passed a filename, then create try to find an instance of Excel
			% with the given name
			if exist('filename')
				this.Excel = actxGetRunningServer('Excel.Application');
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

	end % methods

	methods (Static)

		% return the size of a worksheet
		function [numcols,numrows] = sheetSize(sheet)
			% TODO calc of numcols is a shitty hack; fix this
		    numcols = sheet.Range('a1').End('xlToRight').End('xlToRight').End('xlToRight').Column;
		    numrows = sheet.Range('a65536').End('xlUp').Row;
		end

		% return the row at param 'index'
		function cells = getRow(sheet,index)
		    [numcols,~] = size(sheet);
		    cells = sheet.Range(strcat('A',num2str(index),':',upper(Units.hexavigesimal(numcols)),num2str(index)));
		end

		% set the cell range starting at the point passed in param 'position'
		function setCells(sheet,position,data,clr)
		    range = sheet.Range([ upper(Units.hexavigesimal(position(1))) num2str(position(2)) ':'  upper(Units.hexavigesimal(position(1) + size(data,2) - 1)) num2str(position(2) + size(data,1) -1) ]);
		    set(range, 'Value', data);
		    if exist('clr') % if the color is passed, color the range
		    	range.Interior.Color = clr;
		    end
		end

		% gets the values of 'sheet' from [ position(1), position(2) ], to [ position(3) position(4) ]
		function cells = getCells(sheet,position)
			range = sheet.Range([ upper(Units.hexavigesimal(position(1))) num2str(position(2)) ':'  upper(Units.hexavigesimal(position(1) + position(3) - 1)) num2str(position(2) + position(4) -1) ]);
			cells = range.Value;
		end

	end % static methods

end % XL