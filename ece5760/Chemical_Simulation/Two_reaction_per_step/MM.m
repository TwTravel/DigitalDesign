figure(5);clf;

%=====open a serial connection===============================
%set its rate to 115200 baud
%terminator character is  (ACSII 13) which is <cr> or <enter>
%use fscanf(s, format) to read the port

% delete any open ports left by
% incorrectly terminated programs
fclose(instrfind) 

% define the serial object and open it
s = serial('COM1',...
    'baudrate',115200,...
    'terminator',13); 
fopen(s)

% read a few numbers from the port
% in hex format, one per line
for i=1:320
    num(i) = fscanf(s, '%x') ;
end

% release the port
fclose(s);

%===do the simulation =========================================

k1=1; % units 1/(Ms)
k_1=k1/4096; % units 1/s
k2=k1/256; % units 1/s
E0=0.25*240/2^16 ; %*240/2^16; % units M
options=[];
[t y]=ode23('mmfunc',[0 8000],[240/2^16 0 0],options,k1,k_1,k2,E0);
S=y(:,1);
ES=y(:,2);
E=E0-ES;
P=y(:,3);
plot(t,S,'kx',t,ES,'kx',t,P,'kx', 'markersize', 10,'linewidth', 2);
hold on
plot( num/2^16)