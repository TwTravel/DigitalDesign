% test 60 Hz canceller
clear all
figure(1); clf;

Fs = 48000;
dt = 1/Fs;
t = 0:dt:1 ;

s1=1/2;
s2=1/3; %1/3
s3=1/6; %1/6
%reference noise
ref = sin(2*pi*60*t) +1*sin(2*pi*180*t);
refshift = sin(2*pi*60*t + pi*s1)+1*sin(2*pi*180*t+ pi*3*s1); %1/4 cycle at 60 Hz
refshift2 = sin(2*pi*60*t + pi*s2)+ 1*sin(2*pi*180*t+ pi*3*s2); %
refshift3 = sin(2*pi*60*t + pi*s3)+ 1*sin(2*pi*180*t+ pi*3*s3); %

%ph = 90;
%signal
% noisefree = sin(2*pi*10*t);
% sig = 1.0* sin(2*pi*60*t+ph) + noisefree ;


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
vAP = vAP + vAP2(1:length(t)); %truncate
noisefree = vAP+ 0.00*randn(size(t));
sig = noisefree +1* sin(2*pi*60*t+1)+1*sin(2*pi*180*t +3) ;

%%%%%%%%%%%%%%%%%%%%%%%%%
w1 = 0;
w2 = 0;
w3 = 0;
w4 = 0;
mu2e =2^-10 ;

for i=1:length(t)
    out(i) = sig(i) -  ( w1*ref (i) + w2*refshift(i) + w3*refshift2(i) + w4*refshift3(i) ) ;
    w1 = w1 + mu2e*out(i)*sign(ref(i)) ;
    w2 = w2 + mu2e*out(i)*sign(refshift(i)) ;
    w3 = w3 + mu2e*out(i)*sign(refshift2(i)) ;
    w4 = w4 + mu2e*out(i)*sign(refshift3(i)) ;
end

np=2;

subplot(np,1,1)
plot(t,sig);

subplot(np,1,2)
plot(t,out)
hold on
plot(t,noisefree,'r')


