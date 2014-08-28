

edffile = 'D:\MAschmidt\Spont vs SD\NEF1958 F Tamoxifen SD 03_18_2014 with TTL Channel.edf';


edf = EdfHandle(edffile);

edf.sort(edf.MINUTE,10); % sort by 10min intervals

x = edf.eeg1(1:6); % retrieve the first 6 10 minutes intervals

