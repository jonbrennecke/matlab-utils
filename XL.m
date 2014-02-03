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
		function this = XL

			% create a new ActiveX connection to Excel
			this.Excel = actxserver('Excel.Application');
			set(this.Excel, 'Visible', 1);

			% add a workbooks and an empty sheets object
			this.Workbooks = this.Excel.Workbooks;
			workbook.triggered = invoke(this.Workbooks, 'Add');
			this.Sheets = this.Excel.ActiveWorkBook.sheets;
			invoke(workbook.triggered,'Activate');

		end

		% add a single sheet to the active workbook
		% @return { Interface.Microsoft_Excel_14.0_Object_Library._Worksheet } - handle to the new sheet
		function sheet = addSheet(this,sheetname)
			sheet = invoke(this.Sheets,'Add');
			invoke(sheet, 'Activate');
			sheet.name = sheetname;
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

	end % methods

	methods (Static)

		% return the size of a worksheet
		function [numcols,numrows] = sheetSize(sheet)
		    numcols = sheet.Range('A1').End('xlToRight').Column;
		    numrows = sheet.Range('A1').End('xlDown').Row;
		end

		% return the row at param 'index'
		function cells = getRow(sheet,index)
		    [numcols,~] = size(sheet);
		    cells = sheet.Range(strcat('A',num2str(index),':',upper(Units.hexavigesimal(numcols)),num2str(index)));
		end

		% set the cell range starting at the point passed in param 'position'
		function setCells(sheet,position,data)
		    range = sheet.Range([ upper(Units.hexavigesimal(position(1))) num2str(position(2)) ':'  upper(Units.hexavigesimal(position(1) + size(data,2) - 1)) num2str(position(2) + size(data,1) -1) ]);
		    set(range, 'Value', data);
		end

	end % static methods

end % XL