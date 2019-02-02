%generate a sine table for Verilog ROM 
x = 1:256;
% Sin : scale to 10-bits and offset 9-bits
y = fix(512 + 511*sin(2*pi*(x-1)/256)); 
for i=x
    fprintf('\t\t\t8''h%02x: sine = 10''h%03x ;\n', x(i)-1 ,y(i))    
end