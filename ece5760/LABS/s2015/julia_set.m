clear all
figure(1); clf;

termination = 1000;
x = linspace(-2,2,640);
y = linspace(-2,2,480);
x_index = 1:length(x) ;
y_index = 1:length(y) ;
img = zeros(length(y),length(x));
%c=-0.835-0.2321*i ;
%c=-0.8+0.156*i ;
c=-0.8;
%c=0.5;
%c=0.285+0.01*i;
nn = 0;
for k=x_index
    for j=y_index
        z = x(k)+i*y(j) ;
        n = 0;
        while (abs(z)<2 && n<termination)
            z = z^2 + c;
            n = n + 1;
        end
        img(j,k) = log(n);
        nn = nn + n;
    end
end

imagesc(img)
colormap(jet)
nn
return


