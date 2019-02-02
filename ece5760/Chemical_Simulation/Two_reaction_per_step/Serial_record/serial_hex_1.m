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

save Y2_MM_4096_1 num