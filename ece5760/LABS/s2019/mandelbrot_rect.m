clear all
figure(1); clf;

termination = 100;
x = linspace(-2,1,640);
y = linspace(-1,1,480);
x_index = 1:length(x) ;
y_index = 1:length(y) ;
img = zeros(length(y),length(x));

N_total = 0;
for k=x_index
    for j=y_index
        z = 0;
        n = 0;
        c = x(k)+ y(j)*i ;%complex number
        while (abs(z)<2 && n<termination)
            z = z^2 + c;
            n = n + 1;
            N_total = N_total + 1;
        end
        img(j,k) = log2(n);
    end
end
N_total
imagesc(img)
colormap(jet)
right = 482;
left = 320;
top = 122 ;
line ([left right],[top top],'color','k')
line ([left right],[240+top 240+top],'color','k')
line ([left left],[top 240+top],'color','k')
line ([right right],[top 240+top],'color','k')
x(right);
x(left);
y(top);


