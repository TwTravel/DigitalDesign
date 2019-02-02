

% test 60 Hz canceller
clear all

Fs = 44100;
dt = 1/Fs;
t = 0:dt:20;

%reference noise
ref = sin(2*pi*60*t)  + 0.2*sin(2*pi*120*t) + 0.2*sin(2*pi*180*t)  ;

%define APs
AP1amp = 1;
AP1dur1 = .001;
AP1dur2 = .002;
AP1prob = .001;
AP2amp = AP1amp*.5;

%make single AP
%by concantenating two 1/2 sin cycles
oneT = 0:dt:(AP1dur1+AP1dur2);
oneAP = AP1amp*sin(2*pi/(2*AP1dur1)*oneT).*(oneT<=AP1dur1) + ...
    AP1amp*0.5*sin(2*pi/(2*AP1dur2)*(oneT+AP1dur1)).*(oneT>AP1dur1) ;

%make a bunch of APs
locationAP1 = rand(size(t))<AP1prob; %poisson
%locationAP1 = mod([1:length(t)],457)==0; %uniform
vAP = conv(locationAP1,oneAP);
vAP = vAP(1:length(t)); %truncate
locationAP2 = rand(size(t))<AP1prob; %poisson
vAP2 = conv(locationAP2,oneAP*AP2amp);
vAP = vAP ;%+ vAP2(1:length(t)); %truncate
noisefree = vAP+ 0.00*randn(size(t));
ph = 0.75;
sig = noisefree +0.5*( sin(2*pi*60*t+ph)+ .2*sin(2*pi*120*t +ph) + .2*sin(2*pi*180*t +ph)) ;


% Stereo sound is played on platforms that support
% it when y is an n-by-2 matrix. The values
% in column 1 are assigned to the left channel,
% and those in column 2 to the right.
sound(0.1*[ref;sig]',Fs)
%figure(1);clf;
%plot(t,sig)