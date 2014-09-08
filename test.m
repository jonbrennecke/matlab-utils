
const = struct( ...
	'nturns',10 ...
);


% open an EDF file
edffile = 'D:\MAschmidt\ICV Bilateral Injections\NEF2244 Day1 08_11_2014 with TTL Channel.edf';
% edffile = 'D:\MAschmidt\Spont vs SD\NEF1958 F Tamoxifen SD 03_18_2014 with TTL Channel.edf';
edf = EdfHandle(edffile);

% sort by 10min intervals
edf.sort(edf.MINUTE,10);

% retrieve the first n 10 minutes intervals
eeg1 = edf.eeg1(1:10);
[ttl,ttl_times] = edf.ttl(1:10); % TODO add support for 'end'


% find each TTL onset
idx = find(diff(ttl)==1);

% milliseconds before and after
ms_before = 500;
ms_after = 500;

% samples before and after
samples_before = (ms_before*edf.MILLI*edf.ttl.fs);
samples_after = (ms_after*edf.MILLI*edf.ttl.fs);

% for each data point, find the surrounding area of [ms_before,ms_after] milliseconds
[x1,x2] = ndgrid(( idx(idx>200 & idx<(idx(end)-200)) - samples_before),1:(samples_before+samples_after));
eeg1_tmp = eeg1';
eeg1_traces = eeg1_tmp(x1+x2);
% ttl_traces = ttl(x1+x2);

% find the average of each [ms_before,ms_after] area
averages = mean(eeg1_traces);
% plot(averages);figure(gcf);


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% output to Excel
% 
% Output in 2 workbooks "Pre Stim" and "Stim"
%
% Each workbook has 5 sheets labelled "0 Turns", "2 Turns", "4 Turns", ... "10 Turns"
% 
% The "turns" are incremented by 2 every 10 min, so that the data from each consecutive 10 min interval goes into 
% a different sheet.
%
% Furthermore, the data from 8:30 to 10:30 goes into the "Pre Stim" workbook, while the data from 10:30 to 2:30 goes into 
% the "Stim" workbook.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% sheets with the name "n Turns"
% sheetnames = arrayfun(@(i)[num2str(i) ' Turns'],0:2:const.nturns+1,'uni',0);

% xl = XL;
% for i=1:length(sheetnames)
	
% 	xl.addSheet(sheetnames{i});

% 	% tab_names{i} = ttl_times{i}.str('HH_MM');
% 	% xl.addSheet(tab_names{i}{1,1});
% end
% xl.rmDefaultSheets();

% xl.setCells(xl.Sheets.Item(1),[1,1],averages)

% start_times = ttl_times.str('HH:MM');

% xl = XL;
% sheet = xl.addSheet()
% xl.rmDefaultSheets()



% eeg1(1,idx)
% % resort the EDF
% edf.sort(edf.MILLI,1);

% % select an area of [ms_before,ms_after] around each index in idx
% edf.eeg1.area(idx,ms_before,ms_after)
