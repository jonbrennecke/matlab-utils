% ---------------------------------------- XL ----------------------------------------

% import the Excel module containing functions for working with Excel through an ActiveX connection
function xl = getXL
    xl.new = @newXL;
    xl.size = @sheetSize;
    xl.getRow = @getRow;
    xl.set = @setCells;
    xl.addSheet = @addSheet;
    xl.addSheets = @addSheets;
end

% create a new ActiveX connection to Excel
function [Excel,Workbooks,Sheets] = newXL
    Excel = actxserver('Excel.Application');
    set(Excel, 'Visible', 1);
    Workbooks = Excel.Workbooks;
    workbook.triggered = invoke(Workbooks, 'Add');
    Sheets = Excel.ActiveWorkBook.sheets;
    invoke(workbook.triggered,'Activate');
end

% add a single sheet to the active workbook
function sheet = addSheet(Excel,sheetname)
    Sheets = Excel.ActiveWorkBook.sheets;
    sheet = invoke(Sheets,'Add');
    invoke(sheet, 'Activate');
    sheet.name = sheetname;
end

% add multiple sheets to the active workbook
function sheets = addSheets(Excel,sheetnames)
    Sheets = Excel.ActiveWorkBook.sheets;
    for i=1:length(sheetnames)
        sheets{i} = addSheet(Excel,sheetnames{i});
    end
end

% return the size of a worksheet
function [numcols,numrows] = sheetSize(sheet)
    numcols = sheet.Range('A1').End('xlToRight').Column;
    numrows = sheet.Range('A1').End('xlDown').Row;
end

% return the row at param 'index'
function cells = getRow(sheet,index)
    [numcols,~] = size(sheet);
    cells = sheet.Range(strcat('A',num2str(index),':',upper(hexavigesimal(numcols)),num2str(index)));
end

% set the cell range starting at the point passed in param 'position'
function setCells(sheet,position,data)
    range = sheet.Range([ upper(hexavigesimal(position(1))) num2str(position(2)) ':'  upper(hexavigesimal(position(1) + size(data,2) - 1)) num2str(position(2) + size(data,1) -1) ]);
    set(range, 'Value', data);
end
