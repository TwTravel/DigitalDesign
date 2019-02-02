% clear variables
clear all
% clear all existing UDP conntections
delete(instrfind); 
% clear cmd window
clc

% obj = udp('remote_host_ip',remote_port, 'LocalPort', n)
% Use get(arm9) command to see all the settings
% Use set(arm9, setting, value) to change settings
% --Example set(arm9, 'LocalPort', 9090)
arm9=udp('10.236.xx.xx', 9090, 'LocalPort', 9090);

% Open device
fopen(arm9);

% get some sound -- 8 KHz sample rate
%load 'handel.mat';
y = wavread('AllDigits8khz.WAV');

%convert to fixed point 1.31 format
y_fix = int32(y*(2^31));

% number of samples to send in a packet
N = 8;
% time delay junk variable
x=0;
% now send
% init count
buf = 's \n' ;
% send data -- 
fwrite(arm9, buf);
i=1; 
tic
for i=1:N:length(y_fix)-N 
   
    % format N samples into a packet
    buf = sprintf( '%d ', y_fix(i:i+N-1)); 
    % add string terminator
    buf = strcat(buf, ' \n');
    % send data -- 
    fwrite(arm9, buf);
    
end
toc
% approx 2720 packets/sec
