close all;
c = imread('original.jpg');%read the JPG image

output = imresize(c,[80 80]);%resize the image to an appropriate size


imshow(output)%check the size 
fid=fopen('newtest.txt','wt'); %set a text file to store the image
for i=1:6400
		%because of the limitation of M4K, we only use six bits of each color and combine them together (RGB)
        final = uint32(floor(output(i)/4)-1)*2.^12+uint32(floor(output(i+6400)/4)-1)*2.^6+uint32(floor(output(i+12800)/4)-1);
		
        if(final==0)%do the decimal to hex translation and enter every time so that it can be read in the later mif file

            fprintf(fid,'%s\n',dec2hex(final));
        else
            fprintf(fid,'%s\n',dec2hex(final));
        end
end

