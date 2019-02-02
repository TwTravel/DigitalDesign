% 
% Created in 2010 by Kerran Flanagan, Tom Gowing, Jeff Yates for
% ECE 5760 at Cornell University.
%

function ColorSimplify()

i = imread('/Users/kerran/Dropbox/2010fa/ece5760/report/Colorful_People.jpg');

input = i;

b = double(i) ./ 2.0^8;

% RGB approach
converted = zeros(size(i,1),size(i,2),size(i,3));
converted(:,:,1) = uint8((floor(b(:,:,1) .* 4 ) ./ 4 ) .* 256 );
converted(:,:,2) = uint8((floor(b(:,:,2) .* 4 ) ./ 4 ) .* 256 );
converted(:,:,3) = uint8((floor(b(:,:,3) .* 4 ) ./ 4 ) .* 256 ) ;
converted = double(converted) ./ 2.0^8;

% HSL approach
% b = rgb2hsl(b);
% converted = zeros(size(i,1),size(i,2),size(i,3));
% converted(:,:,1) = uint8((round(b(:,:,1) .* 7 ) ./ 7 ) .* 256 );
% converted(:,:,2) = uint8((round(b(:,:,2) .* 7 ) ./ 7 ) .* 256 );
% converted(:,:,3) = uint8((round(b(:,:,3) .* 7 ) ./ 7 ) .* 256 ) ;
% converted = double(converted) ./ 2.0^8;
% converted = hsl2rgb(converted);

out = uint8(converted .* 2.0^8);

imwrite(out,'report/rgb_2_2_2_noEdges.jpg','JPG');

out = markEdges(out,input);

imwrite(out,'report/rgb_2_2_2.jpg','JPG');

disp('done');

    function out = markEdges(out, input)
        operator = int16([ 1 2 1; 0 0 0; -1 -2 -1]);
        
        % add edges
        edges = int16(zeros(size(input,1),size(input,2)));
        
        
        thresh = (3 * 2^6);
        
        
        for x = 2: size(out,1)-1
            for y = 2: size(out,2)-1
                %horiz
                others = int16(input(x-1:x+1,y-1:y+1,:));
                others(:,:,1) = others(:,:,1) .* operator;
                others(:,:,2) = others(:,:,2) .* operator;
                others(:,:,3) = others(:,:,3) .* operator;
                
                if(abs(sum(sum(sum(others)))) > thresh)
                    %                 out(x,y,:) = [0 0 0];
                    edges(x,y,:) = edges(x,y) + int16(1);
                end
                
                %vert
                others = int16(input(x-1:x+1,y-1:y+1,:));
                others(:,:,1) = others(:,:,1) .* operator';
                others(:,:,2) = others(:,:,2) .* operator';
                others(:,:,3) = others(:,:,3) .* operator';
                
                if(abs(sum(sum(sum(others)))) > thresh)
                    %                 out(x,y,:) = [0 0 0];
                    edges(x,y,:) = edges(x,y) + int16(1);
                end
            end
        end
        
        
        out(:,:,1) = out(:,:,1) - uint8(edges .* 128);
        out(:,:,2) = out(:,:,2) - uint8(edges .* 128);
        out(:,:,3) = out(:,:,3) - uint8(edges .* 128);
    end

end
