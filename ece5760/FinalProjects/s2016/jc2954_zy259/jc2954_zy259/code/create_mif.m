s = sprintf('white_win');
img = imread(s,'jpg');
t = [s,'.mif'];
file = fopen(t,'w');
[height, width] = size(img)
depth = round(height * width)
depth_str = int2str(depth)

fprintf(file,'WIDTH=1;\n'); %number of bits per entry
fprintf(file,'DEPTH=%s;\n',depth_str); %number of addreses. for 80x480 = 38400
fprintf(file,'\n');
fprintf(file,'ADDRESS_RADIX=UNS;\n');
fprintf(file,'DATA_RADIX=UNS;\n');
fprintf(file,'\n');
fprintf(file,'CONTENT BEGIN\n');

addr = 0;
for i=1:height %height
    for j=1:width %width
        pixel = img(i,j);
        fprintf(file,'\t%d     :   %d;\n',addr,pixel);
        addr = addr + 1;
    end
end

fprintf(file,'END;\n');
fclose(file);