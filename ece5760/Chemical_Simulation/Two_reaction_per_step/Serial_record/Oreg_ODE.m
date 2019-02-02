figure(5);clf;

%===do the simulation =========================================

y0 = [500 1000 2000]/2^16 ;
options=[];
Xbar = [15000 15000 15000]/2^16 ;
k = [656 52224 32768 10496 8192]/2^16 ;

[t y]=ode23('oregfunc',[0 1500], y0, options, Xbar, k); 

plot(t,y(:,1),'k',t,y(:,2),'k',t,y(:,3),'k', 'markersize', 10,'linewidth', 2.5);
hold on
% load Y1_MM_240_0.mat
% Y1 = num;
% load Y2_MM_240_0.mat
% Y2 = num;
% load Y3_MM_240_0.mat
% Y3 = num;

load Y1_Oreg_15000_1.mat
Y1 = num;
load Y2_Oreg_15000_1.mat
Y2 = num;
load Y3_Oreg_15000_1.mat
Y3 = num;

t1 = linspace(0, 1310, length(Y1));
plot(t1, Y1/2^16, 'bx', 'markersize',5, 'linewidth', 2)
plot(t1, Y2/2^16, 'rx', 'markersize',5, 'linewidth', 2)
plot(t1, Y3/2^16, 'gx', 'markersize',5,'linewidth',2)