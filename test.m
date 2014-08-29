

edffile = 'D:\MAschmidt\Spont vs SD\NEF1958 F Tamoxifen SD 03_18_2014 with TTL Channel.edf';

edf = EdfHandle(edffile);

edf.sort(edf.MINUTE,10); % sort by 10min intervals

% retrieve the first 6 10 minutes intervals
eeg1 = edf.eeg1(1:6);
% eeg2 = edf.eeg2(1:6);
% emg = edf.emg(1:6);
% ttl = edf.ttl(1:6);

