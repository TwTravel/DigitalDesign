%% Bandpass Filter Generation

% Clear variables
clear all
clf;
clc;

% Setup the figure.
figure(1);

% Setup the variables
bins = 32;          % Frequency bins
fstart = 0.05;      % Start frequency
fend = 0.95;        % End frequency
verilog = 0;        % Set to 1 to generate Verilog
pbrip = .5;         % Pass band ripple
sbrip = 30;         % Stop band rejection

counter = 0;        % Verilog index number

% For each frequency bin
for k = fstart:(fend-fstart)/bins:fend-(fend-fstart)/bins
    % Scale fails by default
    fail = 1;
    scale = 1;

    while (fail == 1)
        %The scale has to be adjusted so that filter coefficients are
        % -1.0<coeff<1.0
        %Scaling performed is 2^(-scale)
        
        %For lowpass, set equal to normalized Freq (cutoff/(Fs/2))
        %For bandpass, set equal to normalized Freq vector ([low high]/(Fs/2))
        freq = [k k+(fend-fstart)/(2*bins)];
        
        %Filter order:
        %    use 2,4 for lowpass
        %        1,2 for bandpass
        %NOTE that for a bandpass filter (order) poles are generated for the high
        %and low cutoffs, so the total order is (order)*2
        order = 2;

        %could also use butter, or cheby1 or cheby2 or besself
        % but note that besself is lowpass only!
        [b a] = ellip(order,pbrip,sbrip, freq);

        b = b * (2^-scale) ;
        a = -a * (2^-scale) ;

        % Keep increasing scale until coeffs are safe
        if(sum(abs(b) >= 1) | sum(abs(a) >= 1))
            fail = 1;
            scale = scale + 1;
            if (verilog == 0)
                fprintf('\nRetrying %f with new scale factor %d', k, scale);
            end
        else
            fail = 0;
        end
    end

    ordera = order*length(freq);
    if ordera==2
        scstr = 'IIR2 filter';
    elseif ordera==4
        scstr = 'IIR4 filter';
    else
        error('order*length(freq) must equal 2 or 4')
    end

    % Generate Verilog code if requested.
    if (verilog)
        disp(' ')
        fprintf('//Filter: cutoff=%f \n',freq)
        fprintf('%s%d (\n',scstr, counter);
        fprintf('     .audio_out (filter%d_out), \n',counter)
        fprintf('     .audio_in (adc_sample), \n')
        fprintf('     .scale (3''d%1d), \n', scale)
        for i=1:length(b)
            if b(i)>=0
                fprintf('     .b%1d (18''h%s), \n', i, dec2hex(fix(2^16*b(i)))) ;
            else
                fprintf('     .b%1d (18''h%s), \n', i, dec2hex(bitcmp(fix(2^16*-b(i)),18)+1));
            end
        end

        for i=2:length(a)
            if a(i)>=0
                fprintf('     .a%1d (18''h%s), \n', i, dec2hex(fix(2^16*a(i))));
            else
                fprintf('     .a%1d (18''h%s), \n', i,dec2hex(bitcmp(fix(2^16*-a(i)),18)+1));
            end
        end

        fprintf('     .state_clk(AUD_CTRL_CLK), \n');
        fprintf('     .lr_clk(AUD_DACLRCK), \n');
        fprintf('     .reset(reset) \n');
        fprintf(') ; //end filter \n');

        counter = counter + 1;
    end

    %sampling rate on DE2 board
    Fs = 8000;

    [b a] = ellip(order,pbrip,sbrip, freq);

    [fresponse, ffreq] = freqz(b,a,1000);
    plot(ffreq/pi*Fs/2,abs(fresponse), 'b', 'linewidth',2);
    hold on

    b = fix((b*(2^-scale))*2^16)/2^16 ;
    a = fix((a*(2^-scale))*2^16)/2^16 ;

    [fresponse, ffreq] = freqz(b,a,1000);
    plot(ffreq/pi*Fs/2,abs(fresponse), 'r', 'linewidth',2);
end

% Wrap up the figure
xlabel('Frequency (Hz)'); ylabel('Filter Amplitude');
legend('exact','scaled 16-bit');