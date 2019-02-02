%% Radix-4 in MATLAB
% Adrian Wong
% November 5, 2007
clear;
% Configuration
bits = 3;
verilog = 2;
windowing = 1;

%% Test Signal Generation
FLEN = 4^bits - 1;
t = 0:FLEN;
signal = .5*sin(2*pi*0.15*(t+2)) + .5*sin(2*pi*0.16*(t+2));
load handel
signal = y(t+1)';

if (windowing)
    signal = signal .* kaiser(4^bits)';
end

% 64-point: 45 multipliers per stage, 3 stages
%% Test Signal
t = 0:FLEN;
x = signal;
n = length(x);
t = log(n)/log(4);

%% Radix-4 butterfly
for q = 1:t
    fprintf(1,'\n --- FFT STAGE %d ---\n',q)
    unitnum = 0;
    L = 4^q;
    r = n/L;
    Lx = L/4;
    rx = 4*r;
    y = x;
    for j = 0:Lx-1
        for k = 0:r-1
            W = [1 exp(-i*2*pi*j/L) exp(-i*2*pi*2*j/L) exp(-i*2*pi*3*j/L)];

            a = y(j*rx + k + 1);
            b = y(j*rx + r + k + 1);
            c = y(j*rx + 2*r + k + 1);
            d = y(j*rx + 3*r + k + 1);
            
            r4fft = r4butterfly(W, [a;b;c;d]);

            x(j*r + k + 1) = r4fft(1);
            x((j + Lx)*r + k + 1) = r4fft(4);
            x((j + 2*Lx)*r + k + 1) = r4fft(3);
            x((j + 3*Lx)*r + k + 1) = r4fft(2);
            
            %% Generate Verilog
            if (verilog == 1)
                fprintf('\nr4butterfly dft%d%d\t(',q,unitnum);
                unitnum = unitnum+1;
                
                for mindex = 2:length(W)
                    fprintf('18''h%s, ', dec2hex(signbitfrac(real(W(mindex)))));
                    fprintf('18''h%s, ', dec2hex(signbitfrac(imag(W(mindex)))));
                end

                fprintf('\n\t\t\t\t\t signal_%d_R[%d], signal_%d_C[%d],', q, j*rx + k, q, j*rx + k);
                fprintf('\n\t\t\t\t\t signal_%d_R[%d], signal_%d_C[%d],', q, j*rx + r + k, q,j*rx + r + k);
                fprintf('\n\t\t\t\t\t signal_%d_R[%d], signal_%d_C[%d],', q, j*rx + 2*r + k,q, j*rx + 2*r + k);
                fprintf('\n\t\t\t\t\t signal_%d_R[%d], signal_%d_C[%d],', q, j*rx + 3*r + k,q, j*rx + 3*r + k);

                fprintf('\n\t\t\t\t\t signal_%d_R[%d], signal_%d_C[%d],', q+1, j*r + k, q+1,j*r + k);
                fprintf('\n\t\t\t\t\t signal_%d_R[%d], signal_%d_C[%d],', q+1, (j + Lx)*r + k,q+1, (j + Lx)*r + k);
                fprintf('\n\t\t\t\t\t signal_%d_R[%d], signal_%d_C[%d],', q+1, (j + 2*Lx)*r + k,q+1, (j + 2*Lx)*r + k);
                fprintf('\n\t\t\t\t\t signal_%d_R[%d], signal_%d_C[%d]',  q+1, (j + 3*Lx)*r + k,q+1, (j + 3*Lx)*r + k);

                disp(');');
            end
            
                        %% Generate Verilog
            if (verilog == 2)
                fprintf('\nButterfly %d %d\t(',q,unitnum);
                unitnum = unitnum+1;
%                fprintf('\n %d', W);
                fprintf('\n %d %d %d %d',j*rx + k, j*rx + r + k, j*rx + 2*r + k, j*rx + 3*r + k);
                fprintf('\n %d %d %d %d',j*r + k, (j + Lx)*r + k, (j + 2*Lx)*r + k, (j + 3*Lx)*r + k);

                disp(');');
            end
        end
    end
end
r4 = x;

if (verilog)
    multipliers = ((4^bits / 4) - 1) * 2 * log(4^bits)/log(4)
end

%% Display stuff
plot(abs(fft(signal)),'r-');
hold on;
plot(abs(r4),'g-.')
hold on;
