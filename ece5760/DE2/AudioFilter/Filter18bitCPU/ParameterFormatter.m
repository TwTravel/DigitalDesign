%18-bit, 16-bit fraction,  2's comp conversion
% for assembler version of filtering
clear all

clc

%The scale has to be adjusted so that filter coefficients are
% -1.0<coeff<1.0
%Scaling performed is 2^(-scale)
scale = 2;
%For lowpass, set equal to normalized Freq (cutoff/(Fs/2))
%For bandpass, set equal to normalized Freq vector ([low high]/(Fs/2))
freq = [0.05  0.1] ;
%Filter order:
%    use 2,4 for lowpass 
%        1,2 for bandpass
%NOTE that for a bandpass filter (order) poles are generated for the high
%and low cutoffs, so the total order is (order)*2
order =2;

%could also use butter, or cheby1 or cheby2 or besself
% but note that besself is lowpass only!
[b, a] = butter(order, freq) ;
%[b, a] = cheby1(order, 0.1, freq) ;
%[b, a] = besself(order, freq) ;
b = b * (2^-scale) ;
a = -a * (2^-scale) ;

disp(' ')
fprintf('; Filter: cutoff=%f \n',freq)
orderstr = order*length(freq);
if orderstr==2
    scstr = 'IIR2 filter(';
elseif orderstr==4
    scstr = 'IIR4 filter('; 
elseif orderstr==6
    scstr = 'IIR6 filter('; 
else
    error('order*length(freq) must equal 2 4 or 6')
end
%fprintf('%s \n',scstr); 
%fprintf('     .audio_out (your_out), \n')
%fprintf('     .audio_in (your_in), \n')
fprintf('; data section \n') ;
fprintf('\tscale\t1\t%1d \n',scale)
fprintf('\tsum \t1 \t0 \n');
% print: parameter name, '1', value in hex
for i=1:length(b)
    if b(i)>=0
        fprintf('\tb%1d \t1 \t%s \n', i, dec2hex(fix(2^16*b(i)))) ;
    else
        fprintf('\tb%1d \t1 \t%s \n', i, dec2hex(bitcmp(fix(2^16*-b(i)),18)+1));
    end
end

for i=2:length(a)
    if a(i)>=0
        fprintf('\ta%1d \t1 \t%s \n', i, dec2hex(fix(2^16*a(i))))
    else
        fprintf('\ta%1d \t1 \t%s \n', i,dec2hex(bitcmp(fix(2^16*-a(i)),18)+1))
    end
end

for i=2:length(b)
   fprintf('\tx%1d \t1 \t0 \n',i);
end
for i=2:length(a)
   fprintf('\ty%1d \t1 \t0 \n',i);
end

fprintf('; end data section')

disp(' ')
disp('CHECK scaling! all b''s and a''s <1 absolute value?') 
disp('BUT as big as possible?')
b
a

%sampling rate on DE2 board
Fs = 47000;
[b,a] = butter(order, freq) ;
figure(1);clf;
[fresponse, ffreq] = freqz(b,a,300);
plot(ffreq/pi*Fs/2,abs(fresponse), 'b', 'linewidth',2);
xlabel('frequency'); ylabel('filter amplitude');
hold on
b = fix((b*(2^-scale))*2^16) 
a = fix((a*(2^-scale))*2^16) 
[fresponse, ffreq] = freqz(b,a,300);
plot(ffreq/pi*Fs/2,abs(fresponse), 'r', 'linewidth',2);
legend('exact','scaled 16-bit')
