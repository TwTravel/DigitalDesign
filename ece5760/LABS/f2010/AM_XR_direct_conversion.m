% CIC testing
clear all

%==========================
%transmitter
%==========================
% This section is actually 3 transmitters on three different frequencies
% used to show selectivity of the receiver.
%
Fs = 1e4;
t= 0:1/Fs:1.0 ;
carrier1 = 1e3 ;
carrier2 = 1.2e3 ;
carrier3 = 800 ;
signal1 = 10 ;
signal2 = 20 ;
signal3 = 50 ;
% Transmitter 1
% modulate carrier1 with a sq-wave approximation
y = (0.5 * sin(2*pi*signal1*t) + .166 * sin(2*pi*signal1*3*t) + 0.6) ...
		.* sin(2*pi*carrier1*t) ;
    
% Transmitter 2
% modulate carrier2 with a sine and add 
%to make  'two transmitter' signal		
y = y + (0.5 * sin(2*pi*signal2*t) + 0.6) ...
		.* sin(2*pi*carrier2*t) ;

% Transmitter 3    
% modulate carrier3 with a sine and add 
%to make  'three transmitter' signal			
y = y + (0.5 * sin(2*pi*signal3*t) + 0.6) ...
		.* sin(2*pi*carrier3*t) ;
		
% add noise?
y = y + 0.0* randn(size(t)) ;
figure(3);clf;
plot(abs(fft(y)))
set(gca, 'xlim', [600 1400])
title('Transmitted spectrum: Three separate AM signals')

%==========================	
%receiver
%==========================
% Change THIS to TUNE receiver, 
% tune to carrier 
local_osc_freq = 1000 ;  % tuned to station at carrier2
%now do the mixing operation
signal_baseband = y .* (sin(2 * pi * local_osc_freq * t)) ;
figure(1);clf
subplot(3,1,1)
plot(abs(fft(signal_baseband)))
set(gca,'xlim', [0 length(signal_baseband)/2])
title('baseband before filtering')

% downconvert to audio rate: lowpass and decimate
% needed a second order CIC to make a sharper filter
nAudio = 50; % baseband decimation ratio
t_decimated = 0:1/Fs*nAudio:1.0 ; % needed for plotting

%CIC lowpass and decimate
int1 = 0; comb1 = 0;
int2 = 0; comb2 = [];
last_comb1 = 0 ;
j = 1 ;
downsample_now = 0 ;
% use a second order CIC
for i=2:length(signal_baseband)
  int1 = int1 + signal_baseband(i) ;
  int2 = int2 + int1 ;
  if (mod(i,nAudio)==0)
    downsample_then = downsample_now ;
    downsample_now = int2;
    last_comb1 = comb1 ;
    comb1 = downsample_now - downsample_then ;
    comb2(j) = comb1 - last_comb1 ;
    j = j + 1 ;
  end
end

% CIC compensator
[b,a] = cheby1(2, 4, 0.4);
out = filter(b,a,comb2) ;

% first order high pass
% to strip off carrier at DC
Tau_over_dt = 70;
f = Tau_over_dt/(1+Tau_over_dt) ;
audio_out = filter([f, -f], [1, -f], out);

% now plot the tuned spectrum and signal

subplot(3,1,2)
plot(abs(fft(audio_out)))
set(gca,'xlim', [0 length(audio_out)/2])
title(['Receiver output: tuned to', num2str(local_osc_freq) ])
subplot(3,1,3)
plot(t_decimated(1:end-1), audio_out)
