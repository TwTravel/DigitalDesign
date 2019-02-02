% FP to 18-bit float conversion
function FP18 = FPconvertFun(x) 
% convert to fraction 0.5<m<1.0 by dividing by powers of 2
% record exponent as number of powers

exp = 128 ;
s = sign(x);
x = abs(x) ;

if (x==0)
    exp = 0;
    x = 0;
%elseif (x==1)
 %   exp = 129 ;
elseif (x-0.999999)>=0
    while ((x-0.999999)>=0)
        x = x/2;
        exp = exp + 1;
    end
elseif (x<0.5)
    while (x<0.5)
        x = x*2;
        exp = exp -  1;
    end
end

% {sign,exp[7:0],mantissa[8:0]} or  (sign==-1 )* (2^17) + exp+ x * (2^8)
FP18  = fix(  (s==-1 )* (2^17) + exp * (2^9) + x * (2^9) ) ;

% fprintf('%s \n', dec2hex(FP18))