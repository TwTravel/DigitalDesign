% Simulate Chem reactions
% Oregonator test
% X1bar + Y2 -> Y1 	rate c1
% Y1 + Y2 -> Z1 	rate c2
% X2bar + Y1 -> 2Y1+Y3 rate c3
% Y1 + Y1 -> Z2 	rate c4
% X3bar + Y3 -> Y2 	rate c5
%
clear all;

%define chemicals
Y = [500 1000 2000] ;
Xbar = [15000 15000 15000];

%define reactions vars
R_rand = zeros(5,3) ; % five reactions, each with 3 random numbers x 2
rate_const = [656 52224 32768 10496 8192] ;

Tmax = 20e6 ;
Tmax_out = 1e3;
delta_t = fix(Tmax/Tmax_out) ;
Yout = zeros(3, Tmax_out);

count_out = 1 ;
Yout(:,count_out) = Y ; %record the first output
tic
for t = 1:Tmax
    
    R_rand_1 = 65536 * rand(5,3) ;
    R_rand_2 = 65536 * rand(5,3) ;
    
    %reaction 1: X1bar + Y2 -> Y1 	rate c1
    r1 = all([Xbar(1) Y(2) rate_const(1)] > R_rand_1(1,:)) ;
    r2 = all([Xbar(1) Y(2) rate_const(1)] > R_rand_2(1,:)) ;
    react1_inc = r1 + r2  ;
    
    %reaction 2: Y1 + Y2 -> Z1 	rate c2
    r1 = all([Y(1) Y(2) rate_const(2)] > R_rand_1(2,:)) ;
    r2 = all([Y(1) Y(2) rate_const(2)] > R_rand_2(2,:)) ;
    react2_inc = r1 + r2  ;
    
    %reaction 3: X2bar + Y1 -> 2Y1+Y3 rate c3
    r1 = all([Xbar(2) Y(1) rate_const(3)] > R_rand_1(3,:)) ;
    r2 = all([Xbar(2) Y(1) rate_const(3)] > R_rand_2(3,:)) ;
    react3_inc = r1 + r2  ;
    
    %reaction 4: Y1 + Y1 -> Z2 	rate c4
    r1 = all([Y(1) Y(1) rate_const(4)] > R_rand_1(4,:)) ;
    r2 = all([Y(1) Y(1) rate_const(4)] > R_rand_2(4,:)) ;
    react4_inc = 2 * (r1 + r2) ;
    
    %reaction 5: X3bar + Y3 -> Y2 	rate c5
    r1 = all([Xbar(3) Y(3) rate_const(5)] > R_rand_1(5,:)) ;
    r2 = all([Xbar(3) Y(3) rate_const(5)] > R_rand_2(5,:)) ;
    react5_inc = r1 + r2  ;
    
    Y(1) = Y(1) + react1_inc - react2_inc + react3_inc - react4_inc ;
    Y(2) = Y(2) - react1_inc - react2_inc + react5_inc ;
    Y(3) = Y(3) + react3_inc - react5_inc ;
    
    % next output ?   
    if mod(t,delta_t)==0
        count_out = count_out + 1 ;
        Yout(:,count_out) = Y ; %record the output
    end
end
toc

figure(1); clf;
plot(Yout(1,:), 'r')
hold on
plot(Yout(2,:), 'g')
plot(Yout(3,:), 'b')


