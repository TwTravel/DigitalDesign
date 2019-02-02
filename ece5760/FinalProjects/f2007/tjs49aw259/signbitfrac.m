function a = signbitfrac (b)
a = [];

for i=1:length(b)
    if b(i)>=0
       a(i) = (fix(2^16*b(i)));
    else
       a(i) = (bitcmp(fix(2^16*-b(i)),18)+1);
    end    
end