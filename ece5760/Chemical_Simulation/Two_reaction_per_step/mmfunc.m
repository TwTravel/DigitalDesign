function dydt = f(t,y,flag,k1,k_1,k2,E0)
% [S] = y(1), [ES] = y(2), [P] = y(3)
dydt = [-k1*E0*y(1)+(k1*y(1)+k_1)*y(2);
k1*E0*y(1)-(k1*y(1)+k_1+k2)*y(2);
k2*y(2)];