%driver for 2 mass oscillator
clear all
clc

global k1 d1  k13
global k2 d2  k23
global k_middle k_middle_3
global left_wall right_wall

% wall -- spring1 -- mass1 -- spring_middle -- mass2 -- spring2 -- wall
% x= 0                 1                         2                   3

%positions
left_wall = -1 ;
right_wall = 1 ;

k1 = 1; % spring coeff
k13 = 0 ; %spring 1 cubic term coeff 4 is interesting
d1 = .0 ; % damping coefficient

k2 = 1; % spring coeff
k23 = 0; %spring 2 cubic term coeff
d2 = .0 ; % damping coefficient

k_middle = 1 ;  % spring coeff
k_middle_3 = 0;

Fs = 100 ;
tspan = 0:1/Fs:100 ; %seconds 
 
%initial condition sets
x0_symm = [-0.5, 0, 0.5, 0];
x0_antisymm = [0.0, 0, 0.65, 0];
x0_random = [-0.25, -.5, 0.70, .2]; ;

% [TOUT,YOUT] = ODE45(ODEFUN,TSPAN,X0)
[t, x] = ode45('osc_fun', tspan, x0_random);

figure(1); clf;
plot(t,x(:,1), 'b')
hold on
plot(t,x(:,3), 'r')

xlabel('Time(sec)')
ylabel('amp')
set(gca, 'ylim', [-1 1])
legend('x1','x2')

%== end ========================================