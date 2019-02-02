%18-bit, floating point
clear all
clc

%For lowpass, set equal to normalized Freq (cutoff/(Fs/2))
%For bandpass, set equal to normalized Freq vector ([low high]/(Fs/2))
freq = [0.2 0.4] ;
%Filter order:
%    use 2,4 for lowpass 
%        1,2 for bandpass
%NOTE that for a bandpass filter (order) poles are generated for the high
%and low cutoffs, so the total order is (order)*2
order = 3;

%could also use butter, or cheby1 or cheby2 or besself
% but note that besself is lowpass only!
[b, a] = butter(order, freq) ;
%[b, a] = cheby1(order, 0.1, freq) ;
%[b, a] = besself(order, freq) ;
b = b ;
% negate 'a' so that can use all adds in Verilog code
a = -a ;

disp(' ')
fprintf('//Filter: cutoff=%f \n',freq)
sorder = order*length(freq);
if sorder==2
    scstr = 'IIR2 filter(';
elseif sorder==4
    scstr = 'IIR4 filter('; 
elseif sorder==6
    scstr = 'IIR6 filter('; 
else
    error('order*length(freq) must equal 2 4 or 6')
end
fprintf('%s \n',scstr); 
fprintf('     .audio_out (your_out), \n')
fprintf('     .audio_in (your_in), \n')

for i=1:length(b)
    fprintf('     .b%1d (18''h%s), \n', i, dec2hex(FPconvertFun(b(i)) )) ;
end

for i=2:length(a)
    fprintf('     .a%1d (18''h%s), \n', i, dec2hex(FPconvertFun(a(i)) ));
end

fprintf('     .state_clk(AUD_CTRL_CLK), \n');
fprintf('     .lr_clk(AUD_DACLRCK), \n');
fprintf('     .reset(reset) \n');
fprintf(') ; //end filter \n');

%sampling rate on DE2 board
% Fs = 48000;
% [b,a] = butter(order, freq) ;
% [fresponse, ffreq] = freqz(b,a,300);
% plot(ffreq/pi*Fs/2,abs(fresponse), 'b', 'linewidth',2);
% xlabel('frequency'); ylabel('filter amplitude');
% hold on
% b = fix(b*2^16) ;
% a = fix(a*2^16) ;
% [fresponse, ffreq] = freqz(b,a,300);
% plot(ffreq/pi*Fs/2,abs(fresponse), 'r', 'linewidth',2);
% legend('exact','scaled 16-bit')
% return
% f = [2000 2500 3000 4000 5000 7000 ];
% amp=[160/340 280/320 304/304 264/272 152/256 9/63];
% h = plot(f,amp,'ro');
% set(h,'markersize',5,'markerfacecolor','r')
% set(gca,'ylim',[0 1.05], 'xlim', [0 10000])


