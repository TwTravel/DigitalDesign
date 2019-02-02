% clear variables
clear all
% clear all existing UDP conntections
delete(instrfind); 

% obj = udp('remote_host_ip',remote_port, 'LocalPort', n)
% Use get(arm9) command to see all the settings
% Use set(arm9, setting, value) to change settings
% --Example set(arm9, 'LocalPort', 9090)
arm9=udp('10.236.xx.xx', 9090, 'LocalPort', 9090);
% Open as a read device
fopen(arm9);
% set an initial frequency
freq = 440;
while(freq>0)
    % send data -- 
    % need the \n to terminate the string conversion at the other end
    fprintf(arm9,'%d\n', freq);    
    freq = input('Frequency=')
end