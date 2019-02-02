function perspective 

wall = zeros(6,4,3);
wall(1,:,:) = [0,0,0; 50,0,0; 50,0,10; 0,0,10];        % right wall RED (const y)
wall(2,:,:) = [0,50,0; 50,50,0; 50,50,10; 0,50,10];    % leftwall  GREEN (const y)
wall(3,:,:) = [0,0,0; 50,0,0; 50,50,0; 0,50,0];        % floor      BLUE (const z)
wall(4,:,:) = [0,0,10; 50,0,10; 50,50,10; 0,50,10];    %ceiling    BLACK (const z)
wall(5,:,:) = [0,0,0; 0,50,0; 0,50,10; 0,0,10];        % front wall WHITE (const x)
wall(6,:,:) = [50,0,0; 50,50,0; 50,50,10; 50,0,10];    % backwall  GRAY (const x)

close
figure;
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
axis([-1 1 -1 1]);

FOVx = 150;
FOVy = FOVx * 0.75;
n = -2;
f = -90;
hx = tan(FOVx*(pi/180)/2) * 2*n;
hy = tan(FOVy*(pi/180)/2) * 2*n;
Mo = [(2/hx) 0 0 0; 0 (2/hy) 0 0; 0 0 (2/(n-f)) (-(n+f)/(n-f)); 0 0 0 1];
Mp = [n 0 0 0; 0 n 0 0 ; 0 0 (n+f) (-1*n*f); 0 0 1 0] 
Mvc = Mo * Mp;

for qw = 0:pi/100:pi
    e = [25, 25, 5];
    g = [sin(qw) cos(qw) 0];
    up = [0 0 1];
    w = -g;
    u = cross(up, w);
    v = cross(w, u);
    u = u / norm(u);
    v = v / norm(v);
    w = w / norm(w);
    a1 = [u,0;v,0;w,0;0 0 0 1];
    a2 = [1 0 0 -e(1);0 1 0 -e(2);0 0 1 -e(3);0 0 0 1];
    Mwv = a1 * a2;
    Mwc = Mvc * Mwv;

    clf;
    c = zeros(0,3);
    
    for j=1:6    
        for i=1:4
            x = reshape(wall(j,i,:),3,1);
            x = [x; 1];
            y = Mwc * x;
            y = y / y(4);
            c = [c;y(1) y(2) y(3)];        
        end
        
        c = SHClip(c);

        for i =1:size(c,1)
            k = mod(i,size(c,1))+1;
            line([c(i,1) c(k,1)],[c(i,2) c(k,2)],[c(i,3) c(k,3)],'color','red');
        end 

        c = zeros(0,3);
       
    end
    pause(0.1);
    
end


%--------------------------------------------------------------------------

% this function takes a set of vertices [mx3] and returns a set of vertices
% inside the clip space {-1<=x<=1,-1<=y<=1,0<=z<=1} [nx3] where m<=n
function h = SHClip(b)

h = zeros(0,3); 
x = b;

for k = 1:6

    a = fix((k-1)/2) + 1;           % which dimension we're working in
    h = zeros(0,3);             % h holds the temporary set of vertices
    numVertices = size(x,1);   
    for j = 1:numVertices

        x1 = x(j,:);        
        if (j == numVertices)
            x2 = x(1,:);
        else 
            x2 = x(j+1,:);
        end

        delta = x2 - x1;   

        if (k == 1) % left            
            p = x1(1) < -1;
            q = x2(1) < -1;        
        elseif (k == 2) % right
            p = x1(1) > 1;
            q = x2(1) > 1;               
        elseif (k == 3) % bottom
            p = x1(2) < -1;
            q = x2(2) < -1;                 
        elseif (k == 4) % top
            p = x1(2) > 1;
            q = x2(2) > 1;               
        elseif (k == 5) % close
            p = x1(3) < -1;
            q = x2(3) < -1;                 
        elseif (k == 6) % far
            p = x1(3) > 1;
            q = x2(3) > 1;               
        end            

        if (p==q && p==0)
            %inside-inside: add second point
            h = [h;x2];
        elseif (p==q)
            %outside-outside: add no points
        elseif (q==0)          
            %outside-inside: add clipped and second point
            t = (((x1(a)>0)*2 - 1) - x1(a))/delta(a);
            x1 = x1 + delta*t;
            h = [h;x1;x2];
        elseif (p==0)          
            %inside-outside: add clipped point
            t = (((x2(a)>0)*2 - 1) - x2(a))/delta(a);
            x2 = x2 + delta*t;
            h = [h;x2];                     
        end

    end
    x = h;

end
