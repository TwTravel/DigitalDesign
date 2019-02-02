close all
clc
n = 5;
while(true)
    M = csvread('output4.csv');
 %   figure(1); 
  %  plot3(M(1:n:end,1),M(1:n:end,2),M(1:n:end,3),'-o','LineWidth',3);
   % figure(2);
   % scatter3(M(1:n:end,1),M(1:n:end,2),M(1:n:end,3),'r')
   % figure(3);
   % scatter(M(1:n:end,1),M(1:n:end,2),'m');
    figure(4)
    subplot(2,2,1)
    plot3(M(1:n:end,1),M(1:n:end,2),M(1:n:end,3),'-o','LineWidth',3);
    subplot(2,2,2)
    scatter3(M(1:n:end,1),M(1:n:end,2),M(1:n:end,3),'r')
    subplot(2,2,3)
    plot(M(1:n:end,1),M(1:n:end,2),'-g');
    subplot(2,2,4)
    scatter(M(1:n:end,1),M(1:n:end,2),'m');  
    set(gcf, 'Position', get(0, 'Screensize'));
     pause(.1);
  
end