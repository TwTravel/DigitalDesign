clc
clf
clear all

x = linspace(-8,8,200);
y = linspace(-8,8,200);
z = zeros(100);


for i=1:length(x)
    for j=1:length(y)
        z(i,j)=eqn(x(i),y(j));
    end
end

figure(1)
hold on
surf(x,y,z,'EdgeColor','none')

%initializations
xrecord=0;
yrecord=0;
vrecord=0;
xrecordbest=0;
yrecordbest=0;
vrecordbest=0;

%set number of iterations and population size
jumps = 500;
pool = 10;

iterations = jumps*1000;

value = zeros(pool,1);
xbest=0;
ybest=0;

xbestprev=0;
ybestprev=0;
repcount=0;
repcountprev=0;
repcountmax=0;
jumpcount = 0;

%random seed values
xguess = (10*(rand(pool,1)))-5;
yguess = (10*(rand(pool,1)))-5;
xguess = ((10*(rand(1,1)))-5)*ones(pool,1);
yguess = ((10*(rand(1,1)))-5)*ones(pool,1);

xrecord = xguess(1);
yrecord = yguess(1);
vrecord = eqn(xguess(1),yguess(1));

%iterations
for n=1:iterations
    %check fitness of each one
    for i=1:pool
        value(i)=eqn(xguess(i),yguess(i));
    end

    %select most fit
    [temp,in]=max(value);
    xbest = xguess(in);
    ybest = yguess(in);
    xrecord = [xrecord;xbest];
    yrecord = [yrecord;ybest];
    vrecord = [vrecord;value(in)];

    if(xbest == xbestprev && ybest == ybestprev)
        repcount = repcount+1;
    else
        repcountprev = repcountmax;
        repcountmax = repcount;
        repcount = 0;
    end
    
    xbestprev = xbest;
    ybestprev = ybest;

    if repcount == 100
        xrecordbest = [xrecordbest;xbest];
        yrecordbest = [yrecordbest;ybest];
        vrecordbest = [vrecordbest;value(in)];
%        plot3(xrecord(2:length(xrecord)),yrecord(2:length(yrecord)),vrecord(2:length(vrecord))+.01,'k')
        plot3(xrecord,yrecord,vrecord+.01,'k')
        xbest = (10*(rand(1,1)))-5;
        ybest = (10*(rand(1,1)))-5;
        jumpcount = jumpcount + 1;
        xrecord = xbest(1);
        yrecord = ybest(1);
        vrecord = eqn(xbest(1),ybest(1));
        iterations = jumps*1000;
    end
    if jumpcount == jumps
        break
    end

    %make next generation
    xguess = [xbest;(1*rand(pool-1,1))-.5+xbest];
    yguess = [ybest;(1*rand(pool-1,1))-.5+ybest];
end

%repcountmax
%repcountprev

xrecord = xrecord(2:length(xrecord));
yrecord = yrecord(2:length(yrecord));
vrecord = vrecord(2:length(vrecord));
[y,x] = meshgrid(x,y);

plot3(xrecordbest(2:length(xrecordbest)),yrecordbest(2:length(yrecordbest)),vrecordbest(2:length(vrecordbest))+.01,'.');

hold off
%figure(2)
%hold on
%surf(x,y,z,'EdgeColor','none')
%plot3(xrecord,yrecord,vrecord+.01,'k')
%hold off

shading interp
