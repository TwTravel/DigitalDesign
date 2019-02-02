s = sprintf('bruce');
img = imread(s,'bmp');
t = [s,'.mif'];
file = fopen(t,'w');

fprintf(file,'WIDTH=24;\n'); %number of bits per entry
fprintf(file,'DEPTH=28000;\n'); %number of addreses. for 200x140 = 28000
fprintf(file,'\n');
fprintf(file,'ADDRESS_RADIX=UNS;\n');
fprintf(file,'DATA_RADIX=UNS;\n');
fprintf(file,'\n');
fprintf(file,'CONTENT BEGIN\n');

addr = 0;
for i=1:140 %height
    for j=1:200 %width
        r = uint32(img(i,j,1));
        g = uint32(img(i,j,2));
        b = uint32(img(i,j,3));
        pixel = bitor(bitor(bitshift(r,16),bitshift(g,8)),b);
        fprintf(file,'\t%d     :   %d;\n',addr,pixel);
        addr = addr + 1;
    end
end

fprintf(file,'END;\n');
fclose(file);

s = sprintf('edited_clocktower');
img = imread(s,'bmp');
t = [s,'.mif'];
file = fopen(t,'w');

fprintf(file,'WIDTH=24;\n'); %number of bits per entry
fprintf(file,'DEPTH=9600;\n'); %number of addreses. for 40x240 = 9600
fprintf(file,'\n');
fprintf(file,'ADDRESS_RADIX=UNS;\n');
fprintf(file,'DATA_RADIX=UNS;\n');
fprintf(file,'\n');
fprintf(file,'CONTENT BEGIN\n');

addr = 0;
for i=1:240 %height
    for j=1:40 %width
        r = uint32(img(i,j,1));
        g = uint32(img(i,j,2));
        b = uint32(img(i,j,3));
        pixel = bitor(bitor(bitshift(r,16),bitshift(g,8)),b);
        fprintf(file,'\t%d     :   %d;\n',addr,pixel);
        addr = addr + 1;
    end
end

fprintf(file,'END;\n');
fclose(file);