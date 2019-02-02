x=zeros(128,8);
y=x;
vx=x;
vy=x;
counter_x = 1;
counter_y = 1;
for i=1:128
    for j=1:8
        x(i,j) = round(mod(((i-1)*8+j),32)/32 *320*2^8);
        y(i,j) = round((i-1)*8+j)/(32^2)*240*2^8;
        %x(i,j) = round(rand*320*2^8);
       % y(i,j) = round(rand*240*2^8);
        vx(i,j) = round(2*(rand-.5)*2^6.5);
        vy(i,j) = round(2*(rand-.5)*2^6.5);
%         x(i,j) = 300*2^8
%         y(i,j) = 200*2^8
%         vx(i,j) = 2^6.5
%         vy(i,j) = 2^6.5

        if (vx(i,j)<0)
            vx(i,j) = bitcmp(-vx(i,j),18) + 1;
        end
        if (vy(i,j)<0)
            vy(i,j) = bitcmp(-vy(i,j),18) + 1;
        end
    end
end

p = int64(y + x*2^18)
v = int64(vy + vx*2^18)