


% edffile = 'D:\MAschmidt\Floxed files for John\NEF1526 M Tamoxifen 10turns 04_09_2013 with TTL Channel.edf';
edffile = 'D:\MAschmidt\ICV Bilateral Injections\NEF2124 Day1 SD 07_28_2014 with TTL Channel.edf';
% edffile = 'D:\MAschmidt\Spont vs SD\NEF1958 F Tamoxifen SD 03_18_2014 with TTL Channel.edf';

edf = EdfHandle(edffile);

edf.sort(edf.MINUTE,10); % sort by 10min intervals

% retrieve the first n 10 minutes intervals
eeg1 = edf.eeg1(6:10);
% eeg2 = edf.eeg2(1:6);
% emg = edf.emg(1:6);
[ttl,ttl_times] = edf.ttl(6:10);% add support for 'end'

% xl = XL;
% for i=1:length(ttl_times)
% 	tab_names{i} = ttl_times{i}.str('HH_MM');
% 	xl.addSheet(tab_names{i}{1,1});
% end
% xl.rmDefaultSheets();

% start_times = ttl_times.str('HH:MM');

% xl = XL;
% sheet = xl.addSheet()
% xl.rmDefaultSheets()

idx = find(diff(ttl(1,:))==1);

% milliseconds before and after
ms_before = 500;
ms_after = 500;

% samples before and after
samples_before = (ms_before*edf.MILLI*edf.ttl.fs);
samples_after = (ms_beforafter*edf.MILLI*edf.ttl.fs);


% eeg1(1,idx)
% % resort the EDF
% edf.sort(edf.MILLI,1);

% % select an area of [ms_before,ms_after] around each index in idx
% edf.eeg1.area(idx,ms_before,ms_after)
