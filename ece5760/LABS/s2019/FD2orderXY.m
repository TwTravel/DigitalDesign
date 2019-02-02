% Finite difference drum/chime 
% Bruce Land, Cornell University, May 2008
% second order scheme from
% http://arxiv.org/PS_cache/physics/pdf/0009/0009068v2.pdf, 
% page 14, eqn 2.18

clear all

%linear dimension of membrane -- bigger is lower pitch
nx = 5 ; ny=50;
u = zeros(nx,ny); %time t
u1 = zeros(nx,ny); %time t-1
u2 = zeros(nx,ny); %time t-2
uHit = zeros(nx,ny); %input strike

% 0 < rho < 0.5 -- lower rho => lower pitch
% rho = (vel*dt/dx)^2
rho = 0.5;
% eta = damping*dt/2
% higher damping => shorter sound
eta = 0.0002 ;
% boundary condition -1.0<gain<1.0
% 1.0 is completely free edge
% 0.0 is clamped edge
boundaryGain = 0.0;

%time
Fs = 8000 ;
time = 0.0:1/Fs:5.0;
%output sound
aud = zeros(size(time)) ;

%sets the amplitude of the stick strike 
ampIn = .5; 
%sets the position of the stick strike: 0<pos<n
x_mid = 2;% nx/2;
y_mid = 2; %ny/2;
%sets width of the gaussian strike input -- see figure 1
alpha = .5 ;
%compute the gaussian strike amplitude
for i=2:nx-1
    for j=2:ny-1
        uHit(i,j) = ampIn*exp(-alpha*(((i-1)-x_mid)^2+((j-1)-y_mid)^2));
    end
end
%enforce boundary conditions
uHit(1,:) = boundaryGain * uHit(2,:);
uHit(nx,:) = boundaryGain * uHit(nx-1,:);
uHit(:,1) = boundaryGain * uHit(:,2);
uHit(:,ny) = boundaryGain * uHit(:,ny-1);

figure(1);clf;
mh = mesh(uHit);
title('initial displacement')
set(gca, 'zlim', [-0.5,0.5])

%index for storing audio output
tindex = 1;

for t=time
    
    %animate drum -- very SLOW
%     set(mh, 'zdata', u)
%     drawnow
    
    % use the central sample for output
    % any other sample or sum is also valid to tr
    aud(tindex) = u(2,2) ; %sum(sum(u))/(n^2); %
    
    %vectorized update of positions, except for boundaries
    u(2:nx-1,2:ny-1) = 1/(1+eta) * (...
              rho * (u1(3:nx,2:ny-1)+u1(1:nx-2,2:ny-1)+u1(2:nx-1,3:ny)+u1(2:nx-1,1:ny-2)-4*u1(2:nx-1,2:ny-1)) ...
              + 2 * u1(2:nx-1,2:ny-1) ...
              - (1-eta) * (u2(2:nx-1,2:ny-1)) ...
              ) ;
    
    %enforce boundary conditions
    u(1,:) = boundaryGain * u(2,:);
    u(nx,:) = boundaryGain * u(nx-1,:);
    u(:,1) = boundaryGain * u(:,2);
    u(:,ny) = boundaryGain * u(:,ny-1);
    
    %enforce boundary conditions
%     u(1,:) = boundaryGain * (u(2,:)-u1(2,:));
%     u(n,:) = boundaryGain * (u(n-1,:)-u1(n-1,:));
%     u(:,1) = boundaryGain * (u(:,2)-u1(:,2)) ;
%     u(:,n) = boundaryGain * (u(:,n-1)-u1(:,n-1));
    
    %update history 
    u2 = u1;
    u1 = u;
    
    %apply drum strikes at two times
    if t==0 | t==1.0 
        u1 = u1 + uHit;
    end
    
    tindex = tindex + 1;    
end

% get the spectrum
figure(2); clf;
Hs=spectrum.welch('Hamming',1024,50);
psd(Hs,aud,'Fs',Fs)
title('Free edge plate spectrum')
set(gca,'xlim',[0 2])

%play the sound
sound(aud, Fs)
wavwrite(aud, Fs, 16, 'bell.wav')
%end
%============================================================