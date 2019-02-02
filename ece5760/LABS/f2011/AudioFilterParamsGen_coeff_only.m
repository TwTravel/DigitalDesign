%18-bit, 16-bit fraction,  2's comp conversion
clear all
figure(1);clf;
clc

%For lowpass or highpass, set equal to normalized Freq (cutoff/(Fs/2))
%For bandpass, set equal to normalized Freq vector ([low high]/(Fs/2))
% freq = [0.03] ; LOW PASS
freq = [0.021 0.06]; % BAND PASS

%Filter order:
%    use 2 lowpass 
%        1 for bandpass
%NOTE that for a bandpass filter (order) poles are generated for the high
%and low cutoffs, so the total order is (order)*2
order = 1;

%could also use butter, or cheby1 or cheby2 or besself
% but note that besself is lowpass only!
[b, a] = butter(order, freq) ;
%[b, a] = cheby1(order, 0.1, freq) ;
%[b, a] = besself(order, freq) ;
b = b ;
a = -a;

for i=1:length(b)
    if b(i)>=0
        fprintf('     b%1d (18''h%s) \n', i, dec2hex(fix(2^16*b(i)))) ;
    else
        fprintf('     b%1d (18''h%s) \n', i, dec2hex(bitcmp(fix(2^16*-b(i)),18)+1));
    end
end

for i=2:length(a)
    if a(i)>=0
        fprintf('     a%1d (18''h%s) \n', i, dec2hex(fix(2^16*a(i))))
    else
        fprintf('     a%1d (18''h%s) \n', i,dec2hex(bitcmp(fix(2^16*-a(i)),18)+1))
    end
end


disp(' ')
disp('CHECK scaling! all b''s and a''s <2 absolute value?') 
disp('BUT as big as possible?')
b
a

%sampling rate on DE2 board
Fs = 48000;
[b,a] = butter(order, freq) ;
[fresponse, ffreq] = freqz(b,a,300);
plot(ffreq/pi*Fs/2,abs(fresponse), 'b', 'linewidth',2);
xlabel('frequency'); ylabel('filter amplitude');
hold on
b = fix((b)*2^16) ;
a = fix((a)*2^16) ;
[fresponse, ffreq] = freqz(b,a,300);
plot(ffreq/pi*Fs/2,abs(fresponse), 'r', 'linewidth',2);
legend('exact','scaled 16-bit')



