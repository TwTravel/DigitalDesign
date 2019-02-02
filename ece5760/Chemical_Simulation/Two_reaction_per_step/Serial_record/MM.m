figure(5);clf;

%===do the simulation =========================================

k1=1; % units 1/(Ms)
k_1=k1/4096; % units 1/s
k2=k1/256; % units 1/s
E0=0.25*240/2^16 ; %*240/2^16; % units M
E0 = 0.25/16 ;
options=[];
[t y]=ode23('mmfunc',[0 2000],[1/16 0 0],options,k1,k_1,k2,E0); %240/2^16
S=y(:,1);
ES=y(:,2);
E=E0-ES;
P=y(:,3);
plot(t,S,'k',t,ES,'k',t,P,'k', 'markersize', 10,'linewidth', 2.5);
hold on
% load Y1_MM_240_0.mat
% Y1 = num;
% load Y2_MM_240_0.mat
% Y2 = num;
% load Y3_MM_240_0.mat
% Y3 = num;

load Y1_MM_4096_1.mat
Y1 = num;
load Y2_MM_4096_1.mat
Y2 = num;
load Y3_MM_4096_1.mat
Y3 = num;

t1 = linspace(0, 2550, length(Y1));
plot(t1, Y1/2^16, 'bx', 'markersize',5, 'linewidth', 2)
plot(t1, Y2/2^16, 'rx', 'markersize',5, 'linewidth', 2)
plot(t1, Y3/2^16, 'gx', 'markersize',5,'linewidth',2)