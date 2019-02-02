fid = fopen('img.mif','w');
fprintf(fid,'WIDTH=1;\n');
fprintf(fid,'DEPTH=310000;\n');
fprintf(fid,'ADDRESS_RADIX=UNS;\n');
fprintf(fid,'DATA_RADIX=BIN;\n');
fprintf(fid,'CONTENT\nBEGIN\n');

valor = cdata(1);
primeiro=0;
fprintf(fid, '[0..309999] : 1;\n');
for i=1:480
    for j=1:640
        
        if  (valor ~= cdata(i,j))
            if(primeiro==640*(i-1)+j-1)
                fprintf(fid, '%d : %d;\n', primeiro, valor);
            else
                fprintf(fid, '[%d..%d] : %d;\n', primeiro, 640*(i-1)+j-1,valor);
            end
            valor = cdata(i,j);
            primeiro = 640*(i-1)+j;
            
        end
 
    end
end
fprintf(fid, '[%d..%d] : %d;\n',primeiro, 640*(i-1)+j-1, valor);
fprintf(fid,'END;');
fclose(fid);