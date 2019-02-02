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
% simulation times        
ts=0; tsmax = 80000;

% direction weights
w9=4/9; 
w1=1/9; w3=1/9; w5=1/9; w7=1/9; 
w2=1/36; w4=1/36; w6=1/36; w8=1/36;

% grid resolution
nx=600; ny=100;
% init uniform density FEQ 
F=repmat(density/9,[nx ny 9]); 
FEQ=F; 
msize=nx*ny; 
% boundary collision array
CI=[0:msize:msize*7];
% make a black image
black_image = (F(:,:,1)'*0);
% unused random barriers
%BOUND=rand(nx,ny)>0.999; %extremely porous random domain
%bottom boundary
for i=(1):1:(nx) 
    BOUND(i) = 1;
end
% %top boundary
% cood is x+nx*y
for i=(1+nx*(ny-1)):1:(nx+nx*(ny-1)) 
    BOUND(i) = 1;
end

%initial jet postiion
jet_x_init = 300 ;

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
 adv_x = zeros(1,tsmax);
 adv_y = zeros(1,tsmax);
adv_num = 1;
adv_x(1:adv_num) = randi([50 550], [1,adv_num]);
adv_y(1:adv_num) = randi([10 90], [1,adv_num]);

%matrix offset of each Occupied Node
ON=find(BOUND); 
%matrix offset of each active node next to a occupied node
TO_REFLECT=[ON+CI(1) ON+CI(2) ON+CI(3) ON+CI(4) ...
            ON+CI(5) ON+CI(6) ON+CI(7) ON+CI(8)];
        
REFLECTED= [ON+CI(5) ON+CI(6) ON+CI(7) ON+CI(8) ...
            ON+CI(1) ON+CI(2) ON+CI(3) ON+CI(4)];


% and the figure
figure(1);clf;colormap(jet(100));
video = 1;
if (video)
    v = VideoWriter('moving_source_1.mp4', 'MPEG-4');
    open(v);
end
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
    
    % Force jet flow
    jet_width = [45:55];
    jet_x = jet_x_init + fix(200*sin(2*pi*ts/5000)) ;
    % jet velocity
    %F(jet_x,jet_width,2) = 0.023;
    F(jet_x,jet_width,1) = F(jet_x,jet_width,1) + 0.01*(cos(2*pi*ts/5000)); % 0.16, 0.195
%     F(jet_x,jet_width,8) = 0.023;
%     F(jet_x,jet_width,4) = 0.0;
%     F(jet_x,jet_width,5)=0.0;
%     F(jet_x,jet_width,6) = 0.0;
    
    
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
    
    %create some particles
     adv_num = adv_num + 1 ;
     adv_x(adv_num) = jet_x + 2;
     adv_y(adv_num) = randi([45 55]);
    % store old positions
    adv_x(adv_x < 1) = nx-1 ;
    adv_x(adv_x > nx-1) = 1;
    adv_y(adv_y < 1) = ny-1 ;
    adv_y(adv_y > ny-1) = 1;
    old_adv_x(1:adv_num) = adv_x(1:adv_num);
   % old_adv_y(1:adv_num) = adv_y(1:adv_num);
     %advect particles
    for j=1:adv_num
        adv_x(j) = adv_x(j) + ux(fix(adv_x(j)), fix(adv_y(j)));
        adv_y(j) = adv_y(j) + uy(fix(old_adv_x(j)), fix(adv_y(j)));
    end
    % time/plot control
    ts=ts+1;
    if (mod(ts,20)==0)
        %quiver(2:nx,1:ny,ux(2:nx,:)',uy(2:nx,:)','b'); 
        
        % now plot
        speed=sqrt(ux(2:nx,:).^2'+uy(2:nx,:).^2');
        imagesc(black_image);
        line([adv_x(1:adv_num) adv_x(1:adv_num)],[adv_y(1:adv_num) adv_y(1:adv_num)],...
            'MarkerFaceColor','k', 'MarkerEdgeColor', 'k', ...
            'Marker', 'o', 'MarkerSize',1, 'LineStyle', 'none');
        title(['Flow field ',num2str(ts),' omega=', num2str(omega), ' dV=', num2str(deltaU)] );
        drawnow
        % video
        if (video)
            writeVideo(v,getframe(gcf))
        end
    end
end
toc
if (video)
    close(v);
end
%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


