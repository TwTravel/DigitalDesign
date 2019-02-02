% lorenz system
% ece5760 Dec 2017

sigma = 10.0 ;
beta = 8/3 ;
rho = 28.0 ;
dt = 0.01 ;
x = -1;
y = .1;
z = 25;
% dX/dt = sigma*(Y-X)	
% dY/dt = X*(rho-Z)-Y	
% dZ/dt = X*Y-beta*Z,

stopit = 0;
t = 0;
line_index = 1;

figure(1); clf;
set(gcf, 'Renderer','opengl');
%axis([XMIN XMAX YMIN YMAX ZMIN ZMAX])
axis([-25 25 -25 25 0 50])
axis vis3d
ax = gca;
ax.Box = 'on';
ax.BoxStyle = 'full';
xlabel('x1');
ylabel('x2');
zlabel('x3');
grid on
set(gca, 'xtick', [-20 -10 0 10 20])
set(gca, 'ytick', [-20 -10 0 10 20])

%predefine a line for speed
sim_size = 2000;
xl = x*ones(1,sim_size);
yl = y*ones(1,sim_size);
zl = z*ones(1,sim_size);

lh = line(xl, yl, zl,'marker','.')

%optional video write
video = 1;
if (video)
    v = VideoWriter('lorenz_1.mp4', 'MPEG-4');
    open(v);
end

%define the plot button
stopbutton=uicontrol('style','pushbutton',...
   'string','stop', ...
   'fontsize',12, ...
   'position',[0,0,60,20], ...
   'callback', 'stopit=1;');

while (stopit==0)
    
    xl = get(lh, 'xdata');
    yl = get(lh, 'ydata');
    zl = get(lh, 'zdata');
    xl(line_index) = x;
    yl(line_index) = y;
    zl(line_index) = z;
    set(lh, 'xdata', xl);
    set(lh, 'ydata', yl);
    set(lh, 'zdata', zl);
    line_index = line_index + 1;
    if(line_index>sim_size)
        stopit = 1;
    end
	
    t = t + dt;
    xn = x + dt*(sigma*(y-x));
    yn = y + dt*(x*(rho-z) - y);
    zn = z + dt*(x*y - beta*z);
    x = xn ;
    y = yn ;
    z = zn ;
    
    view(35+30*sawtooth(2*pi*t/2, 0.5), 20);
    drawnow
    % video
    if (video)
        writeVideo(v,getframe(gcf))
    end
end
if (video)
    close(v);
end

figure(2); clf
subplot(3,1,1)
plot(xl);
ylabel('x1')
subplot(3,1,2)
plot(yl);
ylabel('x2')
subplot(3,1,3)
plot(zl);
ylabel('x3')

