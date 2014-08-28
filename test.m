
% txtfile = '~/Desktop/txt/NEF1958 F Tamoxifen Baseline 03_20_2014 0.5-40.txt';
% txtdoc = txt(txtfile);
% times = txtdoc.times;
% txtdoc.sort(txt.MINUTE,1);


edffile = '~/Desktop/edf/NEF1958 F Tamoxifen SD 03_18_2014 with TTL Channel.edf';
edf = EDF(edffile);


% sorted_times = 

edf.sort(edf.MINUTE,10);

