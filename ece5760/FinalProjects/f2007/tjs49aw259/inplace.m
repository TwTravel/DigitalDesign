%% Radix-4 in MATLAB
% Adrian Wong
% Portions from Tom Wada of the Univ. of the Ryukyus, Okinawa, Japan
% November 5, 2007

clear;
% Configuration
bits = 3;
verilog = 0;
windowing = 0;

%% Test Signal Generation
N = 4^bits;
t = 0:N-1;
signal = .5*sin(2*pi*.15*(t)) + .5*sin(2*pi*0.6*(t));
%load handel
%signal = 1.*t;
t = -1:0.001:1;              % +/-1 second @ 1kHz sample rate
fo = 100; f1 = 400;          % Start at 100Hz, go up to 400Hz
y = chirp(t,fo,1,f1,'q',[],'convex');
signal = y(1:64);

if (windowing)
    signal = signal .* kaiser(4^bits)';
end

% 64-point: 45 multipliers per stage, 3 stages

y  = zeros(64,1);
counter = 0;

if (verilog == 2)
    fprintf('\nDEPTH = 64;');
    fprintf('\nWIDTH = 108;');
    fprintf('\nADDRESS_RADIX = DEC;');
    fprintf('\nDATA_RADIX = BIN;');
    fprintf('\nCONTENT BEGIN');
end
if (verilog == 3)
    fprintf('\nDEPTH = 64;');
    fprintf('\nWIDTH = 24;');
    fprintf('\nADDRESS_RADIX = DEC;');
    fprintf('\nDATA_RADIX = BIN;');
    fprintf('\nCONTENT BEGIN');
end
% stage 1
for mm = 0:1:15
    W = exp(-2*pi*j*mm*1/64.*[0 1 2 3]);
    x([1 17 33 49] + mm) = radix4dft(x([1 17 33 49] + mm)).*W.';
    counter = counter + 1;
    if (verilog == 1)
        fprintf('\n\nradix4dft r4dft%d(', counter);
        
        for mindex = 2:length(W)
            fprintf('18''h%s, ', dec2hex(signbitfrac(real(W(mindex)))));
            fprintf('18''h%s, ', dec2hex(signbitfrac(imag(W(mindex)))));
        end;
        fprintf('\nstage1_%d_r, stage1_%d_r, stage1_%d_r, stage1_%d_r,', [1 17 33 49] + mm);
        fprintf('\nstage1_%d_c, stage1_%d_c, stage1_%d_c, stage1_%d_c,', [1 17 33 49] + mm);
        fprintf('\nstage2_%d_r, stage2_%d_r, stage2_%d_r, stage2_%d_r,', [1 17 33 49] + mm);
        fprintf('\nstage2_%d_c, stage2_%d_c, stage2_%d_c, stage2_%d_c', [1 17 33 49] + mm);
        fprintf(');');
    end;
    
    if (verilog == 2)
        fprintf('\n%d\t:\t',counter-1);
        for mindex = 2:length(W)
            fprintf('%s', dec2bin(signbitfrac(real(W(mindex))),18));
            fprintf('%s', dec2bin(signbitfrac(imag(W(mindex))),18));
        end;
        fprintf(';');
    end;
    
	for mindex = 2:length(W)
        disp([(real(W(mindex))) (imag(W(mindex)))])
    end
    if (verilog == 3)
        fprintf('\n%d\t:\t%s;',counter-1,dec2bin([1 17 33 49] + mm - 1,6)')
    end
end;

x = x./2;

% stage 2
for nn = 0:16:48
    for mm = 0:1:3
        W = exp(-2*pi*j*mm*4/64.*[0 1 2 3]);
        x([1 5 9 13] + (mm + nn)) = radix4dft(x([1 5 9 13] + (mm + nn))).*W.';
            counter = counter + 1;
        if (verilog == 1)
            fprintf('\n\nradix4dft r4dft%d(', counter);

            for mindex = 2:length(W)
                fprintf('18''h%s, ', dec2hex(signbitfrac(real(W(mindex)))));
                fprintf('18''h%s, ', dec2hex(signbitfrac(imag(W(mindex)))));
            end;
            fprintf('\nstage2_%d_r, stage2_%d_r, stage2_%d_r, stage2_%d_r,', [1 5 9 13] + mm + nn);
            fprintf('\nstage2_%d_c, stage2_%d_c, stage2_%d_c, stage2_%d_c,', [1 5 9 13] + mm + nn);
            fprintf('\nstage3_%d_r, stage3_%d_r, stage3_%d_r, stage3_%d_r,', [1 5 9 13] + mm + nn);
            fprintf('\nstage3_%d_c, stage3_%d_c, stage3_%d_c, stage3_%d_c', [1 5 9 13] + mm + nn);
            fprintf(');');
        end
        
        if (verilog == 2)
            fprintf('\n%d\t:\t',counter-1);
            for mindex = 2:length(W)
                fprintf('%s', dec2bin(signbitfrac(real(W(mindex))),18));
                fprintf('%s', dec2bin(signbitfrac(imag(W(mindex))),18));
            end;
            fprintf(';');
        end;
        
        if (verilog == 3)
            fprintf('\n%d\t:\t%s;',counter-1,dec2bin([1 5 9 13] + mm + nn - 1,6)')
        end
    end;
end;

x = x./2;


% stage 3
for nn = 0:4:60
    W = exp(-2*pi*j*mm*64/64.*[0 1 2 3]);
    x([1 2 3 4] + nn) = radix4dft(x([1 2 3 4] + nn)).*W.';
    counter = counter + 1;
    if (verilog == 1)
        fprintf('\n\nradix4dft r4dft%d(', counter);

        fprintf('\n');
        for mindex = 2:length(W)
            fprintf('18''h%s, ', dec2hex(signbitfrac(real(W(mindex)))));
            fprintf('18''h%s, ', dec2hex(signbitfrac(imag(W(mindex)))));
        end;
        fprintf('\nstage3_%d_r, stage3_%d_r, stage3_%d_r, stage3_%d_r,', [1 2 3 4] + nn);
        fprintf('\nstage3_%d_c, stage3_%d_c, stage3_%d_c, stage3_%d_c,', [1 2 3 4] + nn);
        fprintf('\nstage4_%d_r, stage4_%d_r, stage4_%d_r, stage4_%d_r,', [1 2 3 4] + nn);
        fprintf('\nstage4_%d_c, stage4_%d_c, stage4_%d_c, stage4_%d_c', [1 2 3 4] + nn);
        
        fprintf(');');
    end

    if (verilog == 2)
        fprintf('\n%d\t:\t',counter-1);
        for mindex = 2:length(W)
            fprintf('%s', dec2bin(signbitfrac(real(W(mindex))),18));
            fprintf('%s', dec2bin(signbitfrac(imag(W(mindex))),18));
        end;
        fprintf(';');
    end;
    
    if (verilog == 3)
        fprintf('\n%d\t:\t%s;',counter-1,dec2bin([1 2 3 4] + nn - 1,6)');
    end
end;

x = x./2;

%%
if (1 == 1)
    fprintf('\n// Reorder\n');
    % reorder
    for n2 = 0:3
        for n1 = 0:3
            for n0 = 0:3
                if (16*n0+4*n1+n2+1) <= 32
%                    fprintf('\n');
                else
%                    fprintf('\n// ');
                end
                % fprintf('freqnormal fnom%d (stage4_%d_r, stage4_%d_c, freq_%d);', 16*n2+4*n1+n0+1, 16*n2+4*n1+n0+1, 16*n2+4*n1+n0+1, 16*n0+4*n1+n2+1);
%                fprintf('freq: %s\n',dec2bin([16*n0+4*n1+n2],6)')
%                fprintf('addr: %s\n\n',dec2bin([16*n2+4*n1+n0],6)')
                y(16*n0+4*n1+n2+1)=x(16*n2+4*n1+n0+1);
            end;
        end;
    end;
end
%% Display stuff
%close all;
figure;
%plot(abs(fft(signal)),'r-');
hold on;
plot(abs(y),'g-.')
hold on;