% IIR header test pgm

% at Fs=48kHz normalized F=1 at 24kHz
Fs_half = 24000 ;
F = 300/Fs_half;
BW = 100/Fs_half;
[b,a] = butter(1,[F-(BW/2), F+(BW/2)] );
a = -a ; % makes it easier to use an MAC
disp(' ')
fprintf('//Filter: frequency=%f \n',F(1))
fprintf('//Filter: BW=%f \n',BW(1))
sorder = 2;
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