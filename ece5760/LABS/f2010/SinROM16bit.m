x = 1:256;
% Sin : scale to 15-bits 
% 2's complement!
y = fix(((2^14)-1)*sin(2*pi*(x-1)/256)); 
for i=x
    if y(i)<0
        y(i) = 2^16 + y(i);
    end
    fprintf('\t\t\t8''h%02x: sine = 16''h%04x ;\n', x(i)-1 ,y(i))    
end