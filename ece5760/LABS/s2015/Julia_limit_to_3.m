clear all
figure(1); clf;

termination = 100;
x = linspace(-2,2,640);
y = linspace(-1,1,480);
x_index = 1:length(x) ;
y_index = 1:length(y) ;
M = zeros(length(y),length(x));
c=-0.8+0.156*i ; 

for k=x_index
    for j=y_index
        z = x(k)+i*y(j) ;
        n = 0;
        while (abs(z)<2 && n<termination)
            zsqr = z^2;
            zsqr = sign(real(zsqr))*min(3,abs(real(zsqr))) + ...
                i*min(3,abs(imag(zsqr)))*sign(imag(zsqr));
            z = z^2 + c;
            z = sign(real(z))*min(3,abs(real(z))) + ...
                i*min(3,abs(imag(z)))*sign(imag(z));
            n = n + 1;
        end
        J(j,k) = n;
    end
end

imagesc(J)
colormap(summer)