% IIR header test pgm

% at Fs=48kHz normalized F=1 at 24kHz
Fs_half = 24000 ;
F = 4100/Fs_half;
sorder = 2;
[b,a] = cheby1(sorder,10, F); %4100 10
%[b,a] = butter(sorder, F);
%[b,a] = butter(sorder, 4000/Fs_half);
[h1,w1] = freqz(b, a, 5000, Fs);

a = -a ; % makes it easier to use an MAC
disp(' ')
fprintf('//Filter: frequency=%f \n',F)
scstr = 'IIR2_18bit_fixed filter(';

fprintf('%s \n',scstr); 
fprintf('     .audio_out (your_out), \n')
fprintf('     .audio_in (your_in), \n')
for i=1:length(b)
    if b(i)>=0
        fprintf('     .b%1d (18''sd%d), \n', i,fix(2^16*b(i)) ) ;
    else
        fprintf('     .b%1d (-18''sd%d), \n', i, fix(-2^16*b(i)) );
    end
end

for i=2:length(a)
    if a(i)>=0
        fprintf('     .a%1d (18''sd%d), \n', i, fix(2^16*a(i)) )
    else
        fprintf('     .a%1d (-18''sd%d), \n', i, fix(-2^16*a(i)) )
    end
end
fprintf('     .state_clk(CLOCK_50), \n');
fprintf('     .audio_input_ready(audio_input_ready), \n');
fprintf('     .reset(reset) \n');
fprintf(') ; //end filter \n');

disp(' ')

figure(1); clf;

[b,a] = butter(sorder, 1700/Fs_half); %1700
%[b,a] = cheby1(sorder,4, 4200/Fs_half);
[h2,w2] = freqz(b, a, 5000, Fs);

[b,a] = butter(sorder, 3100/Fs_half); %2000
%[b,a] = cheby1(sorder,4, 4200/Fs_half);
[h3,w3] = freqz(b, a, 5000, Fs);

plot(w,abs(h1).*abs(h2) ,'b', 'linewidth',1)
set(gca, 'xlim', [0 10000]);