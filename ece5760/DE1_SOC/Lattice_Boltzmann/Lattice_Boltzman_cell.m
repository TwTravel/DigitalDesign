%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2D Lattice Boltzmann (BGK) model of a fluid.
%  c4  c3   c2  D2Q9 model. At each timestep, particle densities propagate
%    \  |  /    outwards in the directions indicated in the figure. An
%  c5 -c9 - c1  equivalent 'equilibrium' density is found, and the densities
%    /  |  \    relax towards that state, in a proportion governed by omega.
%  c6  c7   c8      Iain Haslam, March 2006.
% Original code from http://exolete.com/lbm/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recoded using algorithm from 
%Architecture for  Real-Time Interactive Painting based on Lattice-Boltzmann 
%Domien Nowicki, Luc Claesen 
% http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=5724497
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% and using constant scaling from:
% Lattice Boltzmann sample in Matlab
% Copyright (C) 2006-2008 Jonas Latt
% Address: EPFL, 1015 Lausanne, Switzerland
% E-mail: jonas@lbmethod.org
% Get the most recent version of this file on LBMethod.org:
%   http://www.lbmethod.org/_media/numerics:cylinder.m
%   http://wiki.palabos.org/numerics:codes
%   http://wiki.palabos.org/lattice_boltzmann_method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% with deltaU = .002
% --omega = 1.0 laminar flow
% --omega = 1.82 Reynolds # ~100 highly alternating
% --omega = 1.5  slow oscillations
% --omega = 1.25  stable
% with deltaU = .001
% --omega = 1.82 Reynolds # ~100 highly alternating with BOUND(30+nx*60) = 1;
% --omega = 1.82 Reynolds # ~100 smooth with BOUND(30+nx*60) = 0;
% with deltaU = .0005;
% --omega = 1.82 Reynolds # ~100 highly alternating with BOUND(30+nx*60) = 1;
%    and with (50+nx*20):nx:(50+nx*80) and (50+nx*30):nx:(50+nx*70)
%    and with (50+nx*40):nx:(50+nx*60)
% with deltaU = .001;
% --omega = 1.82 Reynolds # ~100 highly alternating with BOUND(30+nx*60) = 1;
%    and with (50+nx*40):nx:(50+nx*60) and BOUND(51+nx*60) = 1;
clear all
omega=1.82; density=1.0; %1.82
deltaU = .0000001; %1e-7; %e-7

% direction weights
w9=4/9; 
w1=1/9; w3=1/9; w5=1/9; w7=1/9; 
w2=1/36; w4=1/36; w6=1/36; w8=1/36;

% grid resolution
nx=100; ny=100;
% init uniform density FEQ 
F=repmat(density/9,[nx ny 9]); 
FEQ=F; 
msize=nx*ny; 
% boundary collision array
CI=[0:msize:msize*7];

% unused random barriers
%BOUND=rand(nx,ny)>0.999; %extremely porous random domain
%bottom boundary
for i=(1):1:(nx) 
    BOUND(i) = 1;
end
% %top boundary
for i=(1+nx*(ny-1)):1:(nx+nx*(ny-1)) 
    BOUND(i) = 1;
end

% left boundary
for i=(1+nx*1):nx:(1+nx*99) 
    BOUND(i) = 1;
end
% right boundary
for i=(nx+nx*1):nx:(nx+nx*99) 
    BOUND(i) = 1;
end

% flat plate to cause vonKarman vortex street
% pos = 100;
% for i=(pos+nx*40):nx:(pos+nx*60) 
%     BOUND(i) = 1;
% end
% slight assymtry
 %BOUND(500+nx*60) = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init to uniform flow to the right
% F(:,:,1) = .0951;
% F(:,:,2) = .0238;
% F(:,:,3) = .0739;
% F(:,:,4) = .0143;
% F(:,:,5) = .0574;
% F(:,:,6) = .0144;
% F(:,:,7) = .0739;
% F(:,:,8) = .0238;
% F(:,:,9) = .2955;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% advecting particles
% adv_x = [150 150 150 150 150 150 150 150 150 250 250 250 250 250 250 250 250 250];
% adv_y = [10 20 30 40 50 60 70 80 90 10 20 30 40 50 60 70 80 90] ;

adv_x = randint(1,500,[2 99]);
adv_y = randint(1,500,[1 50]);
%matrix offset of each Occupied Node
ON=find(BOUND); 
%matrix offset of each active node next to a occupied node
TO_REFLECT=[ON+CI(1) ON+CI(2) ON+CI(3) ON+CI(4) ...
            ON+CI(5) ON+CI(6) ON+CI(7) ON+CI(8)];
        
REFLECTED= [ON+CI(5) ON+CI(6) ON+CI(7) ON+CI(8) ...
            ON+CI(1) ON+CI(2) ON+CI(3) ON+CI(4)];

% simulation times        
ts=0; tsmax = 40000;
% and the figure
figure(1);clf;colormap(jet(100));
v = VideoWriter('driven_lid.mp4', 'MPEG-4');
open(v);
tic
while ts<tsmax
    % Propagate
    F(:,:,4)=F([2:nx 1],[ny 1:ny-1],4); 
    F(:,:,3)=F(:,[ny 1:ny-1],3);
    F(:,:,2)=F([nx 1:nx-1],[ny 1:ny-1],2);
    F(:,:,5)=F([2:nx 1],:,5);  
    F(:,:,1)=F([nx 1:nx-1],:,1);  
    F(:,:,6)=F([2:nx 1],[2:ny 1],6); 
    F(:,:,7)=F(:,[2:ny 1],7); 
    F(:,:,8)=F([nx 1:nx-1],[2:ny 1],8);
   
    BOUNCEDBACK=F(TO_REFLECT); %Densities bouncing back at next timestep
    
    % driven top boundary flow
    top_drive_x = 4:nx;
    top_drive_y = ny-1;
    F(top_drive_x,top_drive_y,2) = 0.0;
    F(top_drive_x,top_drive_y,1)=0.15; % 0.195
    F(top_drive_x,top_drive_y,8) = 0.023;
    F(top_drive_x,top_drive_y,4) = 0.0;
    F(top_drive_x,top_drive_y,5)=0.0;
    F(top_drive_x,top_drive_y,6) = 0.0;
    
    
    rho=sum(F,3);
    ux=(sum(F(:,:,[1 2 8]),3)-sum(F(:,:,[4 5 6]),3));
    uy=(sum(F(:,:,[2 3 4]),3)-sum(F(:,:,[6 7 8]),3));
    
    %ux(1,1:ny)=ux(1,1:ny)+deltaU; %Increase inlet pressure %Increase inlet pressure
    
    %force zeros on barrier-occupied sites
    ux(ON)=0; uy(ON)=0; rho(ON)=0;
    
    % common terms for following calcs
    uxx =  ux.^2 ;
    uyy =  uy.^2 ;
    uxy = 2 .* ux .* uy ;
    uu = uxx + uyy ; 
    
    % nearest-neighbours
    FEQ(:,:,1)= w1*(rho + 3*ux + 4.5*uxx - 1.5*uu);
    FEQ(:,:,3)= w3*(rho + 3*uy + 4.5*uyy - 1.5*uu);
    FEQ(:,:,5)= w5*(rho - 3*ux + 4.5*uxx - 1.5*uu);
    FEQ(:,:,7)= w7*(rho - 3*uy + 4.5*uyy - 1.5*uu);
    % next-nearest neighbours
    FEQ(:,:,2)= w2*(rho + 3*(ux+uy) + 4.5*(uu+uxy) - 1.5*uu);
    FEQ(:,:,4)= w4*(rho - 3*(ux-uy) + 4.5*(uu-uxy) - 1.5*uu);
    FEQ(:,:,6)= w6*(rho - 3*(ux+uy) + 4.5*(uu+uxy) - 1.5*uu);
    FEQ(:,:,8)= w8*(rho + 3*(ux-uy) + 4.5*(uu-uxy) - 1.5*uu);
    % Calculate equilibrium distribution: stationary
    FEQ(:,:,9)= rho - sum(FEQ(:,:,[1:8]),3);
    %
    F=(omega*FEQ+(1-omega)*F); 
    
    F(REFLECTED)=BOUNCEDBACK;

    %advect a particle
    old_adv_x = adv_x;
    old_adv_y = adv_y;
    for j=1:length(adv_x)
        adv_x(j) = adv_x(j) + ux(fix(adv_x(j)), fix(adv_y(j)));
        adv_y(j) = adv_y(j) + uy(fix(old_adv_x(j)), fix(adv_y(j)));
        if (adv_x(j)>nx-1)
            adv_x(j) = 1;
        end
    end
    % time/plot control
    ts=ts+1;
    if (mod(ts,20)==0)
        %quiver(2:nx,1:ny,ux(2:nx,:)',uy(2:nx,:)','b'); 
        speed=sqrt(ux(2:nx,:).^2'+uy(2:nx,:).^2');
        imagesc(speed);
        line([adv_x adv_x],[adv_y adv_y],...
            'MarkerFaceColor','w', 'Marker', 'o', 'MarkerSize',5, 'LineStyle', 'none');
        title(['Flow field ',num2str(ts),' omega=', num2str(omega), ' dV=', num2str(deltaU)] );
        drawnow
        
        writeVideo(v,getframe(gcf))
    end
end
toc
close(v);
%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


