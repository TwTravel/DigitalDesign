% clear variables
clear all
% clear all existing UDP conntections
delete(instrfind); 

% obj = udp('remote_host_ip',remote_port, 'LocalPort', n)
% Use get(arm9) command to see all the settings
% Use set(arm9, setting, value) to change settings
% --Example set(arm9, 'LocalPort', 9090)
% replace xx with actual address
arm9=udp('10.236.xx.xx', 9090, 'LocalPort', 9090);
% Open as a read device
fopen(arm9);

while(1)
    % wait for data -- times out after about 2 seconds
    remote_data = fscanf(arm9,'%s');
    % echo to command window
    remote_data   
    % detect <control>C (in command window) to stop execution
    drawnow 
end