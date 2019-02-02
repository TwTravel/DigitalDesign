% Finite difference drum/chime 
% Bruce Land, Cornell University, May 2008
% second order scheme from
% http://arxiv.org/PS_cache/physics/pdf/0009/0009068v2.pdf, 
% page 14, eqn 2.18

clear all
clc

%linear dimension of membrane -- bigger is lower pitch
n = 20 ;
u = zeros(n,n); %time t
u1 = zeros(n,n); %time t-1
u2 = zeros(n,n); %time t-2
uHit = zeros(n,n); %input strike

% turncation to simulate fixed point
trun = 100000;

% 0 < rho < 0.5 -- lower rho => lower pitch
% rho = (vel*dt/dx)^2
rho = .2 ;
% eta = damping*dt/2
% higher damping => shorter sound
eta = .0005 ;
% boundary condition -1.0<gain<1.0
% 1.0 is completely free edge
% 0.0 is clamped edge
boundaryGain = 0.0 ;

% low pass for tension modulation
tm_a = 	.01 ; %range 1-.99 or >.01
% gain for tension modulation
tm_g = 1; %when term added to rho, sum cannot exceed 0.5

%time
Fs = 8000 ;
time = 0.0:1/Fs:2.0;
%output sound
aud = zeros(size(time)) ;
% efffective tension modified velocity for testing
rho_eff = zeros(size(time)) ;

%sets the amplitude of the stick strike 
ampIn = .1; 
%sets the position of the stick strike: 0<pos<n
x_mid = n/2;
y_mid = n/2;
%sets width of the gaussian strike input 
alpha = .05 ;
%compute the gaussian strike amplitude
for i=2:n-1
    for j=2:n-1
        uHit(i,j) = ampIn*exp(-alpha*(((i-1)-x_mid)^2+((j-1)-y_mid)^2));
    end
end
%enforce boundary conditions
uHit(1,:) = boundaryGain * uHit(2,:);
uHit(n,:) = boundaryGain * uHit(n-1,:);
uHit(:,1) = boundaryGain * uHit(:,2);
uHit(:,n) = boundaryGain * uHit(:,n-1);

figure(1);clf;
mh = mesh(uHit);
title('initial displacement')
set(gca, 'zlim', [-0.5,0.5])

%index for storing audio output
tindex = 1;

for t=time
    
    % use the central sample for output
    % any other sample or sum is also valid to try
    sampleLoc = fix(n/2);
    aud(tindex) = u1(sampleLoc,sampleLoc); %sum(sum(u))/(n^2); %
    % use center sample to estimate amplitude for tension modulation
    new_rho_eff = min(.48, rho + (u1(x_mid, y_mid)*tm_g)^2) ;
    % use whole drum for tension midulation
    %new_rho_eff = min(0.49, rho + sum(sum(u2.^2))/300) ;
    
    % some digital filtering of tension modulation
    if tindex>20
        rho_eff(tindex) = tm_a*new_rho_eff + (1-tm_a)*rho_eff(tindex-1) ;
    elseif tindex>1
        rho_eff(tindex) = max (new_rho_eff, rho_eff(tindex-1)) ;
    else
        rho_eff(tindex) = new_rho_eff;
    end
    
    %vectorized update of positions, except for boundaries
    u(2:n-1,2:n-1) = 1/(1+eta) * (...
              rho_eff(tindex) * (u1(3:n,2:n-1)+u1(1:n-2,2:n-1)+u1(2:n-1,3:n)+u1(2:n-1,1:n-2)-4*u1(2:n-1,2:n-1)) ...
              + 2 * u1(2:n-1,2:n-1) ...
              - (1-eta) * (u2(2:n-1,2:n-1)) ...
              ) ;
    
    %enforce boundary conditions
    u(1,:) = boundaryGain * u(2,:);
    u(n,:) = boundaryGain * u(n-1,:);
    u(:,1) = boundaryGain * u(:,2);
    u(:,n) = boundaryGain * u(:,n-1);
    
    %update history to simulate fixed point truncation
    u2 = fix(trun*u1)/trun;
    u1 = fix(trun*u)/trun;
    
    %apply drum strikes at two times
    if t==0 ;%| t==1.0 
        u1 = u1 + uHit;
    end
    
    % the storage index
    tindex = tindex + 1;    
end

%play the sound
soundsc(aud,Fs)
figure(3);clf
plot(time, aud);
hold on
plot(time, rho_eff, 'r');
set(gca,'xlim',[0 1])

% get the spectrum
figure(2); clf;
Hs=spectrum.welch('Hamming',2048,50);
psd(Hs,aud,'Fs',Fs)
title('Drum spectrum')
set(gca,'xlim',[0 1])



%end
%============================================================