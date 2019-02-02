% CIC testing
% N2_R10_M2

clear all


Fs = 1e4;
t= 0:1/Fs:5.0 ;
y = randn(size(t)) ;
y = y+0.5*sin(2*pi*400*t) ;

%CIC lowpass and decimate
int1 = y(1) ;
int2 = int1 ;
j = 1 ;
nIF = 10 ;
last_c1 = 0;
last_c2 = 0;
last2_c1 = 0;
last2_c2 = 0;
last2_int2 = 0;
last_int2 = 0;
comb2 = zeros(1,length(t));

for i=1:length(y)
  int1 = int1 + y(i) ;
  int2 = int2 + int1 ;
  
  
  if (mod(i,nIF)==0)
    comb1 = int2 - last2_int2 ;
    comb2(j) = comb1 - last2_c1 ;
    %
    last2_int2 = last_int2 ;
    last_int2 = int2 ;
    last2_c1 = last_c1 ;
    last_c1 = comb1;
    last2_c2 = last_c2 ;
    last_c2 = comb2;
    
    j = j + 1 ;
  end
end

% now plot the tuned spectrum and signal
figure(1);clf
subplot(1,2,1)
pwelch(comb2,[256],[],[],Fs/nIF);

% compensated version
subplot(1,2,2)
[b,a] = cheby1(2, 4, 0.4);
out = filter(b,a,comb2) ;
pwelch(out,[256],[],[],Fs/nIF);
title('Compensated')
