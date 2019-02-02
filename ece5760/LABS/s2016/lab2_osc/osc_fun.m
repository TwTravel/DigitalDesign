function xdot = osc_2(t,x)
%x = [ pos1 vel1 pos2 vel2]
global k1 d1  k13
global k2 d2  k23
global k_middle k_middle_3
global left_wall right_wall
global impact

% linear + cubic spring 
% x(1) is spring 1 position
% x(2) is spring 1 vel
% x(3) is spring 2 position
% x(4) is spring 2 vel

% compute spring tensions, 
% ASSUMING zero rest-length of the springs
% the left spring
spring_force1 = k1 * ((x(1)-left_wall) + k13*(x(1)-left_wall)^3);
% the right spring
spring_force2 = k2 * ((right_wall-x(3)) + k23*(right_wall-x(3))^3);
% the middle spring
spring_force_middle = k_middle * (x(3)-x(1)) + k_middle_3 * (x(3)-x(1))^3 ;

% update the vector of derivitives in the 
% format required by the ode45 solver
xdot(1) = x(2);
xdot(2) = -spring_force1 - d1 * x(2) + spring_force_middle ;
xdot(3) = x(4);
xdot(4) = +spring_force2 - d2 * x(4) - spring_force_middle ;

xdot = [xdot(1) ; xdot(2); xdot(3); xdot(4)] ;


% if mod(tindex,100)==0
%     t 
% end
%== end =========================================