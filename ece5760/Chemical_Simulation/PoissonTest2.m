clear all
figure(1); clf;

x = 0:10;
m = [0.01 0.015 0.02 0.03 0.05 0.075 0.085 0.092 0.1 0.15 0.2 0.25 0.3 0.5];
count = 1;
for i = m
    y = poisspdf(x, i);
    csy = cumsum(y) ;
    cut999 = find(csy > 0.999)
    cut9999 = find(csy > 0.9999);
    pt999(count) = cut999(1);
    pt9999(count) = cut9999(1);
    count = count+1;
end

semilogx(m, pt999-1, 'bo', 'markersize', 7)
hold on
semilogx(m, pt9999-1, 'rx', 'markersize', 7)
xlabel('Poisson mean')
ylabel('number of events to keep')
legend('99.9% cutoff', '99.99% cutoff')
set(gca, 'ylim', [0, 8])