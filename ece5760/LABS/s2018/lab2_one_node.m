%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ONE DRUM NODE for testing
% VARY rho from 0.4 to 0.01
% note that:
% rho=0.25 gives square wave
% rho=0.01 gives sin wave
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finite difference drum/chime 
% Bruce Land, Cornell University, Feb 2018
% second order scheme from
% http://arxiv.org/PS_cache/physics/pdf/0009/0009068v2.pdf, 
% page 14, eqn 2.18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc

%linear dimension of membrane -- one node
n = 3 ;
u = zeros(n,n); %time t
u1 = zeros(n,n); %time t-1
u2 = zeros(n,n); %time t-2
uHit = zeros(n,n); %input strike

% turncation to simulate fixed point
trun = 100000;

% 0 < rho < 0.5 -- lower rho => lower pitch
% rho = (vel*dt/dx)^2
%
rho = .499 ;
% eta = damping*dt/2
% higher damping => shorter sound
eta = .001 ;

% boundary condition -1.0<gain<1.0
% 1.0 is completely free edge
% 0.0 is clamped edge
boundaryGain = 0.0;

%time
Fs = 48000 ;
time = 0.0:1/Fs:1.0;
%output sound
aud = zeros(size(time)) ;


%sets the amplitude of the stick strike 
ampIn = .1; 
%sets the position of the stick strike: 0<pos<n
x_mid = 2;
y_mid = 2;

%compute the  strike amplitude
uHit(2,2) = ampIn;

%enforce boundary conditions
uHit(1,:) = 0;
uHit(n,:) = 0;
uHit(:,1) = 0;
uHit(:,n) = 0;

%index for storing audio output
tindex = 1;

for t=time
    
    % use the central sample for output
    % any other sample or sum is also valid to try
    sampleLoc = 2;
    aud(tindex) = u1(sampleLoc,sampleLoc); %sum(sum(u))/(n^2); %
   
    
    %vectorized update of positions, except for boundaries
    u(2,2) = 1/(1+eta) * (...
              rho * (u1(3:n,2:n-1)+u1(1:n-2,2:n-1)+u1(2:n-1,3:n)+u1(2:n-1,1:n-2)-4*u1(2:n-1,2:n-1)) ...
              + 2 * u1(2:n-1,2:n-1) ...
              - (1-eta) * (u2(2:n-1,2:n-1)) ...
              ) ;
    
    %enforce boundary conditions
    u(1,:) = 0;
    u(n,:) = 0;
    u(:,1) = 0;
    u(:,n) = 0;
    
    %update history to simulate fixed point truncation
    u2 = fix(trun*u1)/trun;
    u1 = fix(trun*u)/trun;
    
    %apply drum strikes at two times
    if t==0 ;%| t==1.0 
        u1 = uHit;
        u2 = uHit;
    end
    
    % the storage index
    tindex = tindex + 1;    
end

%play the sound
%soundsc(aud,Fs)

figure(3);clf;
plot(time, aud, 'o-');
set(gca,'ylim',[-1 1]*2*ampIn);
set(gca,'xlim',[0 0.001]);

%end
%============================================================