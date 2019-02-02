%EULER for 2 mass oscillator
clear all
clc

% wall -- spring1 -- mass1 -- spring_middle -- mass2 -- spring2 -- wall
% x=-1                                                              

%positions
left_wall = -1 ;
right_wall = 1 ;

k1 = 1; % spring coeff
k13 = 0 ; %spring 1 cubic term coeff 4 is interesting
d1 = .01 ; % damping coefficient -- need some for stability

k2 = 1; % spring coeff
k23 = 0; %spring 2 cubic term coeff
d2 = .01 ; % damping coefficient -- need some for stability

k_middle = 1 ;  % spring coeff
k_middle_3 = 0;

% need small time step for stability
Fs = 256 ;
dt = 1/Fs ;
tspan = 0:dt:30 ; %seconds 
 
%initial condition sets
x0_symm = [-0.5, 0, 0.5, 0];
x0_antisymm = [0.0, 0, 0.65, 0];
x0_random = [-0.25, -.5, 0.70, .2]; ;

% init vector
% x(t,1) is spring 1 position
% x(t,2) is spring 1 vel
% x(t,3) is spring 2 position
% x(t,4) is spring 2 vel
x = zeros (length(tspan),4) ;
x(1,:) = x0_random' ;

for t=2:length(tspan)
    % compute spring tensions,
    % ASSUMING zero rest-length of the springs
    % the left spring
    spring_force1 = k1 * ((x(t-1,1)-left_wall) + k13*(x(t-1,1)-left_wall)^3);
    % the right spring
    spring_force2 = k2 * ((right_wall-x(t-1,3)) + k23*(right_wall-x(t-1,3))^3);
    % the middle spring
    spring_force_middle = k_middle * (x(t-1,3)-x(t-1,1)) + k_middle_3 * (x(t-1,3)-x(t-1,1))^3 ;
    
    % Euler update the vector 
    x(t,1) = x(t-1,1) + x(t-1,2)*dt;
    x(t,2) = x(t-1,2) + (-spring_force1 - d1 * x(t-1,2) + spring_force_middle)*dt ;
    x(t,3) = x(t-1,3) + x(t-1,4)*dt;
    x(t,4) = x(t-1,4) + (spring_force2 - d2 * x(t-1,4) - spring_force_middle)*dt ;
end

figure(1); clf;
plot(tspan,x(:,1), 'b', 'linewidth', 2)
hold on
plot(tspan,x(:,2), 'cyan')
plot(tspan,x(:,3), 'r', 'linewidth', 2)
plot(tspan,x(:,4), 'color', [1 .5 .5])

xlabel('Time(sec)')
ylabel('amp/speed')
set(gca, 'ylim', [-1 1])
legend('x1','v1','x2','v2')

%== end ========================================